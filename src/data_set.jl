abstract type AbstractImageAnnotationDataSet end

struct ImageAnnotationDataSet{L} <: AbstractImageAnnotationDataSet
    schema::Vector{L}
    annotated_images::Vector{AnnotatedImage}
end

function ImageAnnotationDataSet{L}() where {L}
    return ImageAnnotationDataSet(L[], AnnotatedImage[])
end

function ImageAnnotationDataSet(annotated_images::Vector{AnnotatedImage})
    return ImageAnnotationDataSet(get_labels(annotated_images), annotated_images)
end

function ImageAnnotationDataSet(annotated_image::AnnotatedImage)
    return ImageAnnotationDataSet([annotated_image])
end

function Base.:(==)(a::ImageAnnotationDataSet, b::ImageAnnotationDataSet)
    return a.schema == b.schema && a.annotated_images == b.annotated_images
end

# Iteration interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration

Base.iterate(data_set::ImageAnnotationDataSet) = iterate(data_set.annotated_images)
Base.iterate(data_set::ImageAnnotationDataSet, state) = iterate(data_set.annotated_images, state)
Base.length(data_set::ImageAnnotationDataSet) = length(data_set.annotated_images)
Base.eltype(data_set::ImageAnnotationDataSet) = eltype(data_set.annotated_images)

# Indexing interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#Indexing

Base.getindex(data_set::ImageAnnotationDataSet, i::Int) = data_set.annotated_images[i]
Base.firstindex(data_set::ImageAnnotationDataSet) = firstindex(data_set.annotated_images)
Base.lastindex(data_set::ImageAnnotationDataSet) = lastindex(data_set.annotated_images)

get_labels(data_set::ImageAnnotationDataSet) = get_labels(data_set.annotated_images)

get_labels(annotated_images::Vector{AnnotatedImage}) = unique(get_label.(Iterators.flatten(get_annotations.(annotated_images))))
