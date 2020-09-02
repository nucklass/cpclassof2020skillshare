module Dash1

using Matte

const title = "Dashboard Test :: Database Connection & Numeric Graphing"

function ui()
    sidebar_layout(
        side_panel(
            h2("Select a Table"),
            br(),
            selector("table_selection_input", "Possible Database Tables", "table_list"),
            br(), 
            selector("xvar", "X variable", "var_list"),
            br(),
            selector("yvar", "Y variable", "var_list")
        ),
        main_panel(
            h1("Scatter Plot"),
            br(),
            plots_output("output_plot")
        )
    )
end


module Server
using MySQL, DataFrames, Plots, Transducers

function table_list()
    conn = DBInterface.connect(MySQL.Connection, "", "nick", "hunterglanz";db = "testing")
    tables = DBInterface.execute(conn,"show tables") |> DataFrame!
    DBInterface.close!(conn)
    return tables.Tables_in_testing
    end 

function var_list(table_selection_input)
    if typeof(table_selection_input) <: AbstractString
        conn = DBInterface.connect(MySQL.Connection, "", "nick", "hunterglanz";db ="testing")
        
        #using Tranducers.jl for parallel (multithreaded) DataFrame manipulation
        variables = DBInterface.execute(conn,"show columns from $table_selection_input") |> 
        DataFrame!|> 
        eachrow |>
        Filter(o -> !contains(o.Type, "char")) |>
        Map(o->(Field=o.Field)) |> #this is the Transducers equivalent of "Select" 
        tcollect

        DBInterface.close!(conn)
    
    end 
    return variables
    end 

function output_plot(xvar, yvar, table_selection_input)
    if typeof(xvar) <: AbstractString && typeof(yvar) <: AbstractString
        conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz";db ="testing")
        tbl = DBInterface.execute(conn, "select $xvar , $yvar from $table_selection_input") |> DataFrame!
        tbl |> λ -> plot(λ[Symbol(xvar)], λ[Symbol(yvar)],seriestype = :scatter)    
    end
    end

end

end 


using Matte
run_app(Dash1)