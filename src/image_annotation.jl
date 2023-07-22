abstract type AbstractImageAnnotation{L} end

struct ImageAnnotation{L} <: AbstractImageAnnotation{L}
    label::L
    confidence::Union{Float32, Nothing}
    annotator_name::Union{String, Nothing}
end

function ImageAnnotation(
    label::L; confidence::Union{Float32, Nothing} = nothing, annotator_name::Union{AbstractString, Nothing} = nothing
) where {L}
    return ImageAnnotation{L}(label, confidence, annotator_name)
end

function Base.:(==)(a::ImageAnnotation, b::ImageAnnotation)
    return a.label == b.label && a.confidence == b.confidence && a.annotator_name == b.annotator_name
end

get_label(annotation::ImageAnnotation) = annotation.label
get_confidence(annotation::ImageAnnotation) = annotation.confidence
get_annotator_name(annotation::ImageAnnotation) = annotation.annotator_name
