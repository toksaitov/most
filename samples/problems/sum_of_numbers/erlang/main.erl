-module(main). -export([start/0]).
start() -> io:write(lists:sum(element(2, io:fread("", "~d ~d")))).