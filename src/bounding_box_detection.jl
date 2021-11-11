struct BoundingBoxDetection{T} <: AbstractObjectDetection{T}
    rect::Rect2{T}
    core::ObjectDetectionCore

    function BoundingBoxDetection(top_left::Point2{T}, width::T, height::T, core_args...) where T
        core = ObjectDetectionCore(core_args...)
        new{T}(Rect2{T}(top_left.data[1], top_left.data[2], width, height), core)
    end

    function BoundingBoxDetection(top_left::Point2{T}, bottom_right::Point2{T}, core_args...) where T
        width = bottom_right.data[1] - top_left.data[1]
        height = bottom_right.data[2] - top_left.data[2]
        BoundingBoxDetection(top_left, width, height, core_args...)
    end

    function BoundingBoxDetection(vertices::Vector{Point2{T}}, core::ObjectDetectionCore) where T
        min_x = minimum([x for (x,_) in vertices])
        max_x = maximum([x for (x,_) in vertices])
        min_y = minimum([y for (_,y) in vertices])
        max_y = maximum([y for (_,y) in vertices])

        width = max_x - min_x
        height = max_y - min_y

        new{T}(Rect2{T}(min_x, min_y, width, height), core)
    end

    function BoundingBoxDetection(vertices::Vector{Point2{T}}, core_args...) where T
        core = ObjectDetectionCore(core_args...)
        BoundingBoxDetection(vertices, core)
    end

    function BoundingBoxDetection(box::Rect2{T}, core_args...) where T
        core = ObjectDetectionCore(core_args...)
        new{T}(box, core)
    end
end

function create_with_center(center::Point2{T}, width::T, height::T, core_args...) where T
    top_left = center - Point2{T}(width, height) / 2
    return BoundingBoxDetection(top_left, width, height, core_args...)
end

function centroid(detection::BoundingBoxDetection{T}) :: Point2{T} where T
    return bounding_box(detection).origin + bounding_box(detection).widths / 2
end

function bounding_box_detection(detection::BoundingBoxDetection{T}) :: BoundingBoxDetection{T} where T
    return detection
end
