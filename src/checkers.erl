-module(checkers).

-compile(export_all).

check_start(Start) when Start < 800 -> 
    exit({start, "Godzina nie moze byc ujemna."});
check_start(Start) when Start > 2000 -> 
    exit({time, "Nie ma godziny pozniejszej niz 24:00"});
check_start(_) -> 
    ok.

check_time_difference(Start, End) when Start > End -> 
    exit({time, "Dziekanat musi sie zamykac tego samego dnia po jego otwarciu."});
check_time_difference(_,_) -> 
    ok.

check_end(End) when End > 2000 -> 
    exit({'end', "Nie ma godziny pozniejszej niz 24:00"});
check_end(_) ->
     ok.

check_number_of_workers(How_Many) when How_Many =< 0 -> 
    exit({assistants, "Liczba pracownikow dziekanatu musi byc dodatnia."});
check_number_of_workers(How_Many) when How_Many >= 10 -> 
    exit({assistants, "Liczba pracownikow dziekanatu nie może być większa od 10 - nie ma więcej biurek."});
check_number_of_workers(_) -> 
    ok.
