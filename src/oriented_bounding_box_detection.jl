struct OrientedBoundingBoxDetection{T} <: AbstractObjectDetection{T}
    center::Point2{T}
    width::T
    height::T
    orientation::Float32
    core::ObjectDetectionCore

    function OrientedBoundingBoxDetection(center::Point2{T}, width::T, height::T, orientation::T, core_args...) where {T}
        core = ObjectDetectionCore(core_args...)
        return new{T}(center, width, height, orientation, core)
    end
end

width(detection::OrientedBoundingBoxDetection) = detection.width
height(detection::OrientedBoundingBoxDetection) = detection.height
orientation(detection::OrientedBoundingBoxDetection)::Float32 = detection.orientation

function centroid(detection::OrientedBoundingBoxDetection{T})::Point2{T} where {T}
    return detection.center
end

function bounding_box_detection(detection::OrientedBoundingBoxDetection{T})::BoundingBoxDetection{T} where {T}
    # Corners of non-oriented box
    tl = detection.center - Point2{T}(detection.width, detection.height) / 2
    tr = tl + Point2{T}(detection.width, 0)
    br = tr + Point2{T}(0, detection.height)
    bl = br - Point2{T}(detection.width, 0)

    # Calculate oriented box corners
    rotated_polygon = [
        rotate_point(tl, detection.center, detection.orientation),
        rotate_point(tr, detection.center, detection.orientation),
        rotate_point(br, detection.center, detection.orientation),
        rotate_point(bl, detection.center, detection.orientation),
    ]

    return BoundingBoxDetection(rotated_polygon, detection.core)
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
