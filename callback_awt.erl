-module(callback_awt).
-compile(export_all).
-behaviour(gen_server).

init([StartSet]) ->
    {ok, StartSet}.

terminate(shutdown, State) ->
    ok.

handle_call({Banknotes, Amount}, _From, RestBanknotes) ->
	{ok, CollectedBanknotes, RestBanknotes} = awt:withdraw(RestBanknotes, Amount),
	{reply,CollectedBanknotes,RestBanknotes}.


handle_info(Info, CurrentState) ->
    io:format("Got handle_info: ~p~n", [Info]),
    {noreply, CurrentState}.


code_change(OldVsn, CurrentState, Extra) ->
    io:format("Hot code upgrade from version: ~p with extra info:~p~n", [OldVsn,Extra]),
    {ok, CurrentState}.



