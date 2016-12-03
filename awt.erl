-module(awt).
-export_type([banknotes/0]).
-export([withdraw/2]).
-compile(export_all).

-include_lib("my_lib.hrl"). 

%% How to give descriptive names to function arguments?
-spec withdraw([banknotes()], integer) -> {ok, banknotes(), banknotes()} | {request_another_amount, [], [banknotes()]}.

withdraw(RestBanknotes, RequiredSumm) ->
	case RestBanknotes of
		[] ->
			throw("No banknotes in me!");
		_ ->
			withdraw([], lists:reverse(lists:sort(RestBanknotes)), RequiredSumm, RestBanknotes)
	end.

withdraw(CollectedBanknotes, _RestBanknotes, 0, StartSet) ->
	{ok, CollectedBanknotes, get_rest(CollectedBanknotes, StartSet)};

withdraw(_CollectedBanknotes, [], _RequiredSumm, StartSet) ->
	{request_another_amount, [], StartSet};

withdraw(CollectedBanknotes, RestBanknotes, RequiredSumm, StartSet) ->
		[{Denomination, Amount} | Tl] = RestBanknotes,
		DesirableAmount = RequiredSumm div Denomination,
		if
			DesirableAmount > Amount ->
				TakenAmount = Amount;
			true ->
				TakenAmount = DesirableAmount
		end,
		withdraw([{Denomination, TakenAmount} | CollectedBanknotes], Tl, RequiredSumm - TakenAmount * Denomination, StartSet).

%% example withdraw([{Denomination, Amount}], RequiredSumm)
%%	-> 	{ok, CollectedBanknotes, RestBanknotes}
%% awt:withdraw([{100, 3}, {1000, 2}, {500, 2}], 1200).

%% Substraction first list from second. First list is smaller, it should end first
get_rest(Subtrahend, Minuend) ->
	get_rest(Subtrahend, Minuend, []).

get_rest([], Minuend, Result) ->
	lists:sort(Result ++ Minuend);

get_rest([{Denomination, Amount}|Tl], Minuend, Result) ->
	[Extracted] = extract_denomination(Minuend, Denomination),
	{_ExtractedDenomination, ExtractedAmount} = Extracted,
	if
		ExtractedAmount - Amount == 0 ->
			get_rest(Tl, Minuend -- [Extracted], Result);
		ExtractedAmount - Amount > 0 ->
			get_rest(Tl, Minuend -- [Extracted], [{Denomination, ExtractedAmount - Amount} | Result])
	end.

extract_denomination(List, RequiredDenomination) ->
	lists:filtermap(fun({Denomination, _Amount}) -> 
			RequiredDenomination == Denomination end
			, List).
get_element_by_index([Hd|Tl], Index) when Index >= 0 ->
	if 
		Index == 0 ->
			Hd;
		Tl == [] ->
			throw("Index is greater than list length");
		true ->
			get_element_by_index(Tl, Index - 1)
	end.
	
	
