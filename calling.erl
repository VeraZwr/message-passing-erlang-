%% @author Vera Zhao
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1,in/1]).
-import(exchange,[main/0]).


%% ====================================================================
%% Internal functions
%% ====================================================================


start(X)-> 
	register(X, spawn(calling, in, [X])).

in(Name) ->
	
    receive
		{From,"in"}->
			{MegaSecs, Secs, MicroSecs} = erlang:now(),
			%io:fwrite("get into into "),
			whereis(master)!{From,Name,intro,MicroSecs},
			%rand:seed(Time),
			timer:sleep(round(timer:seconds(0.1*(rand:uniform())))),
			whereis(From)!{Name,"re",MicroSecs},
			in(Name);
	

        {From, "re",Time} ->
			
			whereis(master)!{From,Name,reply,Time},
			in(Name)
	
		after 1000->io:fwrite("Process ~w has received on calls for 1 second, ending...~n",[Name])
    end.

