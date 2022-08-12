struct AnnotatedImage{TImageAnnotation <: AbstractObjectDetection} # TODO AbstractObjectDetection should be AbstractImageAnnotation
    path::String
    annotations::Vector{TImageAnnotation}
end
