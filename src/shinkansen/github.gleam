import gleam/result
import gleam/http/request
import gleam/uri

pub fn search_commits(query) {
  request.to(
    "https://api.github.com/search/commits?q=" <> uri.percent_encode(query),
  )
  |> result.map(request.set_header(_, "User-Agent", "httpc"))
}
