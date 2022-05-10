:- module(save_user, [save_user/0]).

:- use_module(valveni).

save_user :-
    v_open("c", [people/3], VS),
    v_assert(VS, people("Adrián", 23, "Valladolid")),
    user:people(X,Y,Z).
