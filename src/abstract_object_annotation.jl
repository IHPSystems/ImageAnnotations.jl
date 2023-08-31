abstract type AbstractObjectAnnotation{L, T <: Real} <: AbstractImageAnnotation{L} end

function get_height end

function get_vertices end

function get_width end

function get_image_annotation end

get_label(annotation::AbstractObjectAnnotation) = get_label(get_image_annotation(annotation))
get_confidence(annotation::AbstractObjectAnnotation) = get_confidence(get_image_annotation(annotation))
get_annotator_name(annotation::AbstractObjectAnnotation) = get_annotator_name(get_image_annotation(annotation))

function get_centroid(annotation::AbstractObjectAnnotation{T})::Point2{T} where {T}
    return error("No implementation for $(typeof(annotation))")
end

function get_bounding_box(annotation::AbstractObjectAnnotation{L, T})::Rect2{T} where {L, T}
    return error("No implementation for $(typeof(annotation))")
end

function Base.isless(a::T, b::U) where {T <: AbstractObjectAnnotation, U <: AbstractObjectAnnotation}
    if Symbol(T) < Symbol(U)
        return true
    elseif Symbol(U) < Symbol(T)
        return false
    end
    a_box = get_bounding_box(a)
    b_box = get_bounding_box(b)
    if a_box.origin.data[1] < b_box.origin.data[1]
        return true
    elseif a_box.origin.data[1] > b_box.origin.data[1]
        return false
    elseif a_box.origin.data[2] < b_box.origin.data[2]
        return true
    elseif a_box.origin.data[2] > b_box.origin.data[2]
        return false
    elseif a_box.widths.data[1] < b_box.widths.data[1]
        return true
    elseif a_box.widths.data[1] > b_box.widths.data[1]
        return false
    elseif a_box.widths.data[2] < b_box.widths.data[2]
        return true
    elseif a_box.widths.data[2] > b_box.widths.data[2]
        return false
    else
        return get_image_annotation(a) < get_image_annotation(b)
    end
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
