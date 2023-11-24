import gleam/string
import lustre/attribute as a
import lustre/element as e
import lustre/element/html as h
import shinkansen/cache.{type CommitInfo}

pub fn commit_card(commit: CommitInfo) {
  let [summary, ..description] =
    commit.commit.message
    |> string.split(on: "\n")

  h.div(
    [a.class("commit-card")],
    [
      h.p(
        [],
        [
          e.text("Archive: "),
          h.a(
            [
              a.class("sha"),
              a.href("https://github.com/NixOS/nixpkgs/commit/" <> commit.sha),
            ],
            [e.text(commit.sha <> " 🔗")],
          ),
        ],
      ),
      h.h2([], [e.text(summary)]),
      h.pre(
        [],
        [
          e.text(
            description
            |> string.join("\n"),
          ),
        ],
      ),
    ],
  )
}
