import wisp.{type Request, type Response}
import shinkansen/web

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    _ -> wisp.not_found()
  }
}
