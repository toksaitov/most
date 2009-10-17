@echo off

set problem_id=ones

set solution_name=%problem_id%_rs.exe
set input_file=%problem_id%.in
set output_file=%problem_id%.out

rem set run_string=run %solution_name% -t 2
set run_string=%solution_name%

for /L %%i in (1,1,9) do (
    if EXIST 0%%i (
        copy 0%%i %input_file% >nul 2>&1
        %run_string%
        copy %output_file% 0%%i.a >nul 2>&1
        del %input_file% >nul 2>&1
        del %output_file% >nul 2>&1
    )
)

for /L %%i in (10,1,99) do (
    if EXIST %%i (
        copy %%i %input_file% >nul 2>&1
        %run_string%
        copy %output_file% %%i.a >nul 2>&1
        del %input_file% >nul 2>&1
        del %output_file% >nul 2>&1
    )
)
