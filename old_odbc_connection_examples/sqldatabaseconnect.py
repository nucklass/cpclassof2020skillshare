import pyodbc
conn = pyodbc.connect("Driver=[Insert Driver here] ;Address=;Database=;UID=;PWD=;")
cursor = conn.cursor()
cursor.execute("select * from [insert table here]" )
dat =cursor.fetchall()
conn.close()
