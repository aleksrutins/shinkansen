import wisp.{type Request, type Response}
import gleam/list
import gleam/result.{unwrap}
import gleam/http.{Get}
import lustre/attribute as a
import lustre/element as e
import lustre/element/html as h
import shinkansen/pages/page.{page}
import shinkansen/pages/home/commit_card.{commit_card}
import shinkansen/search
import snag

pub fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let query = wisp.get_query(req)

  let package = list.key_find(in: query, find: "package")
  let version = list.key_find(in: query, find: "version")

  let search_placeholder =
    h.em([a.class("center")], [e.text("Search for packages...")])

  let page_str =
    page(
      "Shinkansen",
      [
        h.h1([a.class("heading")], [e.text("Shinkansen")]),
        h.p(
          [a.class("center")],
          [e.text("Find the Nix package you're looking for.")],
        ),
        h.form(
          [a.attribute("method", "GET")],
          [
            h.input([
              a.attribute("type", "text"),
              a.name("package"),
              a.placeholder("Package"),
              a.attribute(
                "value",
                package
                |> unwrap(""),
              ),
            ]),
            h.input([
              a.attribute("type", "text"),
              a.name("version"),
              a.placeholder("Version"),
              a.attribute(
                "value",
                version
                |> unwrap(""),
              ),
            ]),
            h.button([a.attribute("type", "submit")], [e.text("Search")]),
          ],
        ),
        case #(package, version) {
          #(_, Ok("")) | #(Ok(""), _) ->
            h.em([a.class("center")], [e.text("Search for packages...")])
          #(Ok(package), Ok(version)) -> search_results(package, version)
          _ -> search_placeholder
        },
      ],
    )
    |> e.to_string_builder

  wisp.ok()
  |> wisp.html_body(page_str)
}

fn search_results(package, version) {
  case search.search(package, version) {
    Ok(results) ->
      h.div(
        [a.class("flex-list")],
        results.items
        |> list.map(commit_card),
      )

    Error(e) -> {
      wisp.log_error(
        e
        |> snag.pretty_print,
      )
      h.em([a.class("center")], [e.text("Error fetching search results")])
    }
  }
}
