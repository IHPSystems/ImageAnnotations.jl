struct AnnotatedImage
    annotations::Vector{AbstractImageAnnotation}
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

function AnnotatedImage(; kwargs...)
    return AnnotatedImage(AbstractImageAnnotation[]; kwargs...)
end

function AnnotatedImage(annotation::AbstractImageAnnotation; kwargs...)
    return AnnotatedImage(AbstractImageAnnotation[annotation]; kwargs...)
end

function Base.:(==)(a::AnnotatedImage, b::AnnotatedImage)
    return a.annotations == b.annotations &&
           a.image_file_path == b.image_file_path &&
           a.image_height == b.image_height &&
           a.image_width == b.image_width
end

annotations(annotated_image::AnnotatedImage) = annotated_image.annotations
