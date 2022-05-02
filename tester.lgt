:- initialization((
    logtalk_load(lgtunit(loader)),
    logtalk_load(tests,  [hook(lgtunit)]),
    tests::run
)).