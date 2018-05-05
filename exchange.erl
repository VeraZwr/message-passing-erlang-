%% @author Vera Zhao
%% @doc @todo Add description to exchange.

-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0,info/0]).
-import(calling,[start/1,in/1]).
%% ====================================================================
%% Internal functions
%% ====================================================================

 %io:fwrite("~w~n",[1000000000 * MegaSecs + Secs * 1000 + MicroSecs div 1000]).

info()->
	receive
		{From,To,intro,Time}->
			io:fwrite("~w received intro message from ~w [~w]~n",[To,From,Time]),
			info();
		{From,To,reply,Time}->
			io:fwrite("~w received reply message from ~w [~w]~n",[To,From,Time]),
			info()
	after 1500->
		io:fwrite("Master has received no replies for 1.5 seconds, ending...~n")
	end.

main() ->
	    register(master, spawn(exchange,info, [])),
	    {ok,Content}=file:consult("calls.txt"),
        Mp=maps:from_list(Content),
		
		Fun1 = fun(K,V,ok) -> io:fwrite("~w: ~w ~n",[K,V]),
							 start(K),
							% io:fwrite("~w~n", [registered()]),
							 lists:foreach(fun(X) -> 
											ok				   
										    end, V)
							 end,
  		maps:fold(Fun1,ok,Mp),
		
		Fun2 = fun(K,V,ok) ->% io:fwrite("~w: ~w ~n~n",[K,V]),
							 
							 lists:foreach(fun(X) ->
												   %{MegaSecs, Secs, MicroSecs} = erlang:now(),
												   %random:seed(MicroSecs),
												   timer:sleep(round(timer:seconds(0.1*(rand:uniform())))),
												   whereis(K) ! {X, "in"}
												 
												
										    end, V)
							 end,
 		%io:fwrite("~w~n", [registered()]),
		maps:fold(Fun2,ok,Mp).


		