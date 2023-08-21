struct OrientedBoundingBoxAnnotation{L, T} <: AbstractObjectAnnotation{L, T}
    center::Point2{T}
    width::T
    height::T
    orientation::Float32
    annotation::ImageAnnotation{L}
end

function OrientedBoundingBoxAnnotation(center::Point2{T}, width::T, height::T, orientation::T, annotation::ImageAnnotation{L}) where {L, T}
    return OrientedBoundingBoxAnnotation{L, T}(center, width, height, orientation, annotation)
end

# Construction with label, and kwargs...

function OrientedBoundingBoxAnnotation{L, T}(center::Point2{T}, width::T, height::T, orientation::T, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return OrientedBoundingBoxAnnotation{L, T}(center, width, height, orientation, annotation)
end

function OrientedBoundingBoxAnnotation(center::Point2{T}, width::T, height::T, orientation::T, label::L; kwargs...) where {L, T}
    return OrientedBoundingBoxAnnotation{L, T}(center, width, height, orientation, label; kwargs...)
end

# Equality

function Base.:(==)(a::OrientedBoundingBoxAnnotation, b::OrientedBoundingBoxAnnotation)
    return a.center == b.center &&
           a.width == b.width &&
           a.height == b.height &&
           a.orientation == b.orientation &&
           a.annotation == b.annotation
end

# Accessors

get_width(annotation::OrientedBoundingBoxAnnotation) = annotation.width
get_height(annotation::OrientedBoundingBoxAnnotation) = annotation.height
get_orientation(annotation::OrientedBoundingBoxAnnotation)::Float32 = annotation.orientation

get_image_annotation(annotation::OrientedBoundingBoxAnnotation) = annotation.annotation

# Methods

function get_centroid(annotation::OrientedBoundingBoxAnnotation{L, T})::Point2{T} where {L, T}
    return annotation.center
end

function get_bounding_box(annotation::OrientedBoundingBoxAnnotation{L, T})::Rect2{T} where {L, T}
    # Corners of non-oriented box
    tl = annotation.center - Point2{T}(annotation.width, annotation.height) / 2
    tr = tl + Point2{T}(annotation.width, 0)
    br = tr + Point2{T}(0, annotation.height)
    bl = br - Point2{T}(annotation.width, 0)

    # Calculate oriented box corners
    rotated_polygon = [
        rotate_point(tl, annotation.center, annotation.orientation),
        rotate_point(tr, annotation.center, annotation.orientation),
        rotate_point(br, annotation.center, annotation.orientation),
        rotate_point(bl, annotation.center, annotation.orientation),
    ]

    return get_bounding_box(rotated_polygon)
end

# Utility methods

function rotate_point(p::Point2{T}, origin::Point2{T}, theta::AbstractFloat)::Point2{T} where {T}
    x, y = p
    x0, y0 = origin

    st = sin(theta)
    ct = cos(theta)

    x2 = x0 + (x - x0)ct - (y - y0)st
    y2 = y0 + (x - x0)st + (y - y0)ct

    return Point2{T}(x2, y2)
end
