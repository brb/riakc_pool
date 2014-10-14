-module(riakcp_tests).

-include_lib("eunit/include/eunit.hrl").
-include("riakcp.hrl").

-compile(export_all).

-define(BUCKET, <<"riakcp_tests">>).
-define(KEY, <<"foobar">>).

%%%=============================================================================

%% Assumes that Riak listener is running on tcp://127.0.0.1:8087.
riakcp_test_() ->
    {foreach,
        fun () -> ok = application:start(?APP) end,
        fun (_) ->
            ok = riakcp:exec(delete, [?BUCKET, ?KEY]),
            ok = application:stop(?APP)
        end,
        [
            {"put/get",
                fun test_put_and_get/0},
            {"poolboy timeout",
                fun test_poolboy_timeout/0}
        ]
    }.

test_put_and_get() ->
    ?assertEqual(pong, riakcp:exec(ping, [])),

    Object = riakc_obj:new(?BUCKET, ?KEY, <<"qux">>),
    ?assertMatch(ok, riakcp:exec(put, [Object])),

    % Check whether default pool worker value is taken
    application:unset_env(?APP, pool_worker_timeout),
    ?assertMatch({ok, _}, riakcp:exec(get, [?BUCKET, ?KEY])).

test_poolboy_timeout() ->
    ?assertExit({timeout, _}, riakcp:exec(get, [?BUCKET, ?KEY], 0)).
