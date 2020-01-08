-module(main).

-export([dziekanat/0]).

dziekanat() -> 
    {ok, [Start]} = io:fread("Od której jest dzisiaj czynne? : ", "~d"),
    {ok, [End]} = io:fread("Do której jest dzisiaj czynne? : ", "~d"),
    {ok, [How_Many_Assistants]} = io:fread("Ile jest dzisiaj pracowników dziekanatu? : ", "~d"),

    try check_args(Start, End, How_Many_Assistants) of 
        ok -> QueuePid = spawn(students_queue, init_queue, []),
            spawn_students(QueuePid),
            timer:sleep(100),
            spawn_deans_office(QueuePid, Start, End, How_Many_Assistants)
    catch 
        exit:{_, Message} -> Message ++ " Koniec pracy symulacji."
    end.

check_args(Start, _, _) when Start < 0 -> exit({start, "Godzina nie moze byc ujemna."});
check_args(Start, _, _) when Start > 2400 -> exit({time, "Nie ma godziny pozniejszej niz 24:00"});
check_args(Start, End, _) when Start > End -> exit({time, "Dziekanat musi sie zamykac tego samego dnia po jego otwarciu."});
check_args(_, End, _) when End > 2400 -> exit({time, "Nie ma godziny pozniejszej niz 24:00"});
check_args(_, _, How_Many) when How_Many =< 0 -> exit({assistants, "Liczba pracownikow dziekanatu musi byc dodatnia."});
check_args(_, _, _) -> ok.

spawn_deans_office(QueuePid, Start, End, 1) -> 
    spawn(deans_office, init_assistant, [QueuePid, Start, End, "Pracownik nr: 1"]);

spawn_deans_office(QueuePid, Start, End, How_Many_Assistants) when How_Many_Assistants > 1 ->
    spawn(deans_office, init_assistant, [QueuePid, Start, End, "Pracownik nr: " ++ integer_to_list(How_Many_Assistants)]), 
    spawn_deans_office(QueuePid, Start, End, How_Many_Assistants - 1).

spawn_students(QueuePid) -> 
    spawn(student_producer, init, [QueuePid]).
    