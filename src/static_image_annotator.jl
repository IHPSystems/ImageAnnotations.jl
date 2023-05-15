struct StaticImageAnnotator{L, A <: AbstractImageAnnotation{L}} <: AbstractImageAnnotator{L, A}
    annotations::Vector{A}
end

struct StaticObjectAnnotator{L, T <: Real, A <: AbstractObjectAnnotation{L, T}} <: AbstractObjectAnnotator{L, T, A}
    annotations::Vector{A}
end

function annotate(image::AbstractArray{<:Colorant,2}, annotator::Union{StaticImageAnnotator, StaticObjectAnnotator})
    return annotator.annotations
end
