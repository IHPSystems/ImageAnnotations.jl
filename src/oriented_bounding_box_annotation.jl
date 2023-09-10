abstract type AbstractOrientedBoundingBoxAnnotation{L, T} <: AbstractObjectAnnotation{L, T} end

function get_orientation end

struct OrientedBoundingBoxAnnotation{L, T} <: AbstractOrientedBoundingBoxAnnotation{L, T}
    center::Point2{T}
    width::T
    height::T
    orientation::T
    annotation::ImageAnnotation{L}
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

function Base.isapprox(
    a::OrientedBoundingBoxAnnotation{L, T},
    b::OrientedBoundingBoxAnnotation{L, T};
    atol::Real = zero(T),
    rtol::Real = atol > 0 ? zero(T) : √eps(T),
    linear_atol::Real = atol,
    linear_rtol::Real = rtol,
    angular_atol::Real = atol,
    angular_rtol::Real = rtol,
    orientation_symmetry::Bool = false,
    kwargs...,
) where {L, T}
    a_orientation = orientation_symmetry ? mod(a.orientation, π) : a.orientation
    b_orientation = orientation_symmetry ? mod(b.orientation, π) : b.orientation
    return isapprox(a.center, b.center; atol = linear_atol, rtol = linear_rtol, kwargs...) &&
           isapprox(a.width, b.width; atol = linear_atol, rtol = linear_rtol, kwargs...) &&
           isapprox(a.height, b.height; atol = linear_atol, rtol = linear_rtol, kwargs...) &&
           isapprox(a_orientation, b_orientation; atol = angular_atol, rtol = angular_rtol, kwargs...) &&
           isapprox(a.annotation, b.annotation; atol = atol, rtol = rtol, kwargs...)
end

# Accessors

get_width(annotation::OrientedBoundingBoxAnnotation) = annotation.width
get_height(annotation::OrientedBoundingBoxAnnotation) = annotation.height
get_orientation(annotation::OrientedBoundingBoxAnnotation) = annotation.orientation

get_image_annotation(annotation::OrientedBoundingBoxAnnotation) = annotation.annotation

# Methods

function get_centroid(annotation::OrientedBoundingBoxAnnotation{L, T})::Point2{T} where {L, T}
    return annotation.center
end

function get_bounding_box(annotation::OrientedBoundingBoxAnnotation{L, T})::Rect2{T} where {L, T}
    rotated_polygon = get_vertices(annotation)
    return get_bounding_box(rotated_polygon)
end

function get_vertices(annotation::OrientedBoundingBoxAnnotation{L, T})::Vector{Point2{T}} where {L, T}
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
    return rotated_polygon
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
