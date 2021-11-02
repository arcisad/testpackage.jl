module TestPackage

using LinearAlgebra
using Statistics
using Random

function generate_output(a::Float64)::Float64
    return norm([mean(rand(10)), a])
end

end # module
