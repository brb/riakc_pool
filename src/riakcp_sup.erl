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
    PoolSize = get_env(pool_size, ?POOL_SIZE),
    PoolMaxOverflow = get_env(pool_max_overflow, ?POOL_MAX_OVERFLOW),
    PoolArgs = [{name, {local, ?POOL_NAME}},
                {worker_module, riakcp_worker},
                {size, PoolSize}, {max_overflow, PoolMaxOverflow}],

    RiakAddr = get_env(riak_address, ?RIAK_ADDR),
    RiakPort = get_env(riak_port, ?RIAK_PORT),
    RiakOpts = get_env(riak_options, []),
    RiakArgs = {RiakAddr, RiakPort, RiakOpts},

    PoolSpec = poolboy:child_spec(?POOL_NAME, PoolArgs, RiakArgs),

    {ok, {{one_for_one, 1, 10}, [PoolSpec]}}.

%%%============================================================================
%%% Internal functions
%%%============================================================================

get_env(Key, Default) ->
    case application:get_env(?APP, Key) of
        {ok, Val} -> Val;
        undefined -> Default
    end.
