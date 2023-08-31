abstract type AbstractPolygonAnnotation{L, T} <: AbstractObjectAnnotation{L, T} end

struct PolygonAnnotation{L, T} <: AbstractPolygonAnnotation{L, T}
    vertices::Vector{Point2{T}}
    annotation::ImageAnnotation{L}

    function PolygonAnnotation{L, T}(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
        if length(vertices) < 3
            throw(ArgumentError("Cannot create a polygon with less than 3 vertices."))
        end
        return new{L, T}(vertices, annotation)
    end
end

# Construction

function PolygonAnnotation(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
    return PolygonAnnotation{L, T}(vertices, annotation)
end

# Construction with label, and kwargs...

function PolygonAnnotation{L, T}(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return PolygonAnnotation{L, T}(vertices, annotation)
end

function PolygonAnnotation(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    return PolygonAnnotation{L, T}(vertices, label; kwargs...)
end

# Equality

function Base.:(==)(a::PolygonAnnotation, b::PolygonAnnotation)
    return a.vertices == b.vertices && a.annotation == b.annotation
end

# Accessors

get_vertices(annotation::PolygonAnnotation)::Vector{Point2} = annotation.vertices

get_image_annotation(annotation::PolygonAnnotation) = annotation.annotation

# Methods

function get_bounding_box(annotation::PolygonAnnotation{L, T})::Rect2{T} where {L, T}
    return get_bounding_box(annotation.vertices)
end

function get_centroid(annotation::PolygonAnnotation{L, T})::Point2{T} where {L, T <: Real}
    return reduce((+), annotation.vertices) / length(annotation.vertices)
end
