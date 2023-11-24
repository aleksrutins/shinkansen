import gleeunit/should
import shinkansen/cache

pub fn cache_basic_test() {
  cache.start_redis()

  let mock_search =
    cache.SearchResults(items: [
      cache.CommitInfo(
        commit: cache.CommitInfoCommit(message: "Hello, world!"),
        sha: "b53str1a",
        url: "https://an.url",
      ),
    ])

  cache.put("hello", "10", mock_search)
  |> should.be_ok

  cache.get("hello", "10")
  |> should.be_ok

  cache.stop_redis()
}
