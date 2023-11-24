import gleam/list
import gleam/result.{try}
import gleam/bit_array
import gleam/dynamic.{field, list, string}
import gleam/json.{array, object, string as jstring}
import snag

pub type CommitInfoCommit {
  CommitInfoCommit(message: String)
}

pub type CommitInfo {
  CommitInfo(url: String, sha: String, commit: CommitInfoCommit)
}

pub type SearchResults {
  SearchResults(items: List(CommitInfo))
}

fn encode_search_results(data: SearchResults) -> String {
  object([
    #(
      "items",
      array(
        data.items
        |> list.map(fn(item) {
          [
            #("url", jstring(item.url)),
            #("sha", jstring(item.sha)),
            #("commit", object([#("message", jstring(item.commit.message))])),
          ]
        }),
        of: object,
      ),
    ),
  ])
  |> json.to_string
}

pub fn decode_search_results(data: String) {
  dynamic.decode1(
    SearchResults,
    field(
      "items",
      of: list(dynamic.decode3(
        CommitInfo,
        field("url", of: string),
        field("sha", of: string),
        field(
          "commit",
          of: dynamic.decode1(CommitInfoCommit, field("message", of: string)),
        ),
      )),
    ),
  )
  |> json.decode(from: data, using: _)
  |> result.map_error(fn(_) { snag.new("Failed to decode search results") })
}

@external(erlang, "shinkansen_cache_ffi", "start_redis")
pub fn start_redis() -> Nil

@external(erlang, "shinkansen_cache_ffi", "stop_redis")
pub fn stop_redis() -> Nil

@external(erlang, "shinkansen_cache_ffi", "put")
fn internal_put(
  package: String,
  version: String,
  results: String,
) -> Result(String, String)

pub fn put(package: String, version: String, results: SearchResults) {
  internal_put(package, version, encode_search_results(results))
  |> result.map_error(snag.new)
}

@external(erlang, "shinkansen_cache_ffi", "get")
fn internal_get(package: String, version: String) -> Result(BitArray, a)

pub fn get(package: String, version: String) -> snag.Result(SearchResults) {
  internal_get(package, version)
  |> result.map_error(fn(_) { snag.new("Failed to get result") })
  |> try(fn(arr) {
    result.map_error(
      bit_array.to_string(arr),
      fn(_) { snag.new("Invalid UTF-8 in result") },
    )
  })
  |> try(decode_search_results)
}
