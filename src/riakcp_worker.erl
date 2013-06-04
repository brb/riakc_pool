%%% @doc Dummy wrapper over `riakc_pb_socket` (because `riakc_pb_socket`
%%% does not export start_link/1 which is needed by `poolboy` in order to pass
%%% arguments to a worker.

-module(riakcp_worker).
-author('Martynas Pumputis <martynasp@gmail.com>').

-include("riakcp.hrl").

-export([start_link/1]).

-type arg() :: {address, riakc_pb_socket:address()} |
               {port, riakc_pb_socket:portnum()} |
               {options, list()}.
-type args() :: [arg()].

%%%============================================================================

%% @doc Start riakc_pb_socket process.
-spec start_link(args()) -> {ok, pid()} | {error, term()}.
start_link(Args) ->
    Addr = proplists:get_value(address, Args, ?RIAK_ADDR),
    Port = proplists:get_value(port, Args, ?RIAK_PORT),
    Opts = proplists:get_value(options, Args, []),

    riakc_pb_socket:start_link(Addr, Port, Opts).
