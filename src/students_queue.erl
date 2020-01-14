-module(students_queue).

-export([init_queue/1]).

init_queue(How_Many) -> 
    io:format("Poczatek kolejki do dziekanatu!~n"),
    BufferArray = fifo:new(),
    listen(BufferArray, false, How_Many).

listen(BufferArray, IsClosed, How_Many) ->
    receive
        {add_student, {student, Name, Surname, Case}, ProducerPid} ->
            if IsClosed -> 
                ProducerPid ! deans_office_is_closed;
            true ->
                io:format("Przyszedł ~p ~p ze sprawą ~p~n", [Name, Surname, Case]), 
                BA = fifo:push(BufferArray, 
                    {student,
                    Name,
                    Surname,
                    Case}
                    ), 
                ProducerPid ! student_added,
                listen(BA, false, How_Many)
            end;

        {take_student, DeansAssistantPid} ->
            NotEmpty = fifo:not_empty(BufferArray),
            if NotEmpty ->
                {Student, BA} = fifo:pop(BufferArray),
                {student,
                    Name,
                    Surname,
                    Case} = Student,
                io:format("Student ~p ~p wszedł do dziekanatu.~n", [Name, Surname]), 
                DeansAssistantPid ! {Case, Student}, 
                listen(BA, false, How_Many);

            true -> 
                DeansAssistantPid ! queue_is_empty,
                listen(BufferArray, false, How_Many)
            end;

        work_finished ->
            if How_Many - 1 == 0 ->
                self() ! deans_office_is_closed;
            true -> 
                listen(BufferArray, true, How_Many -1)
            end;
            
        deans_office_is_closed -> 
            EmptyBA = clear_queue(BufferArray),
            listen(EmptyBA, true, 0)
    end.

clear_queue(BufferArray) -> 
    NotEmpty = fifo:not_empty(BufferArray),
    if NotEmpty -> 
        {{student, Name, Surname, _Case}, Q} = fifo:pop(BufferArray),
        io:format("Student ~p ~p nie doczekał się .~n", [Name, Surname]),
        clear_queue(Q);
    true ->
        io:format("Kolejka do dziekanatu jest pusta, a dziekanat zamknięty.~n Zapraszamy jutro.~n"),
        BufferArray
end.
        