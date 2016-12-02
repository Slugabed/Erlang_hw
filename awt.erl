-module(awt).
-export_type([banknotes/0]).
-export([withdraw/2]).


-include_lib("my_lib.hrl"). 

%% How to give descriptive names to function arguments?
-spec withdraw([banknotes()], integer) -> {ok, banknotes(), banknotes()} | {request_another_amount, [], [banknotes()]}.

withdraw(Banknotes, Amount) ->
	withdraw([], Banknotes, Amount, Banknotes).

withdraw(CollectedBanknotes, RestBanknote, 0, _StartSet) ->
	{ok, CollectedBanknotes, RestBanknote};

withdraw(_CollectedBanknotes, [], _Amount, StartSet) ->
	{request_another_amount, [], StartSet};

withdraw(CollectedBanknotes, RestToSearch, Amount, StartSet) ->
		[{DenominationAmount, Value} | Tl] = RestToSearch,
		DesirableAmount = Amount div Value,
		if
			DesirableAmount > DenominationAmount ->
				TakenAmount = DenominationAmount;
			true ->
				TakenAmount = DesirableAmount
		end,
		withdraw([#banknote{amount = TakenAmount, value =Value} | CollectedBanknotes], Tl, Amount - TakenAmount * Value, StartSet).

%% find intersection by iterating by first function list argument
%%intersection(A, B) ->
%%	intersection(A, B, []).
%%
%%intersection([], _B, Intersection) ->
%%	Intersection;
%%
%%intersection(A, B, Intersection)	->
%%	case A of
%%		[{DenominationAmount, Value}] ->
				
