import wisp.{type Request, type Response}
import gleam/http.{Get}
import lustre/attribute.{attribute as a}
import lustre/element as e
import lustre/element/html as h
import shinkansen/pages/page.{page}

pub fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let page_str =
    page("Home", [])
    |> e.to_string_builder

  wisp.ok()
  |> wisp.html_body(page_str)
}
