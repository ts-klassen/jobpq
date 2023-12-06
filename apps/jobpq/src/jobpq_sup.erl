%%%-------------------------------------------------------------------
%% @doc jobpq top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(jobpq_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 2,
                 period => 1},
    ChildSpecs = [
        #{
            id => jobpq_notification_sup
          , start => {jobpq_notification, start_link, []}
          , restart => permanent
          , type => worker
        }
      , #{
            id => jobpq_priority_queue_sup
          , start => {jobpq_priority_queue, start_link, []}
          , restart => permanent
          , type => worker
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
