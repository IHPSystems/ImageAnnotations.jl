struct BoundingBoxAnnotation{C, T} <: AbstractObjectAnnotation{C, T}
    rect::Rect2{T}
    classification_annotation::ClassificationImageAnnotation{C}
end

function BoundingBoxAnnotation(top_left::Point2{T}, width::T, height::T, class::C; kwargs...) where {C, T}
    classification_annotation = ClassificationImageAnnotation(class; kwargs...)
    return BoundingBoxAnnotation{C, T}(Rect2{T}(top_left.data[1], top_left.data[2], width, height), classification_annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, bottom_right::Point2{T}, class::C; kwargs...) where {C, T}
    width = bottom_right.data[1] - top_left.data[1]
    height = bottom_right.data[2] - top_left.data[2]
    return BoundingBoxAnnotation(top_left, width, height, class; kwargs...)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, classification_annotation::ClassificationImageAnnotation{C}) where {C, T}
    min_x = minimum([x for (x, _) in vertices])
    max_x = maximum([x for (x, _) in vertices])
    min_y = minimum([y for (_, y) in vertices])
    max_y = maximum([y for (_, y) in vertices])

    width = max_x - min_x
    height = max_y - min_y

    return BoundingBoxAnnotation{C, T}(Rect2{T}(min_x, min_y, width, height), classification_annotation)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, class::C; kwargs...) where {C, T}
    classification_annotation = ClassificationImageAnnotation(class; kwargs...)
    return BoundingBoxAnnotation(vertices, classification_annotation)
end

function BoundingBoxAnnotation(box::Rect2{T}, class::C; kwargs...) where {C, T}
    classification_annotation = ClassificationImageAnnotation(class; kwargs...)
    return BoundingBoxAnnotation{C, T}(box, classification_annotation)
end

function Base.:(==)(a::BoundingBoxAnnotation, b::BoundingBoxAnnotation)
    return a.rect == b.rect && a.classification_annotation == b.classification_annotation
end

function bounding_box_annotation_with_center(center::Point2{T}, width::T, height::T, class::C; kwargs...) where {C, T}
    top_left = center - Point2{T}(width, height) / 2
    return BoundingBoxAnnotation(top_left, width, height, class; kwargs...)
end

function centroid(annotation::BoundingBoxAnnotation{C, T})::Point2{Float64} where {C, T}
    return bounding_box(annotation).origin + bounding_box(annotation).widths / 2
end

function bounding_box_annotation(annotation::BoundingBoxAnnotation{C, T})::BoundingBoxAnnotation{C, T} where {C, T}
    return annotation
end
