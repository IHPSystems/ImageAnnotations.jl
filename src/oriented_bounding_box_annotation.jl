struct OrientedBoundingBoxAnnotation{C, T} <: AbstractObjectAnnotation{C, T}
    center::Point2{T}
    width::T
    height::T
    orientation::Float32
    classification_annotation::ClassificationImageAnnotation{C}
end

function OrientedBoundingBoxAnnotation(center::Point2{T}, width::T, height::T, orientation::T, class::C; kwargs...) where {C, T}
    core = ClassificationImageAnnotation(class; kwargs...)
    return OrientedBoundingBoxAnnotation{C, T}(center, width, height, orientation, core)
end

width(annotation::OrientedBoundingBoxAnnotation) = annotation.width
height(annotation::OrientedBoundingBoxAnnotation) = annotation.height
orientation(annotation::OrientedBoundingBoxAnnotation)::Float32 = annotation.orientation

function centroid(annotation::OrientedBoundingBoxAnnotation{C, T})::Point2{T} where {C, T}
    return annotation.center
end

function bounding_box_annotation(annotation::OrientedBoundingBoxAnnotation{C, T})::BoundingBoxAnnotation{C, T} where {C, T}
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

    return BoundingBoxAnnotation(rotated_polygon, annotation.classification_annotation)
end

function rotate_point(p::Point2{T}, origin::Point2{T}, theta::AbstractFloat)::Point2{T} where {T}
    x, y = p
    x0, y0 = origin

    st = sin(theta)
    ct = cos(theta)

    x2 = x0 + (x - x0)ct - (y - y0)st
    y2 = y0 + (x - x0)st + (y - y0)ct

    return Point2{T}(x2, y2)
end
