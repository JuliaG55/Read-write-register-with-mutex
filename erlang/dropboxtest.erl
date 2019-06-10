-module(dropboxtest).
-export([start/0, client/1]).

start() ->
     dropbox:start(),
     mutex:start(),
	register(tester_process, self()),
	loop("julia", "abcd", 5),
	unregister(tester_process),
	mutex:stop(),
	dropbox:stop().

loop(_, _, 0) ->
     true;

loop(String1, String2, N) ->
     dropbox:write(""),
	spawn(dropboxtest, client, [String1]),
	spawn(dropboxtest, client, [String2]),
     receive
	done -> true
     end,
     receive
	done -> true
     end,
	
	io:format("Expected string = ~ts, actual string = ~ts~n~n",
       [(String1 ++ String2), dropbox:read()]),
	loop(String1, String2, N-1).

client(Str) ->
     dropbox:upload(Str),
	tester_process ! done.
	
