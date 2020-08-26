library(RODBC)
# tried the tidyverse ODBC package, but it kept giving me errors
library(tidyverse)
conn=odbcDriverConnect(connection="Driver=[insert driver here];Address=;Database=;UID=;PWD=C;")
dat =conn%>% sqlQuery("select * from [insert table here]")
close(conn)
