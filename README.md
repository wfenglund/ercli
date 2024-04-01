# ercli
The Erlang Railroad Command Line Interface.

## Build
In the terminal:
```bash
$ git clone https://github.com/wfenglund/ercli
$ cd ercli/
$ rebar3 compile
```
## Use
In the terminal:
```bash
$ cd ercli/ # not necessary if you are already in this directory
$ rebar3 shell
```
In the rebar3/erlang shell, make sure that you are connected to the Z21:
```erlang
1> ercli:main(1). % where 1 is the locomotive address
Command> f % increase forward speed
Command> i % subscribe to loco info
Command> f + % increase forward speed
Command> f - % reduce forward speed
Command> s % stop
Command> r % reverse drive
Command> a 0 % activate locomotive function 0
Command> a 0 % deactivate locomotive function 0
Command> q % quit
```
