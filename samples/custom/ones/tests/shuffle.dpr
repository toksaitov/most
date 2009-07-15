{$r+,q+,o-}
{$apptype console}
type
  int = longint;

var
  test_num: int;

procedure write_test(n: int);
begin
  inc(test_num);
  rewrite(output, chr((test_num div 10) + ord('0')) + chr((test_num mod 10) + ord('0')));

  writeln(n);

  close(output);
end;

var
  n: int;

begin
  reset(input, 'tests.lst');
  test_num:=0;
  while not seekeof do
  begin
    read(n);
    readln;
    write_test(n);
  end;
end.
