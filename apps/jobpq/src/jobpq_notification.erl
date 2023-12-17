-module(jobpq_notification).

-export([
        start_link/0
      , unsubscribe/1
      , subscribe/1
      , send/2
      , await/1
      , await/2
      , flush/1
    ]).

start_link() ->
    pg:start_link(?MODULE).

send(Name, Data) ->
    Pids = pg:get_members(?MODULE, Name),
    lists:foreach(fun(Pid)->
        Pid ! {?MODULE, Name, Data}
    end, lists:reverse(Pids)).

await(Name) ->
    receive
        {?MODULE, Name, Data} ->
            Data
    end.

await(Name, Time) ->
    receive
        {?MODULE, Name, Data} ->
            {value, Data}
    after Time ->
        none
    end.

flush(Name) ->
    lists:reverse(flush(Name, [])).

flush(Name, Data) ->
    case await(Name, 0) of
        {value, Datam} ->
            flush(Name, [Datam|Data]);
        none ->
            Data
    end.

join(Name, Pids) ->
    pg:join(?MODULE, Name, Pids).
    
leave(Name, Pids) ->
    pg:leave(?MODULE, Name, Pids).

subscribe(Name) ->
    join(Name, self()),
    ok.

unsubscribe(Name) ->
    leave(Name, self()),
    flush(Name, []),
    ok.

