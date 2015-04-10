-module(iorio_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    lager:info("starting iorio single"),

    % TODO: see where to start it
    file_handle_cache:start_link(),

    % TODO
    BaseDir = "tmp",
    {ok, AccessLogic} = iorioc_setup:setup_access(application:get_all_env(iorio)),
    {ok, Shard} = iorioc:start_link([{shard_opts, [{base_dir, BaseDir}]}]),
    iorio_rest:setup(AccessLogic, iorioc, Shard),

    iorio_sup:start_link().

stop(_State) ->
    ok.
