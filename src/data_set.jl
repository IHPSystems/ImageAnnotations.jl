abstract type AbstractImageAnnotationDataSet end

abstract type AbstractClassificationImageAnnotationDataSet{C} <: AbstractImageAnnotationDataSet end

struct ClassificationImageAnnotationDataSet{C} <: AbstractClassificationImageAnnotationDataSet{C}
    classes::Vector{C}
    annotated_images::Vector{AnnotatedImage}
end

function ClassificationImageAnnotationDataSet{C}() where {C}
    return ClassificationImageAnnotationDataSet(C[], AnnotatedImage[])
end

function Base.:(==)(a::ClassificationImageAnnotationDataSet, b::ClassificationImageAnnotationDataSet)
    return a.classes == b.classes && a.annotated_images == b.annotated_images
end

# Iteration interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration

Base.iterate(data_set::ClassificationImageAnnotationDataSet) = iterate(data_set.annotated_images)
Base.iterate(data_set::ClassificationImageAnnotationDataSet, state) = iterate(data_set.annotated_images, state)
Base.length(data_set::ClassificationImageAnnotationDataSet) = length(data_set.annotated_images)
Base.eltype(data_set::ClassificationImageAnnotationDataSet) = eltype(data_set.annotated_images)

# Indexing interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#Indexing

Base.getindex(data_set::ClassificationImageAnnotationDataSet, i::Int) = data_set.annotated_images[i]
Base.firstindex(data_set::ClassificationImageAnnotationDataSet) = firstindex(data_set.annotated_images)
Base.lastindex(data_set::ClassificationImageAnnotationDataSet) = lastindex(data_set.annotated_images)
