-module(student_producer).

-export([init/1]).

init(StudentsQueue) ->
  listen(StudentsQueue).

listen(StudentsQueue) ->
  timer:sleep(rand:uniform(7)*10),
  Student = random_student:random_student(),
  StudentsQueue ! {add_student, Student, self()},
  receive
    student_added ->
      listen(StudentsQueue);
    deans_office_is_closed ->
      ok
  end.
  