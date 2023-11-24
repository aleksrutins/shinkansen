import gleam/erlang/os
import gleam/erlang/process
import gleam/result.{flatten, map, unwrap}
import gleam/int
import wisp
import mist
import radiate
import shinkansen/router
import shinkansen/cache

pub fn main() {
  let _ =
    radiate.new()
    |> radiate.add_dir("src")
    |> radiate.on_reload(fn(_, path) {
      wisp.log_info("Change in " <> path <> ", reloading!")
    })
    |> radiate.start()

  cache.start_redis()
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let port =
    map(over: os.get_env("PORT"), with: int.base_parse(_, 10))
    |> flatten
    |> unwrap(8080)

  let assert Ok(_) =
    wisp.mist_handler(router.handle_request, secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}
