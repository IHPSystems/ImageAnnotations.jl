abstract type AbstractObjectAnnotation{L, T <: Real} <: AbstractImageAnnotation{L} end

get_label(annotation::AbstractObjectAnnotation) = get_label(annotation.annotation)
get_confidence(annotation::AbstractObjectAnnotation) = get_confidence(annotation.annotation)
get_annotator_name(annotation::AbstractObjectAnnotation) = get_annotator_name(annotation.annotation)

function get_centroid(annotation::AbstractObjectAnnotation{T})::Point2{T} where {T}
    return error("No implementation for $(typeof(annotation))")
end

function get_bounding_box(annotation::AbstractObjectAnnotation{L, T})::Rect2{T} where {L, T}
    return error("No implementation for $(typeof(annotation))")
end

function compute_iou(a1::AbstractObjectAnnotation{T}, a2::AbstractObjectAnnotation{T}) where {T}
    bb1 = get_bounding_box(a1)
    bb2 = get_bounding_box(a2)
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
