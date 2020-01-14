-module(deans_office).

-export([init_worker/4]).

init_worker(QueuePid, Start, End, AssistantsName) -> 
    How_many_minutes = (End - Start),
    loop(QueuePid, How_many_minutes, AssistantsName).


loop(QueuePid, How_many_minutes, AssistantsName) when How_many_minutes =< 0 -> 
    io:format("Pracownik ~p skonczyl prace na dzisiaj. ~n", [AssistantsName]),
    QueuePid ! work_finished;


loop(QueuePid, How_many_minutes, AssistantsName) when How_many_minutes > 0 -> 
    QueuePid ! {take_student, self()},
    receive      
        {Request, Student} ->
            Processing_time = rand:uniform(10) + 5,
            processing:process_student_request(Request, Student, Processing_time, AssistantsName),
            loop(QueuePid, How_many_minutes - Processing_time, AssistantsName);

        queue_is_empty -> 
            Break = rand:uniform(10),
            io:format("Nie ma nikogo w kolejce, ~p idzie na kawę przez ~p minut.~n", [AssistantsName, Break]),
            timer:sleep(Break * multiplier()),
            loop(QueuePid, How_many_minutes - Break, AssistantsName)
    end.

multiplier() -> 10.
