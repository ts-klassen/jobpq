-module(jobpq_priority_queue).

-behaviour(gen_server).

-export([
        start_link/0
      , init/1
      , handle_call/3
      , handle_cast/2
      , in/3
      , out/1
    ]).

in(Name, Data, Priority) ->
    gen_server:call(?MODULE, {in, Name, Data, Priority}).

out(Name) ->
    gen_server:call(?MODULE, {out, Name}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_) ->
    {ok, #{}}.

handle_call({out, Name}, _from, State0) ->
    case State0 of
        #{Name:=PQueue0} ->
            {Res0, PQueue} = pqueue2:out(PQueue0),
            Res = case Res0 of
                empty -> none;
                MaybeValue -> MaybeValue
            end,
            State = case pqueue2:is_empty(PQueue) of
                true ->
                    maps:remove(Name, State0);
                false ->
                    State0#{Name:=PQueue}
            end,
            {reply, Res, State};
        _ ->
            {reply, none, State0}
    end;

handle_call({in, Name, Data, Priority}, _From, State0) ->
    case State0 of
        #{Name:=PQueue0} ->
            PQueue = pqueue2:in(Data, Priority, PQueue0),
            State = State0#{Name:=PQueue},
            {reply, ok, State};

        _ ->
            PQueue0 = pqueue2:new(),
            PQueue = pqueue2:in(Data, Priority, PQueue0),
            State = State0#{Name=>PQueue},
            {reply, ok, State}
    end;

handle_call(_, _, State) ->
    {reply, ok, State}.

handle_cast(_, State) ->
    {noreply, State}.

