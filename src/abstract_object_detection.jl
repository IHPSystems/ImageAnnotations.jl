abstract type AbstractObjectDetection{T <: Real} end

@enum DetectorType HUMAN MACHINE

struct ObjectDetectionCore
    class_name::String
    confidence::Union{Float32, Nothing}
    image_width::Union{Int, Nothing}
    image_height::Union{Int, Nothing}
    detector_type::DetectorType
    detector_name::String
end

function ObjectDetectionCore(class_name::String, detector_type::DetectorType, detector_name::String)
    return ObjectDetectionCore(class_name, nothing, nothing, nothing, detector_type, detector_name)
end

function ObjectDetectionCore(class_name::String, confidence::Float32, detector_type::DetectorType, detector_name::String)
    return ObjectDetectionCore(class_name, confidence, nothing, nothing, detector_type, detector_name)
end

class_name(detection::AbstractObjectDetection) = detection.core.class_name
confidence(detection::AbstractObjectDetection) = detection.core.confidence
image_width(detection::AbstractObjectDetection) = detection.core.image_width
image_height(detection::AbstractObjectDetection) = detection.core.image_height
detector_type(detection::AbstractObjectDetection) = detection.core.detector_type
detector_name(detection::AbstractObjectDetection) = detection.core.detector_name

function centroid(detection::AbstractObjectDetection{T})::Point2{T} where {T}
    return error("No implementation for $(typeof(detection))")
end

function bounding_box_detection(detection::AbstractObjectDetection{T})::BoundingBoxDetection{T} where {T}
    return error("No implementation for $(typeof(detection))")
end

function bounding_box(detection::AbstractObjectDetection{T})::Rect2{T} where {T}
    return bounding_box_detection(detection).rect
end

function iou(d1::AbstractObjectDetection{T}, d2::AbstractObjectDetection{T}) where {T}
    bb1 = bounding_box(d1)
    bb2 = bounding_box(d2)
    left_1, top_1 = bb1.origin
    right_1, bottom_1 = bb1.origin + bb1.widths
    left_2, top_2 = bb2.origin
    right_2, bottom_2 = bb2.origin + bb2.widths

    if bottom_1 <= top_2 || bottom_2 <= top_1 || right_1 <= left_2 || right_2 <= left_1
        return 0.0
    end

    area_1 = (bottom_1 - top_1) * (right_1 - left_1)
    area_2 = (bottom_2 - top_2) * (right_2 - left_2)

    a = min(right_1, right_2)
    b = max(top_1, top_2)
    c = max(left_1, left_2)
    d = min(bottom_1, bottom_2)
    intersection = (d - b) * (a - c)
    union = area_1 + area_2 - intersection

    return intersection / union
end
