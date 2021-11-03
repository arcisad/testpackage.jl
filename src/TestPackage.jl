module TestPackage

using LinearAlgebra
using Statistics
using Random

export generate_output

function generate_output(a::Float64)::Float64
    @info "generating results...!"
    return norm([mean(rand(10)), a])
end

end # module
