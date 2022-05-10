# Valveni DB

Valveni is a micro database useful to persist predicates in low requirements applications.

It works like the internal Prolog assert/retract predicates but a few differences:

* Predicates are stored in an outside Prolog file. It can be edited by hand!
* Last operations are saved in an oplog file. You just need to backup this two files to backup your data! You can even force to flush the oplog file to have just a single file.
* Predicates can't be duplicated. No-body predicates which are the same don't add any actual information to the world.
* To read the data you just use normal Prolog predicates

Valveni has been tested with:

* Scryer Prolog

## Usage

First, you need to open a database. You NEED to declare what predicates your database uses:

```
:- use_module(valveni).

v_open("db_name", [people/3, phone/2], VS).
```

This will open the DB file, if it exists, flush the oplog and load the predicates into your Prolog program.
You can open a database as many times as you want, but keep in mind that v_open rewrites the entire database to disk, so it may be a little bit slow.
It will also return a handler which you will need to pass to every assert/retract operation.

```
v_assert(VS, people("Adrián", 23, "Valladolid")).
```

This will add the predicate to the database (in reality, just to the oplog) and it will assert it in Prolog.

```
?- people(X, Y, Z).
   X = "Adrián", Y = 23, Z = "Valladolid".
```

To remove a predicate, use `v_retract/2`.

```
v_retract(VS, people("Adrián", 23, "Valladolid")).
```