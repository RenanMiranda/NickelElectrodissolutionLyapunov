module DataIO

export export_data, import_data

function export_data(filename, data)
    open(filename, "w") do io
        writedlm(io, data, ',')
    end
end

function import_data(filename)
    return readdlm(filename, ',', Float64)
end

end