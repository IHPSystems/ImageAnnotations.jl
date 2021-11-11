struct PolygonDetection{T} <: AbstractObjectDetection{T}
    vertices::Vector{Point2{T}}
    core::ObjectDetectionCore

    function PolygonDetection(vertices::Vector{Point2{T}}, core_args...) where T
        if length(vertices) < 3
            throw(ArgumentError("Cannot create a polygon with less than 3 vertices."))
        end
        core = ObjectDetectionCore(core_args...)
        new{T}(vertices, core)
    end
end

vertices(detection::PolygonDetection) :: Vector{Point2} = detection.vertices

function centroid(detection::PolygonDetection{T}) :: Point2{T} where T
    return reduce((+), detection.vertices) / length(detection.vertices)
end

function bounding_box_detection(detection::PolygonDetection{T}) :: BoundingBoxDetection{T} where T
    return BoundingBoxDetection(detection.vertices, detection.core)
end
