abstract type AbstractRegressionImageAnnotation{T <: Real} <: AbstractImageAnnotation end

struct RegressionImageAnnotation{T} <: AbstractRegressionImageAnnotation{T}
    value::T
    confidence::Union{Float32, Nothing}
    annotator_name::Union{String, Nothing}
end

function RegressionImageAnnotation(
    value::T; confidence::Union{Float32, Nothing} = nothing, annotator_name::Union{String, Nothing} = nothing
) where {T}
    return RegressionImageAnnotation{T}(value, confidence, annotator_name)
end

value(annotation::RegressionImageAnnotation) = annotation.value
confidence(annotation::RegressionImageAnnotation) = annotation.confidence
annotator_name(annotation::RegressionImageAnnotation) = annotation.annotator_name
