abstract type AbstractPolygonAnnotation{L, T} <: AbstractObjectAnnotation{L, T} end

struct PolygonAnnotation{L, T} <: AbstractPolygonAnnotation{L, T}
    vertices::Vector{Point2{T}}
    annotation::ImageAnnotation{L}

    function PolygonAnnotation{L, T}(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
        if length(vertices) < 3
            throw(ArgumentError("Cannot create a polygon with less than 3 vertices."))
        end
        return new{L, T}(vertices, annotation)
    end
end

# Construction

function PolygonAnnotation(vertices::Vector{Point2{T}}, annotation::ImageAnnotation{L}) where {L, T}
    return PolygonAnnotation{L, T}(vertices, annotation)
end

# Construction with label, and kwargs...

function PolygonAnnotation{L, T}(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    annotation = ImageAnnotation(label; kwargs...)
    return PolygonAnnotation{L, T}(vertices, annotation)
end

function PolygonAnnotation(vertices::Vector{Point2{T}}, label::L; kwargs...) where {L, T}
    return PolygonAnnotation{L, T}(vertices, label; kwargs...)
end

# Equality

function Base.:(==)(a::PolygonAnnotation, b::PolygonAnnotation)
    return a.vertices == b.vertices && a.annotation == b.annotation
end

function Base.isapprox(a::PolygonAnnotation, b::PolygonAnnotation; kwargs...)
    return isapprox(a.vertices, b.vertices; kwargs...) && isapprox(a.annotation, b.annotation; kwargs...)
end

# Accessors

get_vertices(annotation::PolygonAnnotation)::Vector{Point2} = annotation.vertices

get_image_annotation(annotation::PolygonAnnotation) = annotation.annotation

# Methods

function get_bounding_box(annotation::PolygonAnnotation{L, T})::Rect2{T} where {L, T}
    return get_bounding_box(annotation.vertices)
end

function get_centroid(annotation::PolygonAnnotation{L, T})::Point2{T} where {L, T <: Real}
    return reduce((+), annotation.vertices) / length(annotation.vertices)
end

function simplify_geometry(
    annotation::PolygonAnnotation{L, T}; angular_atol::Real = zero(T), digits::Int = 10
)::AbstractObjectAnnotation{L, T} where {L, T <: Real}
    vertices = get_vertices(annotation)
    if length(vertices) != 4
        return annotation
    end
    ab = vertices[2] - vertices[1]
    bc = vertices[3] - vertices[2]
    cd = vertices[4] - vertices[3]
    da = vertices[1] - vertices[4]
    ab_normalized = normalize(ab)
    bc_normalized = normalize(bc)
    cd_normalized = normalize(cd)
    da_normalized = normalize(da)
    ab_bc_angle = acos(round(abs(dot(ab_normalized, bc_normalized)); digits = digits))
    ab_cd_angle = acos(round(abs(dot(ab_normalized, cd_normalized)); digits = digits))
    bc_da_angle = acos(round(abs(dot(bc_normalized, da_normalized)); digits = digits))
    ab_bc_perpendicular = abs(ab_bc_angle - pi / 2) < angular_atol
    ab_cd_parallel = ab_cd_angle < angular_atol
    bc_da_parallel = bc_da_angle < angular_atol
    if !(ab_bc_perpendicular && ab_cd_parallel && bc_da_parallel)
        return annotation
    end
    if ab[1] >= 0.0 && ab[2] >= 0.0
        orientation = acos(round(abs(dot(Point2{T}(1, 0), ab_normalized)); digits = digits))
    elseif ab[1] < 0.0 && ab[2] >= 0.0
        orientation = acos(round(abs(dot(Point2{T}(0, 1), ab_normalized)); digits = digits)) + pi / 2
    elseif ab[1] < 0.0 && ab[2] < 0.0
        orientation = acos(round(abs(dot(Point2{T}(-1, 0), ab_normalized)); digits = digits)) + pi
    else
        orientation = acos(round(abs(dot(Point2{T}(0, -1), ab_normalized)); digits = digits)) + 3pi / 2
    end
    if rem(orientation, pi / 2) < angular_atol
        sorted_vertices = sort(vertices)
        top_left = first(sorted_vertices)
        bottom_right = last(sorted_vertices)
        return BoundingBoxAnnotation(top_left, bottom_right, get_image_annotation(annotation))
    end
    width = norm(ab)
    height = norm(bc)
    return OrientedBoundingBoxAnnotation(get_centroid(annotation), width, height, orientation, get_image_annotation(annotation))
end
