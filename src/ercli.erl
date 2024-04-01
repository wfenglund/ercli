-module(ercli).
-export([main/1, try_connect/2, connect_timer/1, print_info/1]).

try_connect(Address, PID) ->
	erlangZ21:get_loco_info(erlangZ21:udp_details(), Address),
	PID ! {contact}.

connect_timer(PID) ->
	timer:sleep(60000),
	PID ! {timed_out}.

set_speed(Command, Speed, Direction, New_direction) ->
	if
		(Direction == New_direction) or (Speed == 0) ->
			case Command of
				["+"] ->
					if
						Speed == 0 ->
							New_speed = 25;
						true ->
							New_speed = Speed + 5
					end;
				["-"] ->
					if
						Speed - 5 < 0 ->
							New_speed = 0;
						true ->
							New_speed = Speed - 5
					end;
				[] ->
					if
						Speed == 0 ->
							New_speed = 25;
						true ->
							New_speed = Speed
					end;
				_ ->
					New_speed = Speed
			end;
		true -> % reduce speed to 0 if locomotive is travelling in another direction
			New_speed = 0
	end,
	New_speed.

print_info(Address) ->
	timer:sleep(20000),
	erlangZ21:get_loco_info(erlangZ21:udp_details(), Address),
	print_info(Address).

handle_input(Address, Direction, Speed) ->
	Input = io:get_line("Command> "),
	Stripped = re:replace(Input, "\n", "", [global,{return, list}]),
	[Head|Tail] = string:split(Stripped, " "),
	if
		Head == "f" -> % forward drive
			New_direction = "forward",
			New_speed = set_speed(Tail, Speed, Direction, New_direction),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, New_direction, New_speed, "none"),
			io:fwrite("forward ~p~n", [New_speed]),
			handle_input(Address, New_direction, New_speed);
		Head == "r" -> % reverse drive
			New_direction = "reverse",
			New_speed = set_speed(Tail, Speed, Direction, New_direction),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, New_direction, New_speed, "none"),
			io:fwrite("reverse ~p~n", [New_speed]),
			handle_input(Address, New_direction, New_speed);
		Head == "s" -> % stop locomotive
			io:fwrite("stop~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, Direction, 0, "normal"),
			handle_input(Address, Direction, 0);
		Head == "a" -> % switch function on or off
			Num_str = re:replace(Tail, "\\D", "", [global, {return, list}]),
			case length(Num_str) > 0 of
				true ->
					Num_int = list_to_integer(Num_str),
					erlangZ21:set_loco_function(
					  erlangZ21:udp_details(), Address,
					  Num_int, "switch"),
					io:fwrite("function ~p~n", [Num_int]);
				false ->
					io:fwrite("Please supply a function number.~n")
			end,
			handle_input(Address, Direction, Speed);
		Head == "i" -> % subscribe to locomotive info
			spawn(?MODULE, print_info, [Address]),
			handle_input(Address, Direction, Speed);
		Head == "q" -> % quit ercli
			io:fwrite("quitting...~n");
		true ->
			handle_input(Address, Direction, Speed)
	end.

main(Address) ->
	spawn(?MODULE, try_connect, [Address, self()]),
	spawn(?MODULE, connect_timer, [self()]),
	receive
		{contact} ->
			io:fwrite("~nCommunicating with locomotive ~p:~n", [Address]),
			handle_input(Address, "forward", 0);
		{timed_out} ->
			io:fwrite("Could not establish contact with locomotive ~p, are you connected to the Z21?~n", [Address])
	end.
