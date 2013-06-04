-module(riakcp_sup).
-author('Martynas Pumputis <martynasp@gmail.com>').

-behaviour(supervisor).

-include("riakcp.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%%%============================================================================
%%% API functions
%%%============================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%============================================================================
%%% Supervisor callbacks
%%%============================================================================

init([]) ->
    PoolEnv = get_env(pool, []),
    PoolSize = proplists:get_value(size, PoolEnv, ?POOL_SIZE),
    PoolMaxOverflow = proplists:get_value(max_overflow, PoolEnv,
                                          ?POOL_MAX_OVERFLOW),
    PoolArgs = [{name, {local, ?POOL_NAME}},
                {worker_module, riakcp_worker},
                {size, PoolSize}, {max_overflow, PoolMaxOverflow}],
    RiakCArgs = get_env(riakc, []),
    PoolSpec = poolboy:child_spec(?POOL_NAME, PoolArgs, RiakCArgs),

    {ok, {{one_for_one, 1, 10}, [PoolSpec]}}.

%%%============================================================================
%%% Internal functions
%%%============================================================================

get_env(Key, Default) ->
    case application:get_env(?APP, Key) of
        {ok, Val} -> Val;
        undefined -> Default
    end.
