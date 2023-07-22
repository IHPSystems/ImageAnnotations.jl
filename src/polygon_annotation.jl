struct PolygonAnnotation{L, T} <: AbstractObjectAnnotation{L, T}
    vertices::Vector{Point2{T}}
    annotation::ImageAnnotation{L}

    function PolygonAnnotation(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
        if length(vertices) < 3
            throw(ArgumentError("Cannot create a polygon with less than 3 vertices."))
        end
        core = ImageAnnotation(label; kwargs...)
        return new{L, T}(vertices, core)
    end
end

function Base.:(==)(a::PolygonAnnotation, b::PolygonAnnotation)
    return a.vertices == b.vertices && a.annotation == b.annotation
end

get_vertices(annotation::PolygonAnnotation)::Vector{Point2} = annotation.vertices

get_image_annotation(annotation::PolygonAnnotation) = annotation.annotation

function get_centroid(annotation::PolygonAnnotation{L, T})::Point2{T} where {L, T <: Real}
    return reduce((+), annotation.vertices) / length(annotation.vertices)
end

function get_bounding_box(annotation::PolygonAnnotation{L, T})::Rect2{T} where {L, T}
    return get_bounding_box(annotation.vertices)
end
