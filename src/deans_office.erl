-module(deans_office).

-export([init_assistant/3]).

init_assistant(QueuePid, Start, End) -> 
    How_many_minutes = End - Start,
    loop(QueuePid, How_many_minutes*10).


loop(QueuePid, How_many_minutes) when How_many_minutes =< 0 -> 
    io:format("Już za późno. Zamykamy dziekanat. ~n"),
    QueuePid ! deans_office_is_closed;


loop(QueuePid, How_many_minutes) when How_many_minutes > 0 -> 
    QueuePid ! {take_student, self()},
    receive      
        {zaswiadczenie, Student} ->
            Processing_time = rand:uniform(10),
            process_student_request(Student, Processing_time, "~p ~p przyszedł z zaświadczeniem. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        {pieczatka, Student} ->
            Processing_time = rand:uniform(10),
            process_student_request(Student, Processing_time, "~p ~p przyszedł po pieczątkę. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        {warunek, Student} ->
            Processing_time = rand:uniform(4),
            process_student_request(Student, Processing_time, "~p ~p przyszedł z prośbą o wpis z warunkiem. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        {stypendium, Student} ->
            Processing_time = rand:uniform(3),
            process_student_request(Student, Processing_time, "~p ~p przyszedł z wnioskiem o stypendium. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        {skarga, Student} ->
            Processing_time = rand:uniform(20),
            process_student_request(Student, Processing_time, "~p ~p przyszedł ze skargą. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        {dziekanaka, Student} ->
            Processing_time = rand:uniform(5),
            process_student_request(Student, Processing_time, "~p ~p przyszedł z prośbą o urlop dziekański. Sprawa zajmie mu ~p minut w dziekanacie.~n"),
            loop(QueuePid, How_many_minutes - Processing_time);

        queue_is_empty -> 
            Break = rand:uniform(10)+5,
            io:format("Nie ma nikogo, pora na kawę przez ~p minut ~n", [Break]),
            timer:sleep(Break),
            loop(QueuePid, How_many_minutes - Break)
    end.


process_student_request({student, Name, Surname, _Case}, Processing_time, Message) ->
    io:format(Message, [Name, Surname, Processing_time]),
    timer:sleep(Processing_time*10).