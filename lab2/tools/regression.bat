::========================================================================================
call clean.bat
::========================================================================================
call build.bat
::========================================================================================
cd ../sim

call run_test.bat 77711
call run_test.bat 12344
call run_test.bat 12345
call run_test.bat 12346
call run_test.bat 88888
call run_test.bat 77888
call run_test.bat 805288
call run_test.bat 121688
call run_test.bat 565888
call run_test.bat 8557488