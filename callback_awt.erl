-module(callback_awt).
-compile(export_all).
-behaviour(gen_server).

init([StartSet]) ->
    {ok, StartSet}.

terminate(shutdown, State) ->
    ok.

handle_call({Banknotes, Amount}, _From, RestBanknotes) ->
	case  awt:withdraw([Banknotes, Amount) of
		{ok, State,

