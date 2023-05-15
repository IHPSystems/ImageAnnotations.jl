abstract type AbstractObjectAnnotation{C, T <: Real} <: AbstractClassificationImageAnnotation{C} end

class(annotation::AbstractObjectAnnotation) = annotation.classification_annotation.class
confidence(annotation::AbstractObjectAnnotation) = annotation.classification_annotation.confidence
annotator_name(annotation::AbstractObjectAnnotation) = annotation.classification_annotation.annotator_name

function centroid(annotation::AbstractObjectAnnotation{T})::Point2{T} where {T}
    return error("No implementation for $(typeof(annotation))")
end

function bounding_box_annotation(annotation::AbstractObjectAnnotation{C, T})::BoundingBoxAnnotation{C, T} where {C, T}
    return error("No implementation for $(typeof(annotation))")
end

function bounding_box(annotation::AbstractObjectAnnotation{C, T})::Rect2{T} where {C, T}
    return bounding_box_annotation(annotation).rect
end

function iou(a1::AbstractObjectAnnotation{T}, a2::AbstractObjectAnnotation{T}) where {T}
    bb1 = bounding_box(a1)
    bb2 = bounding_box(a2)
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
