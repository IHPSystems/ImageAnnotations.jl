struct AnnotatedImage{A <: AbstractImageAnnotation}
    annotations::Vector{A}
    image_file_path::Union{String, Nothing}
    image_height::Union{Int, Nothing}
    image_width::Union{Int, Nothing}
end

function AnnotatedImage(
    annotations::Vector{A};
    image_file_path::Union{String, Nothing} = nothing,
    image_height::Union{Int, Nothing} = nothing,
    image_width::Union{Int, Nothing} = nothing,
) where {A <: AbstractImageAnnotation}
    return AnnotatedImage(annotations, image_file_path, image_height, image_width)
end

function AnnotatedImage{A}() where {A <: AbstractImageAnnotation}
    return AnnotatedImage(A[])
end

function AnnotatedImage(annotation::A) where {A <: AbstractImageAnnotation}
    return AnnotatedImage([annotation])
end

annotations(annotated_image::AnnotatedImage) = annotated_image.annotations
