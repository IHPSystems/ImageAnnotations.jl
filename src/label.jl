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

function Base.isless(a::Label{T}, b::Label{T}) where {T}
    if a.value != b.value
        return a.value < b.value
    else
        return length(a.attributes) < length(b.attributes)
    end
end
