abstract type AbstractBoundingBoxAnnotation{L, T} <: AbstractObjectAnnotation{L, T} end

function get_bottom_right end

function get_top_left end

struct BoundingBoxAnnotation{L, T} <: AbstractBoundingBoxAnnotation{L, T}
    rect::Rect2{T}
    annotation::ImageAnnotation{L}
end

# Construction with label, and kwargs...

function BoundingBoxAnnotation{L, T}(rect::Rect2{T}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation{L, T}(rect, annotation)
end

function BoundingBoxAnnotation(rect::Rect2{T}, label::L; kwargs...) where {L, T}
    return BoundingBoxAnnotation{L, T}(rect, label; kwargs...)
end

# Construction with top_left, width, height

function BoundingBoxAnnotation{L, T}(top_left::Point2{T}, width::T, height::T, annotation::ImageAnnotation{L}) where {L, T}
    rect = Rect2{T}(top_left.data[1], top_left.data[2], width, height)
    return BoundingBoxAnnotation{L, T}(rect, annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, width::T, height::T, annotation::ImageAnnotation{L}) where {L, T}
    return BoundingBoxAnnotation{L, T}(top_left, width, height, annotation)
end

function BoundingBoxAnnotation{L, T}(top_left::Point2{T}, width::T, height::T, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation{L, T}(top_left, width, height, annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, width::T, height::T, label::L; kwargs...) where {L, T}
    return BoundingBoxAnnotation{L, T}(top_left, width, height, label; kwargs...)
end

# Construction with top_left, bottom_right

function BoundingBoxAnnotation{L, T}(top_left::Point2{T}, bottom_right::Point2{T}, annotation::ImageAnnotation{L}) where {L, T}
    width = bottom_right.data[1] - top_left.data[1]
    height = bottom_right.data[2] - top_left.data[2]
    return BoundingBoxAnnotation{L, T}(top_left, width, height, annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, bottom_right::Point2{T}, annotation::ImageAnnotation{L}) where {L, T}
    return BoundingBoxAnnotation{L, T}(top_left, bottom_right, annotation)
end

function BoundingBoxAnnotation{L, T}(top_left::Point2{T}, bottom_right::Point2{T}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation{L, T}(top_left, bottom_right, annotation)
end

function BoundingBoxAnnotation(top_left::Point2{T}, bottom_right::Point2{T}, label::L; kwargs...) where {L, T}
    return BoundingBoxAnnotation{L, T}(top_left, bottom_right, label; kwargs...)
end

# Construction with vertices

function BoundingBoxAnnotation{L, T}(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
    rect = get_bounding_box(vertices)
    return BoundingBoxAnnotation{L, T}(rect, annotation)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
    return BoundingBoxAnnotation{L, T}(vertices, annotation)
end

function BoundingBoxAnnotation{L, T}(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return BoundingBoxAnnotation{L, T}(vertices, annotation)
end

function BoundingBoxAnnotation(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    return BoundingBoxAnnotation{L, T}(vertices, label; kwargs...)
end

# Construction with AbstractObjectAnnotation

function BoundingBoxAnnotation{L, T}(object_annotation::AbstractObjectAnnotation{L, T}) where {L, T}
    rect = get_bounding_box(object_annotation)
    annotation = get_image_annotation(object_annotation)
    return BoundingBoxAnnotation{L, T}(rect, annotation)
end

function BoundingBoxAnnotation(object_annotation::AbstractObjectAnnotation{L, T}) where {L, T}
    return BoundingBoxAnnotation{L, T}(object_annotation)
end

# Construction with center

function create_bounding_box_annotation_with_center(center::Point2{T}, width::T, height::T, annotation::ImageAnnotation{L}) where {L, T}
    top_left = center - Point2{T}(width, height) / 2
    return BoundingBoxAnnotation{L, T}(top_left, width, height, annotation)
end

function create_bounding_box_annotation_with_center(center::Point2{T}, width::T, height::T, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return create_bounding_box_annotation_with_center(center, width, height, annotation)
end

# Equality

function Base.:(==)(a::BoundingBoxAnnotation, b::BoundingBoxAnnotation)
    return a.rect == b.rect && a.annotation == b.annotation
end

# Accessors

get_bottom_right(annotation::BoundingBoxAnnotation) = annotation.rect.origin + annotation.rect.widths

get_height(annotation::BoundingBoxAnnotation) = annotation.rect.widths[2]

get_top_left(annotation::BoundingBoxAnnotation) = annotation.rect.origin

get_width(annotation::BoundingBoxAnnotation) = annotation.rect.widths[1]

get_image_annotation(annotation::BoundingBoxAnnotation) = annotation.annotation

function get_bounding_box(annotation::BoundingBoxAnnotation{L, T})::Rect2{T} where {L, T}
    return annotation.rect
end

# Methods

function get_bounding_box(vertices::Vector{Point2{T}})::Rect2{T} where {T}
    min_x = minimum([x for (x, _) in vertices])
    max_x = maximum([x for (x, _) in vertices])
    min_y = minimum([y for (_, y) in vertices])
    max_y = maximum([y for (_, y) in vertices])

    width = max_x - min_x
    height = max_y - min_y

    return Rect2{T}(min_x, min_y, width, height)
end

function get_centroid(annotation::BoundingBoxAnnotation{L, T})::Point2{Float64} where {L, T}
    return get_bounding_box(annotation).origin + get_bounding_box(annotation).widths / 2
end
