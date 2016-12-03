-module(callback_awt).
-compile(export_all).
-behaviour(gen_server).

init(StartSet) ->
    {ok, StartSet}.

terminate(Reason, State) ->
	io:format("Servere terminated with state and reason: ~p, ~p~n", [State, Reason]),
	ok.

handle_call(Amount, _From, Banknotes) ->
	try awt:withdraw(Banknotes, Amount) of
		{ok, CollectedBanknotes, RestBanknotes} ->
			{reply,CollectedBanknotes,RestBanknotes};
		{request_another_amount, [], StartSet} ->
			{reply, request_another_amount, StartSet}
	catch
	throw:"No banknotes in me!" ->
		io:format("No money in me! Please, wait for replenishment~n"),
		{reply, wait_for_replenishment, [{100, 3}, {1000, 2}, {500, 2}]}
	end.

%%	case awt:withdraw(Banknotes, Amount) of
%%		{ok, CollectedBanknotes, RestBanknotes} ->
%%			{reply,CollectedBanknotes,RestBanknotes};
%%		{request_another_amount, [], StartSet} ->
%%			{reply, request_another_amount, StartSet}
%%	end.


handle_info(Info, CurrentState) ->
    io:format("Got handle_info: ~p~n", [Info]),
    {noreply, CurrentState}.


code_change(OldVsn, CurrentState, Extra) ->
    io:format("Hot code upgrade from version: ~p with extra info:~p~n", [OldVsn,Extra]),
    {ok, CurrentState}.


handle_cast(Request, CurrentState) ->
    io:format("Cast request: ~p~n", [Request]),
    {noreply, CurrentState}.
