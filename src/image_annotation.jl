abstract type AbstractImageAnnotation{L} end

mutable struct ImageAnnotation{L} <: AbstractImageAnnotation{L}
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

function Base.isless(a::ImageAnnotation, b::ImageAnnotation)
    if a.label !== b.label
        return a.label < b.label
    end
    if a.confidence === nothing
        if b.confidence === nothing
            if a.annotator_name === nothing
                return b.annotator_name !== nothing
            else
                if b.annotator_name === nothing
                    return false
                else
                    return a.annotator_name < b.annotator_name
                end
            end
        else
            return true
        end
    else
        if b.confidence === nothing
            return false
        else
            if a.confidence !== b.confidence
                return a.confidence < b.confidence
            else
                if a.annotator_name === nothing
                    return b.annotator_name !== nothing
                else
                    if b.annotator_name === nothing
                        return false
                    else
                        return a.annotator_name < b.annotator_name
                    end
                end
            end
        end
    end
end

get_label(annotation::ImageAnnotation) = annotation.label
get_confidence(annotation::ImageAnnotation) = annotation.confidence
get_annotator_name(annotation::ImageAnnotation) = annotation.annotator_name
