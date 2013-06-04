%%% @doc Simple Riak Erlang client process pool.
%%% See riakcp:exec/2 for instructions.

-module(riakcp).
-author('Martynas Pumputis <martynasp@gmail.com>').

%% Application API
-export([start/0, stop/0]).
%% API
-export([exec/2]).

-include("riakcp.hrl").

%%%============================================================================
%%% API
%%%============================================================================

%% @doc Checkout a worker and call `riakc_pb_socket:FunctionName` with given
%% Args.
%%
%% E.g. `riakcp:exec(get, [<<"a">>, <<"b">>])` asks worker to execute
%% `riakc_pb_socket:put(Pid, <<"a">>, <<"b">>)`.
-spec exec(atom(), list()) -> term().
exec(FunctionName, Args) ->
    poolboy:transaction(
        ?POOL_NAME,
        fun (Worker) ->
            erlang:apply(riakc_pb_socket, FunctionName, [Worker|Args])
        end).

%%%===========================================================================
%%% Application API
%%%===========================================================================

start() ->
    application:start(poolboy),
    application:start(?APP).

stop() ->
    application:stop(?APP),
    application:stop(poolboy).
