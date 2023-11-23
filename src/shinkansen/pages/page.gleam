import lustre/attribute.{attribute as a}
import lustre/element/html as h

pub fn page(title, content) {
  h.html(
    [a("lang", "en")],
    [
      h.head(
        [],
        [
          h.title([], title),
          h.link([a("rel", "stylesheet"), a("href", "/static/app.css")]),
        ],
      ),
      h.body([], [h.main([], content)]),
    ],
  )
}
