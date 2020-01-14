-module(student_producer).

-export([init/1]).

init(StudentsQueue) -> listen(StudentsQueue).

listen(StudentsQueue) ->
    Wait = rand:uniform(10) * multiplier() + 10,
    timer:sleep(Wait),
    Student = random_student:random_student(),
    StudentsQueue ! {add_student, Student, self()},
    receive
      student_added -> listen(StudentsQueue);
      deans_office_is_closed -> ok
    end.

multiplier() -> 10.
