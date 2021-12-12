%%%-------------------------------------------------------------------
%% @doc gentoo_dependency_sizes public API
%% @end
%%%-------------------------------------------------------------------

-module(gentoo_dependency_sizes_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    gentoo_dependency_sizes_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
