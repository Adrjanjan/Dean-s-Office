-module(processing).

-export([process_student_request/4]).

process_student_request('zaswiadczenie', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p przyszedł z zaświadczeniem do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier());

process_student_request('pieczatka', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p po pieczatke do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier());

process_student_request('warunek', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p przyszedł z wnioskiem o wpis z warunkiem do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier());

process_student_request('stypendium', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p przyszedł z wnioskiem o stypendium  do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier());

process_student_request('skarga', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p przyszedł ze skargą do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier());

process_student_request('urlop dziekanski', {student, Name, Surname, _Case}, Processing_time, AssistantsName) ->
    Message =  "~p ~p przyszedł z wnioskiem o urop dziekański do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n",
    io:format(Message, [Name, Surname, AssistantsName ++ "a", Processing_time]),
    timer:sleep(Processing_time * multiplier()).

multiplier() -> 
    10.
