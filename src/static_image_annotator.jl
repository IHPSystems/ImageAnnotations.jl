struct StaticClassificationImageAnnotator{C, A <: AbstractClassificationImageAnnotation{C}} <: AbstractClassificationImageAnnotator{C, A}
    annotations::Vector{A}
end

struct StaticRegressionImageAnnotator{T, A <: AbstractRegressionImageAnnotation{T}} <: AbstractRegressionImageAnnotator{T, A}
    annotations::Vector{A}
end

struct StaticObjectAnnotator{C, T <: Real, A <: AbstractObjectAnnotation{C, T}} <: AbstractObjectAnnotator{C, T, A}
    annotations::Vector{A}
end

function annotate(image, annotator::Union{StaticClassificationImageAnnotator, StaticRegressionImageAnnotator, StaticObjectAnnotator})
    return annotator.annotations
end
