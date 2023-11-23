-module(shinkansen_cache).
-export([start_redis/0, put/3]).

start_redis() ->
    Host = os:getenv("REDISHOST", "127.0.0.1"),
    {Port, []} = string:to_integer(os:getenv("REDISPORT", "6379")),
    
    Username = os:getenv("REDISUSER"),
    UsernameField = case Username of
        false -> [];
        Name -> [{username, Name}]
    end,
    Password = os:getenv("REDISPASSWORD"),
    PasswordField = case Password of
        false -> [];
        Pass -> [{password, Pass}]
    end,

    {ok, Redis} = eredis:start_link([
        {host, Host},
        {port, Port}
    ] ++ UsernameField ++ PasswordField),
    register(redis_proc, Redis),
    [].

put(Package, Version, Archive) ->
    eredis:q(redis_proc, ["SET", Package ++ "@" ++ Version, Archive]).