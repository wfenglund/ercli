-module(ercli).
-export([main/1]).

handle_input(Address) ->
	Input = io:get_line("Command> "),
	if
		Input == "F\n" ->
			io:fwrite("forward~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, "forward", 26, "none"),
			handle_input(Address);
		Input == "R\n" ->
			io:fwrite("reverse~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, "reverse", 26, "none"),
			handle_input(Address);
		Input == "S\n" ->
			io:fwrite("stop~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), Address, "forward", 0, "normal"),
			handle_input(Address);
		Input == "q\n" ->
			io:fwrite("quitting...~n");
		true ->
			pass,
			handle_input(Address)
	end.

main(Address) ->
	io:fwrite("Communicating with locomotive ~p~n", [Address]),
	handle_input(Address).
