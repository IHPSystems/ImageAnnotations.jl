struct PolygonAnnotation{C, T} <: AbstractObjectAnnotation{C, T}
    vertices::Vector{Point2{T}}
    classification_annotation::ClassificationImageAnnotation{C}

    function PolygonAnnotation(vertices::Vector{Point2{T}}, class::C; kwargs...) where {C, T}
        if length(vertices) < 3
            throw(ArgumentError("Cannot create a polygon with less than 3 vertices."))
        end
        core = ClassificationImageAnnotation(class; kwargs...)
        return new{C, T}(vertices, core)
    end
end

function Base.:(==)(a::PolygonAnnotation, b::PolygonAnnotation)
    return a.vertices == b.vertices && a.classification_annotation == b.classification_annotation
end

vertices(annotation::PolygonAnnotation)::Vector{Point2} = annotation.vertices

function centroid(annotation::PolygonAnnotation{C, T})::Point2{T} where {C, T <: Real}
    return reduce((+), annotation.vertices) / length(annotation.vertices)
end

function bounding_box_annotation(annotation::PolygonAnnotation{C, T})::BoundingBoxAnnotation{C, T} where {C, T}
    return BoundingBoxAnnotation(annotation.vertices, annotation.classification_annotation)
end
