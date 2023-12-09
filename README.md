jobpq
=====

An OTP application

Build
-----

    $ rebar3 compile

Example
-------
```
jobpq:queue_unassigned(namespace1, task1, -1).
jobpq:queue_unassigned(namespace1, task2, 1).
jobpq:queue_unassigned(namespace1, task3, 0).
jobpq:queue_unassigned(namespace1, task4, 0).
AssignedTask1 = jobpq:wait_for_assignment(namespace1).
{value, AssignedTask2} = jobpq:assign(namespace1).
AssignedTask3 = jobpq:wait_for_assignment(namespace1).
MaybeAssignedTask4 = jobpq:assign(namespace1).
MaybeAssignedTask5 = jobpq:assign(namespace1).
```

```
1> jobpq:queue_unassigned(namespace1, task1, -1).
ok
2> jobpq:queue_unassigned(namespace1, task2, 1).
ok
3> jobpq:queue_unassigned(namespace1, task3, 0).
ok
4> jobpq:queue_unassigned(namespace1, task4, 0).
ok
5> AssignedTask1 = jobpq:wait_for_assignment(namespace1).
task1
6> {value, AssignedTask2} = jobpq:assign(namespace1).
{value,task3}
7> AssignedTask3 = jobpq:wait_for_assignment(namespace1).
task4
8> MaybeAssignedTask4 = jobpq:assign(namespace1).
{value,task2}
9> MaybeAssignedTask5 = jobpq:assign(namespace1).
none
```

Type
----
```
-type scope() :: term().
-type task() :: term().
-type priority() :: integer().
```

Spec
----
```
-spec queue_unassigned(scope(), task(), priority()) -> ok.
-spec wait_for_assignment(scope()) -> task().
-spec assign(scope()) -> none | {value, task()}.
```
