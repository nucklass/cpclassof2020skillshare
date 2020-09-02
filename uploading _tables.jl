using MySQL, TypedTables,CSV


#adding a singletable

#connect/login to the database
conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz"; db="youtube")

#read the CSV file into Julia, store as a Typed Table
ca = CSV.File("youtubedata/USvideos.csv") |> Table 

#load typed table into database
MySQL.load(ca,conn ,"US")

#logout of database
DBInterface.close!(conn)


## add all the tables in the youtubedata folder 
conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz"; db="youtube")
for file in filter(λ ->contains(λ, "csv"),readdir("youtubedata"))
    current_file = CSV.File("youtubedata/$file") |> Table
    MySQL.load(current_file,conn, file[1:2])
    println("table $(file[1:2]) uploaded")
end 

DBInterface.close(conn)

#all the tables in the solar folder
conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz"; db="testing")
for file in filter(λ ->contains(λ, "csv"),readdir("solar"))
    current_file = CSV.File("solar/$file") |> TypedTables.Table
    MySQL.load(current_file,conn, file)
    println("table $(file) uploaded")
end 

DBInterface.close(conn)