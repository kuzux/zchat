-module(msg).
-export([start/0, server/1, logon/1, logoff/0, message/2, client/2]).

% mostly adapted from http://erlang.org/download/getting_started-5.4.pdf

% client to server messages
% logon Name
% logoff
% send To Msg

% server to client msgs
% { fail, user_already_exists }
% { success, logged_on }
% { fail, you_arent_logged_in }
% { fail, receiver_not_logged_in }
% { message, From, Msg }
%
% Users is the current list of logged on users
% has the format [{addr, name}]
server(Users) -> 
    receive
        { From, logon, Name } ->
            % we recurse back after receiving each message
            server(do_logon(From, Name, Users));
        { From, logoff } ->
            % tuples are 1 indexed
            server(lists:keydelete(From, 1, Users));
        { From, send, To, Msg } ->
            case lists:keysearch(From, 1, Users) of
                false ->
                    From ! {fail, you_arent_logged_in};
                {value, {From, Name}} ->
                    do_send(From, Name, To, Msg, Users)
            end,
            server(Users)
    end.


do_logon(From, Name, Users) ->
    case lists:keymember(Name, 2, Users) of
        true ->
            From ! {fail, user_already_exists},
            Users;
        false ->
            From ! {success, logged_on},
            % cons the new user in
            [ {From, Name} | Users ]
    end.


do_send(From, Name, To, Msg, Users) ->
    case lists:keysearch(To, 2, Users) of
        false ->
            From ! {fail, receiver_not_logged_in};
        {value, {ToPid, To}} ->
            ToPid ! {message, Name, Msg}
    end.


start() -> 
    register(msg, spawn(msg, server, [[]])).


