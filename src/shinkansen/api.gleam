import gleam/string_builder
import gleam/http.{Get}
import wisp.{type Request}
import snag
import shinkansen/search
import shinkansen/cache

pub fn search_api(req: Request, package: String, version: String) {
  use <- wisp.require_method(req, Get)

  case search.search(package, version) {
    Ok(result) ->
      wisp.ok()
      |> wisp.json_body(
        cache.encode_search_results(result)
        |> string_builder.from_string,
      )
    Error(e) -> {
      snag.pretty_print(e)
      |> wisp.log_error
      wisp.unprocessable_entity()
    }
  }
}
