# riakc\_baseinas

(Really) simple Erlang Riak client process pool based on
[riak-erlang-client][2] and [poolboy][3].

## Dependencies

* Erlang (>= R15B01)
* [rebar][1]

## Setup

`make all`

## Configuration

See `src/riakc_pool.app.src`.

## Running application

`application:start(riakc_pool)`

## Usage

See `riakcp:exec/2`.

[1]: https://github.com/rebar/rebar
[2]: https://github.com/basho/riak-erlang-client
[3]: https://github.com/devinus/poolboy
