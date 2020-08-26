/*from proc sql directly*/
/*this is pretty convoluted*/
proc sql;
connect to odbc as conn
required="Driver=;Address=;Database=;UID=;PWD=";

create table event as
select * from connection to conn
(select * from events) ;

disconnect from conn;
quit;

/*by using a libname*/
libname conn2 odbc
required ="Driver=;Address=;Database=;UID=;PWD=C";
proc sql;
create table event as
select * from conn2.events ;
quit;
