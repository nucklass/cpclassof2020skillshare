using Genie.Router, Genie.Renderer.Html
using Stipple

using StippleUI, StippleUI.Table, StippleUI.Range, StippleUI.BigNumber, StippleUI.Heading, StippleUI.Dashboard
using StippleCharts, StippleCharts.Charts

using MySQL, DataFrames

conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz";db ="testing")

tables = DBInterface.execute(conn,"show tables") |> DataFrame

initable= DBInterface.execute(conn,"select * from hflights") |> DataFrame

DBInterface.close!(conn)

Base.@kwdef mutable struct Dsh <: ReactiveModel
    selected_table::R{String} = "hflights"
    data::R{DataTable} = DataTable(initable)
    tables::R{Vector{String}} = tables.Tables_in_testing
end

Stipple.register_components(Dsh, StippleCharts.COMPONENTS)

model = Stipple.init(Dsh)

function query_table(table)
    conn = DBInterface.connect(MySQL.Connection, "192.168.86.38", "nick", "hunterglanz";db ="testing")

    t = DBInterface.execute(conn,"select * from $table") |> DataFrame

    DBInterface.close!(conn)
    
    return(t)

end

onany(model.selected_table) do (_...)
    model.data[] = query_table(model.selected_table[]) |> DataTable
end

function ui(model)
    dashboard(root(model),[
    heading("Stipple Practice")
    
    row([
        cell(class="st-module",
        [Html.select(:selected_table;options=:tables)])
    ])

    row([
    cell(class="st-module",
        [table(:data)])
    ])
])
end

route("/") do 
    ui(model) |> html
end 
Genie.up()
