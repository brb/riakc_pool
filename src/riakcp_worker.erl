%%% @doc Dummy wrapper over `riakc_pb_socket` (because `riakc_pb_socket`
%%% does not export start_link/1 which is needed by `poolboy` in order to pass
%%% arguments to a worker.

-module(riakcp_worker).
-author('Martynas Pumputis <martynasp@gmail.com>').

-include("riakcp.hrl").

-export([start_link/1]).

%%%============================================================================

%% @doc Start riakc_pb_socket process.
-spec start_link({riakc_pb_socket:address(), riakc_pb_socket:portnum(),
                  list()}) -> {ok, pid()} | {error, term()}.
start_link({Addr, Port, Opts}) ->
    riakc_pb_socket:start_link(Addr, Port, Opts).
