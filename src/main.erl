-module(main).

-export([main/0]).

main() -> 
    {ok, [Start]} = io:fread("Od której jest dzisiaj czynne? : ", "~d"),
    {ok, [End]} = io:fread("Do której jest dzisiaj czynne? : ", "~d"),
    {ok, [How_Many_Assistants]} = io:fread("Ile jest dzisiaj pań w dziekanacie? : ", "~d"),

    QueuePid = spawn(students_queue, init_queue, []),
    spawn_students(QueuePid),
    timer:sleep(100),
    spawn_deans_office(QueuePid, Start, End, How_Many_Assistants),
    ok.

spawn_deans_office(QueuePid, Start, End, 1) -> 
    spawn(deans_office, init_assistant, [QueuePid, Start, End]);

spawn_deans_office(QueuePid, Start, End, How_Many_Assistants) when How_Many_Assistants > 1 ->
    spawn(deans_office, init_assistant, [QueuePid, Start, End]), 
    spawn_deans_office(QueuePid, Start, End, How_Many_Assistants - 1).

spawn_students(QueuePid) -> 
    spawn(student_producer, init, [QueuePid]).