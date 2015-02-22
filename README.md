# rethink
[![Build Status](https://travis-ci.org/EddyShure/rethink.svg)](https://travis-ci.org/EddyShure/rethink)
[![Inline docs](http://inch-ci.org/github/EddyShure/rethink.svg?branch=master)](http://inch-ci.org/github/EddyShure/rethink)
Tested with RethinkDB v1.16.2

Rethink is a client driver for RethinkDB. It is written in pure Elixir.

## Usage

Add Rethink as a dependency in your `mix.exs` file.

```elixir
def deps do
  [{:rethink, github: "EddyShure/rethink"}]
end
```

```iex
iex> {:ok, pid} = Rethink.Connection.start_link(hostname: "localhost", port: 28015, database: "test")
{:ok, #PID<0.42.0>}
```

### Using Rethink in your OTP application

TODO

## Resources

* Official driver spec: http://rethinkdb.com/docs/driver-spec/
* Official Ruby client driver doc: http://rethinkdb.com/api/ruby/
* Official protocol specification: https://github.com/rethinkdb/rethinkdb/blob/v1.16.x/src/rdb_protocol/ql2.proto

## Donate

[![Support via Gratipay](https://cdn.rawgit.com/gratipay/gratipay-badge/2.3.0/dist/gratipay.png)](https://gratipay.com/EddyShure/)
