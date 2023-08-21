abstract type AbstractLabel end

struct Label{T} <: AbstractLabel
    value::T
    attributes::Dict{String, Any}
end

function Label{T}(value::T) where {T}
    return Label{T}(value, Dict{String, Any}())
end

Label(value::T) where {T} = Label{T}(value)

Base.:(==)(a::Label, b::Label) = a.value == b.value && a.attributes == b.attributes
