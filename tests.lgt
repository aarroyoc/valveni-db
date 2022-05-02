:- use_module('valveni.pl').
:- use_module(library(charsio)).
:- use_module(library(files)).
:- use_module(library(lists)).

:- object(tests, extends(lgtunit)).

    test(trivial) :- true.

    test(assert_simple, true) :-
        reset_state,
	valveni:v_open("test", [people/3], VS),
        valveni:v_assert(VS, people("Adrián", 23, "Valladolid")),
	open("test.oplog.pl", read, Stream),
	charsio:get_n_chars(Stream, _, Text),
	Text = ":- dynamic(oplog/1).\n:- multifile(oplog/1).\noplog(assert(people(\"Adrián\",23,\"Valladolid\"))).\n",
	user:people("Adrián", 23, "Valladolid").

    test(assert_non_predicate, fail) :-
        reset_state,
	valveni:v_open("test", [people/3], VS),
        (valveni:v_assert(VS, peoplex("Adrián", 23, "Valladolid")) ->
	    true
	;   files:file_exists("test.db.pl"), files:file_exists("test.oplog.pl")).

    test(retract, true) :-
        reset_state,
	valveni:v_open("test", [people/3], VS),
	valveni:v_assert(VS, people("Adrián", 23, "Valladolid")),
	user:people("Adrián", 23, "Valladolid"),
	valveni:v_retract(VS, people("Adrián", 23, "Valladolid")),
	\+ user:people("Adrián", 23, "Valladolid").

    test(assert_reload, true) :-
        reset_state,
	valveni:v_open("test", [people/3], VS),
	valveni:v_assert(VS, people("Adrián", 23, "Valladolid")),
	findall(N, user:people(N, _, _), Ns),
	lists:length(Ns, 1).
	% valveni:v_open("test", [people/3], VS).
	%\+ files:file_exists("test.oplog.pl").
	/*findall(N, user:people(N, _, _), Ns),
	lists:length(Ns, 1),
        open("test.db.pl", read, Stream),
	charsio:get_n_chars(Stream, _, Text),
	Text = ":- dynamic(people/3).\n:- multifile(people3/1).\npeople(\"Adrián\",23,\"Valladolid\").\n".*/
	
    test(assert_and_retract_reload).
    test(assert_reload_duplicate).

    reset_state :-
        (files:file_exists("test.db.pl") -> files:delete_file("test.db.pl") ; true),
	(files:file_exists("test.oplog.pl") -> files:delete_file("test.oplog.pl") ; true).

:- end_object.