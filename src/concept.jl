abstract type AbstractConcept end

abstract type AbstractConceptAttribute end

struct Concept{T} <: AbstractConcept
    value::T
    attributes::Dict{String, AbstractConceptAttribute}
    description::String
    examples::Vector{Dict{String, Any}}
end

function Concept(
    value::T;
    attributes::Vector{<:AbstractConceptAttribute} = Vector{AbstractConceptAttribute}(),
    description::String = "",
    examples::Vector{Dict{String, Any}} = Dict{String, Any}[],
) where {T}
    attributes_dict = Dict{String, AbstractConceptAttribute}([a.name => a for a in attributes])
    return Concept(value, attributes_dict, description, examples)
end

struct CategoricalConceptAttribute{T} <: AbstractConceptAttribute
    name::String
    values::Vector{T}
    default_value::T

    function CategoricalConceptAttribute(name::String, values::Vector{T}, default_value::T) where {T}
        if length(values) < 1
            throw(ArgumentError("CategoricalConceptAttribute must have at least one value"))
        end
        if default_value ∉ values
            throw(ArgumentError("Default value must be one of the values"))
        end
        return new{T}(name, values, default_value)
    end
end

function CategoricalConceptAttribute(name::String, values::Vector{T}) where {T}
    if length(values) < 1
        throw(ArgumentError("CategoricalConceptAttribute must have at least one value"))
    end
    return CategoricalConceptAttribute(name, values, values[1])
end

function Base.in(label::Label{T}, concept::Concept{T}) where {T}
    if label.value != concept.value
        return false
    end
    for (attribute_name, attribute) in concept.attributes
        if !haskey(label.attributes, attribute_name)
            return false
        end
        if label.attributes[attribute_name] ∉ attribute.values
            return false
        end
    end
    return true
end

function Base.in(label::Label{T}, concepts::Vector{Concept{T}}) where {T}
    for concept in concepts
        if label ∈ concept
            return true
        end
    end
    return false
end
