-module(server).
-compile(export_all).
-include_lib("my_lib.hrl").

-define(SERVER, awt_server).

start(StartSet) -> gen_server:start_link({local, ?SERVER}, callback_awt, [StartSet], []).
withdraw(Banknotes, AMount) -> gen_server:call(?SERVER, {Banknotes, Amount}).
stop()  -> gen_server:stop(?SERVER).
