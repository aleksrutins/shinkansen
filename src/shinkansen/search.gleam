import gleam/int
import gleam/list
import gleam/string
import gleam/result.{try}
import gleam/dynamic.{type Dynamic}
import gleam/httpc
import shinkansen/cache.{type SearchResults, SearchResults}
import shinkansen/github
import snag

pub type SearchError {
  RequestBorked(Dynamic)
  RequestFailed(status: Int)
  DecodeFailed(Nil)
}

pub fn search(package: String, version: String) -> snag.Result(SearchResults) {
  // try to fetch from Redis first
  cache.get(package, version)
  |> result.try_recover(with: fn(_) {
    // fall back to GitHub
    github.search_commits(package <> " " <> version <> " repo:NixOS/nixpkgs")
    |> result.map_error(fn(_) { snag.new("Failed to build request") })
    |> result.map(fn(req) {
      httpc.send(req)
      |> result.map_error(fn(_) { snag.new("Failed to send request") })
    })
    |> result.flatten
    |> result.map(fn(resp) {
      case resp.status {
        200 ->
          resp.body
          |> cache.decode_search_results
        status ->
          snag.error("Request failed with status " <> int.to_string(status))
      }
    })
    |> result.flatten
    |> result.map(fn(results: SearchResults) {
      SearchResults(
        items: results.items
        |> list.filter(fn(commit) {
          commit.commit.message
          |> string.starts_with(package <> ":")
        }),
      )
    })
    |> try(fn(value) {
      cache.put(package, version, value)
      |> result.map(fn(_) { value })
    })
    |> snag.context("Fetching commits from GitHub")
  })
}
