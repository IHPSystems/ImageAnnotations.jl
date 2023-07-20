abstract type AbstractImageAnnotator{L, A <: AbstractImageAnnotation{L}} end

abstract type AbstractObjectAnnotator{L, T, A <: AbstractObjectAnnotation{L, T}} <: AbstractImageAnnotator{L, A} end

annotate(image, annotator::AbstractImageAnnotator) = error("No implementation for $(typeof(annotator))")
