@external(erlang, "shinkansen_cache", "start_redis")
pub fn start_redis() -> Nil

@external(erlang, "shinkansen_cache", "put")
pub fn put(
  package: String,
  version: String,
  archive: String,
) -> Result(String, String)
