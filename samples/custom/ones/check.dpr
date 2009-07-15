uses
    testlib, sysutils;

var
    ja, pa: longint;

begin
    ja := ans.readlongint;
    pa := ouf.readlongint;

    if ja <> pa then
        quit(_wa, format('expected: %d, found: %d', [ja, pa]));

    quit(_ok, '');
end.
