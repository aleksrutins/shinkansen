-module(shinkansen_cache).
-export([start_redis/0, put/3]).

start_redis() ->
    {ok, Redis} = eredis:start_link([
        {host, os:getenv("REDISHOST")},
        {port, os:getenv("REDISPORT")},
        {username, os:getenv("REDISUSER")},
        {password, os:getenv("REDISPASSWORD")}]),
    register(redis_proc, Redis),
    [].

put(Package, Version, Archive) ->
    eredis:q(redis_proc, ["SET", Package ++ "@" ++ Version, Archive]).