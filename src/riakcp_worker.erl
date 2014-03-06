%%% @doc Dummy wrapper over `riakc_pb_socket` (because `riakc_pb_socket`
%%% does not export start_link/1 which is needed by `poolboy` in order to pass
%%% arguments to a worker.

-module(riakcp_worker).
-author('Martynas Pumputis <martynasp@gmail.com>').

-behaviour(poolboy_worker).

-include("riakcp.hrl").

-export([start_link/1]).

%%%============================================================================

-type portnum() :: non_neg_integer(). %% The TCP port number of the Riak node's Protocol Buffers interface
-type address() :: string() | atom() | inet:ip_address(). %% The TCP/IP host name or address of the Riak node

%% @doc Start riakc_pb_socket process.
-spec start_link([{addr, address()} | {port, portnum()} | {opts, list()}] |
                 {address(), portnum(), list()}) -> {ok, pid()} | {error, term()}.
start_link(Args) when is_list(Args) ->
    start_link({proplists:get_value(addr, Args),
                proplists:get_value(port, Args),
                proplists:get_value(opts, Args)});
start_link({Addr, Port, Opts}) ->
    riakc_pb_socket:start_link(Addr, Port, Opts).
