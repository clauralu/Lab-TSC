::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

call run_test.bat 77711   10
call run_test.bat 12344   15
call run_test.bat 12345   15
call run_test.bat 12346   5
call run_test.bat 88888   5
call run_test.bat 77888   5
call run_test.bat 805288  15
call run_test.bat 121688  5
call run_test.bat 565888  15
call run_test.bat 8557488 5