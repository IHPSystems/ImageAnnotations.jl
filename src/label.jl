abstract type AbstractLabel end

mutable struct Label{T} <: AbstractLabel
    value::T
    attributes::Dict{String, Any}
end

function Label(value::T) where {T}
    return Label{T}(value, Dict{String, Any}())
end

Base.:(==)(a::Label, b::Label) = a.value == b.value && a.attributes == b.attributes
