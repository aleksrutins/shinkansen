import gleam/string_builder
import wisp.{type Request, type Response}
import shinkansen/web
import shinkansen/api
import shinkansen/pages/home

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home.home_page(req)
    ["api", "health"] ->
      wisp.ok()
      |> wisp.json_body(
        "{\"status\":\"ok\"}"
        |> string_builder.from_string,
      )
    ["api", package, version] -> api.search_api(req, package, version)
    _ -> wisp.not_found()
  }
}
