import wisp.{type Request, type Response}
import shinkansen/web
import shinkansen/pages/home

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home.home_page(req)
    _ -> wisp.not_found()
  }
}
