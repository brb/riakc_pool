%%% @doc Simple Riak Erlang client process pool.
%%% See riakcp:exec/2 for instructions.

-module(riakcp).
-author('Martynas Pumputis <martynasp@gmail.com>').

%% API
-export([start/0, stop/0, exec/2, exec/3]).

-include("riakcp.hrl").

-define(TIMEOUT, 5000). % Default poolboy worker timeout

%%%============================================================================
%%% API
%%%============================================================================

%% @doc Checkout a worker and call `riakc_pb_socket:FunctionName` with given
%% Args.
%% E.g. `riakcp:exec(get, [<<"a">>, <<"b">>])` asks worker to execute
%% `riakc_pb_socket:put(Pid, <<"a">>, <<"b">>)`.
%%
%% NOTE: The Timeout is for poolboy worker, but not for riak client!
-spec exec(atom(), list()) -> term().
exec(FunctionName, Args) ->
    exec(FunctionName, Args, get_timeout()).

-spec exec(atom(), list(), pos_integer()) -> term().
exec(FunctionName, Args, Timeout) ->
    poolboy:transaction(
        ?POOL_NAME,
        fun (Worker) ->
            erlang:apply(riakc_pb_socket, FunctionName, [Worker|Args])
        end,
        Timeout).



start() -> application:start(?APP).

stop() -> application:stop(?APP).

%% ----------------------------------------------------------------------------

get_timeout() ->
    case application:get_env(?APP, pool_worker_timeout) of
        undefined                   -> ?TIMEOUT;
        {ok, V} when is_integer(V)  -> V
    end.
