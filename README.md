# riakc\_pool

(Really) simple Erlang Riak client process pool based on
[riak-erlang-client][2] and [poolboy][3].

## Dependencies

* Erlang (>= R15B01)
* [rebar][1]

## Setup

`make all`

## Configuration

```erlang
[
  {pool, [
    {size, 10},
    {max_overflow, 20}
  ]},
  {riakc, [
    {address, "127.0.0.1"},
    {port, 8087},
    {options, []} % riakc_pb_socket options
  ]}
]
```

## Running application

`application:start(riakc_pool)`

## Usage

* `riakcp:exec(Function, Args)`, where `Function` is `riakc_pb_socket` module
function name and `Args` is a list of its parameters excluding `Pid`.

[1]: https://github.com/rebar/rebar
[2]: https://github.com/basho/riak-erlang-client
[3]: https://github.com/devinus/poolboy
