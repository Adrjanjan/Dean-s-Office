-module(fifo).

-export([new/0, push/2, pop/1, not_empty/1]).

new() -> {fifo, [], []}.

push({fifo, In, Out}, X) -> {fifo, [X|In], Out}.

pop({fifo, [], []}) -> erlang:error('empty fifo');
pop({fifo, In, []}) -> pop({fifo, [], lists:reverse(In)});
pop({fifo, In, [H|T]}) -> {H, {fifo, In, T}}.

not_empty({fifo, [], []}) -> false;
not_empty({fifo, _, _}) -> true.
