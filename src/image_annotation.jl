mutable struct ImageAnnotation{L} <: AbstractImageAnnotation{L}
    label::L
    confidence::Union{Float32, Nothing}
    annotator_name::Union{String, Nothing}
end

function ImageAnnotation{L}(
    label::L; confidence::Union{Float32, Nothing} = nothing, annotator_name::Union{AbstractString, Nothing} = nothing
) where {L}
    return ImageAnnotation{L}(label, confidence, annotator_name)
end

ImageAnnotation(label::L; kwargs...) where {L} = ImageAnnotation{L}(label; kwargs...)

function Base.:(==)(a::ImageAnnotation, b::ImageAnnotation)
    return a.label == b.label && a.confidence == b.confidence && a.annotator_name == b.annotator_name
end

function Base.isapprox(a::ImageAnnotation{L}, b::ImageAnnotation{L}; kwargs...) where {L}
    label_isapprox = L <: AbstractFloat ? isapprox(a.label, b.label; kwargs...) : a.label == b.label
    a_confidence, b_confidence = a.confidence, b.confidence
    a_annotator_name, b_annotator_name = a.annotator_name, b.annotator_name
    conf_isapprox =
        (isnothing(a_confidence) && isnothing(b_confidence)) ||
        (!isnothing(a_confidence) && !isnothing(b_confidence) && isapprox(a_confidence, b_confidence; kwargs...))
    annotator_isapprox =
        isnothing(a_annotator_name) && isnothing(b_annotator_name) ||
        (!isnothing(a_annotator_name) && !isnothing(b_annotator_name) && a_annotator_name == b_annotator_name)
    return label_isapprox && conf_isapprox && annotator_isapprox
end

get_label(annotation::ImageAnnotation) = annotation.label
get_confidence(annotation::ImageAnnotation) = annotation.confidence
get_annotator_name(annotation::ImageAnnotation) = annotation.annotator_name
