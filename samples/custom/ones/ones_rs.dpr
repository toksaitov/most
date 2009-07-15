{$r+,q+,o-}
{$apptype console}
const
  problem_name = 'ones';

type
  int = longint;

var
  n, ans: int;

begin
  reset(input, problem_name + '.in');
  rewrite(output, problem_name + '.out');

  read(n);
  ans:=0;
  while (n > 0) do
  begin
    inc(ans);
    n:=n and (n - 1);
  end;

  writeln(ans);
end.
