abstract type AbstractLazyImage{TPixel <: Colorant} end

struct LazyImageIOImage{TPixel} <: AbstractLazyImage{TPixel}
    path::Union{String, Nothing}
    image::Union{Array{TPixel, 2}, Nothing}
end

LazyImageIOImage{TPixel}(path::String) = LazyImageIOImage{TPixel}(path, nothing)

# Instance properties

Base.propertynames(::LazyImageIOImage) = fieldnames(LazyImageIOImage)

function Base.getproperty(image::LazyImageIOImage, name::Symbol)
    if name == :image
        if image.image === nothing
            image.image = load(image.path)
        end
        return image.image
    else
        return getfield(image, name)
    end
end
