abstract type AbstractImageAnnotationDataSet end

abstract type AbstractObjectDetectionDataSet <: AbstractImageAnnotationDataSet end

struct ObjectDetectionDataSet{TObjectDetection <: AbstractObjectDetection} <: AbstractObjectDetectionDataSet
    classes::Vector{String}
    annotated_images::Vector{AnnotatedImage{TObjectDetection}}
end

# Iteration interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#man-interface-iteration

Base.iterate(data_set::ObjectDetectionDataSet) = iterate(data_set.annotated_images)
Base.iterate(data_set::ObjectDetectionDataSet, state) = iterate(data_set.annotated_images, state)
Base.length(data_set::ObjectDetectionDataSet) = length(data_set.annotated_images)
Base.eltype(data_set::ObjectDetectionDataSet) = eltype(data_set.annotated_images)

# Indexing interface, cf. https://docs.julialang.org/en/v1/manual/interfaces/#Indexing

Base.getindex(data_set::ObjectDetectionDataSet, i::Int) = data_set.annotated_images[i]
Base.firstindex(data_set::ObjectDetectionDataSet) = firstindex(data_set.annotated_images)
Base.lastindex(data_set::ObjectDetectionDataSet) = lastindex(data_set.annotated_images)
