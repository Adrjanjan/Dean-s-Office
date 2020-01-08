-module(deans_office).

-export([init_assistant/4]).

init_assistant(QueuePid, Start, End, AssistantsName) -> 
    How_many_minutes = End - Start,
    loop(QueuePid, How_many_minutes, AssistantsName).


loop(QueuePid, How_many_minutes, _AssistantsName) when How_many_minutes =< 0 -> 
    io:format("Już za późno. Zamykamy dziekanat. ~n"),
    QueuePid ! deans_office_is_closed;


loop(QueuePid, How_many_minutes, AssistantsName) when How_many_minutes > 0 -> 
    QueuePid ! {take_student, self()},
    receive      
        {zaswiadczenie, Student} ->
            Processing_time = rand:uniform(10) + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł z zaświadczeniem do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        {pieczatka, Student} ->
            Processing_time = rand:uniform(10) + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł po podbicie pieczątką dokumentu do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        {warunek, Student} ->
            Processing_time = rand:uniform(10) + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł z prośbą o wpis z warunkiem do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        {stypendium, Student} ->
            Processing_time = rand:uniform(10) + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł z wnioskiem o stypendium do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        {skarga, Student} ->
            Processing_time = rand:uniform(10)  + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł ze skargą do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        {dziekanaka, Student} ->
            Processing_time = rand:uniform(10) + 5,
            process_student_request(Student, Processing_time, AssistantsName, "~p ~p przyszedł z prośbą o urlop dziekański do ~p. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        queue_is_empty -> 
            Break = rand:uniform(10),
            io:format("Nie ma nikogo w kolejce pani ~p, idzie na kawę przez ~p minut.~n", [AssistantsName, Break]),
            timer:sleep(Break*10),
            loop(QueuePid, How_many_minutes - Break, AssistantsName)
    end.


process_student_request({student, Name, Surname, _Case}, Processing_time, AssistantsName, Message) ->
    io:format(Message, [Name, Surname, AssistantsName, Processing_time]),
    timer:sleep(Processing_time*10).
