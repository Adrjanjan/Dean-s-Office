-module(random_student).

-export([random_student/0]).

random_name(Position) ->
    lists:nth(1 + Position rem 6,
	      ['Lucjan', 'Urszula', 'Dominik', 'Zbigniew', 'Ilona',
	       'Edyta']).

random_surname(Position) ->
    lists:nth(1 + Position rem 6,
	      ['Duk', 'Elk', 'Bok', 'Ilk', 'Lis', 'Esk']).

random_case(Position) ->
    lists:nth(1 + Position rem 6,
	      ['zaswiadczenie', 'pieczatka', 'warunek', 'stypendium', 'skarga',
	       'urlop dziekanski']).

random_student() ->
      {student, random_name(rand:uniform(20)),
       random_surname(rand:uniform(20)),
       random_case(rand:uniform(20))}.
