{$o-,q+,r+}
{$MINSTACKSIZE $00400000}
{$APPTYPE console}
uses
    math, sysutils;
type
    int = longint;
const
    maxn = 2000000000;
var
    n, i, j: int;
begin
    reset(input, 'ones.in');
    rewrite(output, 'ones.out');

    read(n);
    assert((0 <= n) and (n <= maxn));
    i := 0;
    for j := 0 to 31 do
        if (n and (1 shl j)) > 0 then
            inc(i);
    write(i);
end.