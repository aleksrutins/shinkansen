import wisp

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  use <- wisp.serve_static(req, under: "/static", from: static_directory())

  handle_request(req)
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("shinkansen")
  priv_directory <> "/static"
}
