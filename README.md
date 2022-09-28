# GraphqlApi

## Authentication

To run mutations in the GraphiQL interface, click on "HTTP HEADERS" at the bottom of the
page.

Add new header "authentication", plus the secret key (cf. config.exs)

## To run application on 2 nodes

Run 

```
iex --sname node_a@localhost -S mix phx.server
```
in the first terminal.

In the second terminal, run
```
PORT=4001 iex --sname node_b@localhost -S mix phx.server
```