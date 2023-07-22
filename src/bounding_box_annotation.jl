struct BoundingBoxAnnotation{L, T} <: AbstractObjectAnnotation{L, T}
    rect::Rect2{T}
    annotation::ImageAnnotation{L}
end

function BoundingBoxAnnotation(top_left::Point2{T}, width::T, height::T, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation(Rect2{T}(top_left.data[1], top_left.data[2], width, height), annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, bottom_right::Point2{T}, label::L; kwargs...) where {L, T}
    width = bottom_right.data[1] - top_left.data[1]
    height = bottom_right.data[2] - top_left.data[2]
    return BoundingBoxAnnotation(top_left, width, height, label; kwargs...)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
    bounding_box = get_bounding_box(vertices)
    return BoundingBoxAnnotation(bounding_box, annotation)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation(vertices, annotation)
end

function BoundingBoxAnnotation(box::Rect2{T}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation(box, annotation)
end

function BoundingBoxAnnotation(object_annotation::AbstractObjectAnnotation{L, T}) where {L, T}
    return BoundingBoxAnnotation(get_bounding_box(object_annotation), object_annotation.annotation)
end

function Base.:(==)(a::BoundingBoxAnnotation, b::BoundingBoxAnnotation)
    return a.rect == b.rect && a.annotation == b.annotation
end

function create_bounding_box_annotation_with_center(center::Point2{T}, width::T, height::T, label::L; kwargs...) where {L, T}
    top_left = center - Point2{T}(width, height) / 2
    return BoundingBoxAnnotation(top_left, width, height, label; kwargs...)
end

function get_centroid(annotation::BoundingBoxAnnotation{L, T})::Point2{Float64} where {L, T}
    return get_bounding_box(annotation).origin + get_bounding_box(annotation).widths / 2
end

function get_bounding_box(annotation::BoundingBoxAnnotation{L, T})::Rect2{T} where {L, T}
    return annotation.rect
end

function get_bounding_box(vertices::Vector{Point2{T}})::Rect2{T} where {T}
    min_x = minimum([x for (x, _) in vertices])
    max_x = maximum([x for (x, _) in vertices])
    min_y = minimum([y for (_, y) in vertices])
    max_y = maximum([y for (_, y) in vertices])

    width = max_x - min_x
    height = max_y - min_y

    return Rect2{T}(min_x, min_y, width, height)
end
