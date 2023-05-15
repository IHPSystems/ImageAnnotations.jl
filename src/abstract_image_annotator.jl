abstract type AbstractImageAnnotator end

abstract type AbstractClassificationImageAnnotator{C, A <: AbstractClassificationImageAnnotation{C}} <: AbstractImageAnnotator end

abstract type AbstractRegressionImageAnnotator{T, A <: AbstractRegressionImageAnnotation{T}} <: AbstractImageAnnotator end

abstract type AbstractObjectAnnotator{C, T, A <: AbstractObjectAnnotation{C, T}} <: AbstractImageAnnotator end

annotate(image, annotator::AbstractImageAnnotator) = error("No implementation for $(typeof(annotator))")
