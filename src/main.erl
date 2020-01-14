-module(main).

-export([dziekanat/0]).

dziekanat() -> 
    try 
        {ok, [Start]} = io:fread("Od której jest dzisiaj czynne? : ", "~d"),
        checkers:check_start(Start),

        {ok, [End]} = io:fread("Do której jest dzisiaj czynne? : ", "~d"),
        checkers:check_end(End),
        checkers:check_time_difference(Start, End),
        
        {ok, [How_Many_Assistants]} = io:fread("Ile jest dzisiaj pracowników dziekanatu? : ", "~d"),
        checkers:check_number_of_workers(How_Many_Assistants),

        QueuePid = spawn(students_queue, init_queue, [How_Many_Assistants]),
        spawn_students(QueuePid),
        timer:sleep(100),
        spawn_deans_office(QueuePid, Start, End, How_Many_Assistants),
        ok
    catch 
        exit:{_, Message} -> Message ++ " Koniec pracy symulacji."
    end.

spawn_deans_office(QueuePid, Start, End, 1) -> 
    spawn(deans_office, init_worker, [QueuePid, Start, End, name(1)]);

spawn_deans_office(QueuePid, Start, End, How_Many_Assistants) when How_Many_Assistants > 1 ->
    spawn(deans_office, init_worker, [QueuePid, Start, End, name(How_Many_Assistants)]), 
    spawn_deans_office(QueuePid, Start, End, How_Many_Assistants - 1).

name(N) -> 
    lists:nth(N, ["Adrian", "Stefan", "Jan", "Piotr", "Marian", "Wojciech", "Zbigniew", "Karol", "Igor", "Euzebiusz"]).

spawn_students(QueuePid) -> 
    spawn(student_producer, init, [QueuePid]).
