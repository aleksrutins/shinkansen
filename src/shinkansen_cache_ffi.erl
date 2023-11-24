-module(shinkansen_cache_ffi).
-export([start_redis/0, stop_redis/0, put/3, get/2]).
-import(eredis, []).

getenv_opt(Var) ->
    case os:getenv(Var) of
        false -> undefined;
        Value -> Value
    end.

start_redis() ->
    Host = os:getenv("REDISHOST", "127.0.0.1"),
    {Port, []} = string:to_integer(os:getenv("REDISPORT", "6379")),

    {ok, Redis} = eredis:start_link([
        {host, Host},
        {port, Port},
        {username, fun() -> getenv_opt("REDISUSER") end},
        {password, fun() -> getenv_opt("REDISPASSWORD") end}
    ]),
    register(redis_proc, Redis),
    [].

stop_redis() ->
    eredis:stop(redis_proc).

version_specifier(Package, Version) -> lists:concat([Package, "@", Version]).

put(Package, Version, Results) ->
    eredis:q(redis_proc, ["SET", version_specifier(Package, Version), Results]).

get(Package, Version) ->
    eredis:q(redis_proc, ["GET", version_specifier(Package, Version)]).