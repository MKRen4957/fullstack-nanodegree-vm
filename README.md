Project codes are in tournament file inside vagrant file, vagrant/tournament
tournament.sql contains all the SQL statements needed to run the program. To start, follow the steps in terminal below:
1. change directory to tournament
2. type vagrant up
3. type vagrant ssh
4. change directory to vagrant
5. change directory to tournament
6. type psql, enter into Postgresql
7. type 'CREATE DATABASE tournament;', create a database named tournament
8. type \c tournmanet, to connect to the database just created
9. type \i tournament.sql, to create the tables and views needed for the program to run
10. type \q or control+d on the keyboard to exit Postgresql
The database is set up properly, tournament.py file contains functions to modify the database. However, to test if the program can function properly, type 'python tournament_text.py'. You should see all test cases passed. The tournament_test.py file contains multiple test functions.
