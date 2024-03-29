-module(ercli).
-export([main/1]).

set_speed(Command, Speed, Direction, New_direction) ->
	if
		(Direction == New_direction) or (Speed == 0) ->
			case Command of
				["+"] ->
					New_speed = Speed + 5;
				["-"] ->
					if
						Speed - 5 < 0 ->
							New_speed = 0;
						true ->
							New_speed = Speed - 5
					end;
				_ ->
					New_speed = Speed
			end;
		true -> % reduce speed to 0 if locomotive is travelling in another direction
			New_speed = 0
	end,
	New_speed.

handle_input(Address, Direction, Speed) ->
	Input = io:get_line("Command> "),
	Stripped = re:replace(Input, "\n", "", [global,{return, list}]),
	[Head|Tail] = string:split(Stripped, " "),
	if
		Head == "f" ->
			New_direction = "forward",
			New_speed = set_speed(Tail, Speed, Direction, New_direction),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, New_direction, New_speed, "none"),
			io:fwrite("forward ~p~n", [New_speed]),
			handle_input(Address, New_direction, New_speed);
		Head == "r" ->
			New_direction = "reverse",
			New_speed = set_speed(Tail, Speed, Direction, New_direction),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, New_direction, New_speed, "none"),
			io:fwrite("reverse ~p~n", [New_speed]),
			handle_input(Address, New_direction, New_speed);
		Head == "s" ->
			io:fwrite("stop~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, Direction, 0, "normal"),
			handle_input(Address, Direction, Speed);
		Head == "q" ->
			io:fwrite("quitting...~n");
		true ->
			pass,
			handle_input(Address, Direction, Speed)
	end.

main(Address) ->
	io:fwrite("Communicating with locomotive ~p~n", [Address]),
	handle_input(Address, "forward", 0).
