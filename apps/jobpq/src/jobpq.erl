-module(jobpq).

-export([
        queue_unassigned/3
      , wait_for_assignment/1
      , assign/1
      , remaining/1
    ]).


-export_type([
        scope/0
      , task/0
      , priority/0
    ]).

-type scope() :: term().
-type task() :: term().
-type priority() :: integer().

-spec queue_unassigned(scope(), task(), priority()) -> ok.
queue_unassigned(Scope, Task, Priority) ->
    jobpq_priority_queue:in(Scope, Task, Priority),
    jobpq_notification:send(Scope, new).

-spec wait_for_assignment(scope()) -> task().
wait_for_assignment(Scope) ->
    jobpq_notification:subscribe(Scope),
    await_(Scope, assign(Scope)).
await_(Scope, {value, Value}) ->
    jobpq_notification:unsubscribe(Scope),
    Value;
await_(Scope, none) ->
    jobpq_notification:await(Scope),
    await_(Scope, assign(Scope)).

-spec assign(scope()) -> klsn:maybe(task()).
assign(Scope) ->
    jobpq_priority_queue:out(Scope).

-spec remaining(scope()) -> non_neg_integer().
remaining(Scope) ->
    jobpq_priority_queue:len(Scope).
