module Dummies

using ..ImageAnnotations

create_label(::Type{Int}) = 2
create_label(::Type{Float64}) = 0.5
create_label(::Type{String}) = "aeroplane"

end
