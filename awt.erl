-module(awt).
-export_type([banknotes/0]).
-export([withdraw/2]).
-compile(export_all).

-include_lib("my_lib.hrl"). 

%% How to give descriptive names to function arguments?
-spec withdraw([banknotes()], integer) -> {ok, banknotes(), banknotes()} | {request_another_amount, [], [banknotes()]}.

withdraw(Banknotes, Amount) ->
	withdraw([], lists:reverse(lists:sort(Banknotes)), Amount, Banknotes).

withdraw(CollectedBanknotes, _RestBanknote, 0, StartSet) ->
	{ok, CollectedBanknotes, get_rest(CollectedBanknotes, StartSet)};

withdraw(_CollectedBanknotes, [], _Amount, StartSet) ->
	{request_another_amount, [], StartSet};

withdraw(CollectedBanknotes, RestToSearch, Amount, StartSet) ->
		[{Value, DenominationAmount} | Tl] = RestToSearch,
		DesirableAmount = Amount div Value,
		if
			DesirableAmount > DenominationAmount ->
				TakenAmount = DenominationAmount;
			true ->
				TakenAmount = DesirableAmount
		end,
		withdraw([{Value, TakenAmount} | CollectedBanknotes], Tl, Amount - TakenAmount * Value, StartSet).

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

%% Substraction first list from second. First list is smaller, it should end first
get_rest(Subtrahend, Minuend) ->
	get_rest(Subtrahend, Minuend, []).

get_rest([], Minuend, Result) ->
	lists:sort(Result ++ Minuend);

get_rest([{Value, DenominationAmount}|Tl], Minuend, Result) ->
	[Extracted] = extract_denomination(Minuend, Value),
	{_ExtractedValue, ExtractedAmount} = Extracted,
	get_rest(Tl, Minuend -- [Extracted], [{Value, ExtractedAmount - DenominationAmount} | Result]).

extract_denomination(List, RequiredDenomination) ->
	lists:filtermap(fun({Value, _DenominationAmount}) -> 
			RequiredDenomination == Value end
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
	
	
