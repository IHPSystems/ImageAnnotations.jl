abstract type AbstractClassificationImageAnnotation{C} <: AbstractImageAnnotation end

struct ClassificationImageAnnotation{C} <: AbstractClassificationImageAnnotation{C}
    class::C
    confidence::Union{Float32, Nothing}
    annotator_name::Union{String, Nothing}
end

function ClassificationImageAnnotation(
    class::C; confidence::Union{Float32, Nothing} = nothing, annotator_name::Union{String, Nothing} = nothing
) where {C}
    return ClassificationImageAnnotation{C}(class, confidence, annotator_name)
end

class(annotation::ClassificationImageAnnotation) = annotation.class
confidence(annotation::ClassificationImageAnnotation) = annotation.confidence
annotator_name(annotation::ClassificationImageAnnotation) = annotation.annotator_name
