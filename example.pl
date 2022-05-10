:- use_module(valveni).
:- use_module(save_user).

main :-
    save_user,
    people("Adrián", _, _).
