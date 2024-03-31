# ercli
The Erlang Railroad Command Line Interface.

## How to run
In the terminal:
```bash
$ cd ercli/
$ rebar3 shell
```
In the erlang shell:
```erlang
1> ercli:main(1). % where 1 is the locomotive address
command> f + % increase forward speed
command> f + % increase further
command> f - % reduce forward speed
command> r % reverse drive
command> s % stop
command> a 0 % activate locomotive function 0
command> a 0 % deactivate locomotive function 0
command> q % quit
```
