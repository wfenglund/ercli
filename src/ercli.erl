-module(ercli).
-export([main/1]).

handle_input() ->
	Input = io:get_line("Command> "),
	if
		Input == "F\n" ->
			io:fwrite("forward~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), 3, "forward", 26, "none"),
			handle_input();
		Input == "R\n" ->
			io:fwrite("reverse~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), 3, "reverse", 26, "none"),
			handle_input();
		Input == "S\n" ->
			io:fwrite("stop~n"),
			erlangZ21:drive_train(erlangZ21:udp_details(), 3, "forward", 0, "normal"),
			handle_input();
		Input == "q\n" ->
			io:fwrite("quitting...~n");
		true ->
			pass,
			handle_input()
	end.

main(_Args) ->
	handle_input().
