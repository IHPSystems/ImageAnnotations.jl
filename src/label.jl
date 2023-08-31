abstract type AbstractLabel{T} end

function Base.isless(a::AbstractLabel{T}, b::AbstractLabel{T}) where {T}
    if a.value != b.value
        return a.value < b.value
    else
        return length(a.attributes) < length(b.attributes)
    end
end

struct Label{T} <: AbstractLabel{T}
    value::T
    attributes::Dict{String, Any}
end

function Label{T}(value::T) where {T}
    return Label{T}(value, Dict{String, Any}())
end

Label(value::T) where {T} = Label{T}(value)

Base.:(==)(a::Label, b::Label) = a.value == b.value && a.attributes == b.attributes
