export AbstractDetector,
       detect,
       Detection,
       Point

abstract type AbstractDetector end

struct Point
    row::UInt32
    col::UInt32
end

mutable struct Detection
    polygon::Vector{Point}
    class::Int32
    confidence::Float32
end

detect(detector::AbstractDetector, image)::Vector{Detection} = error("No implementation for $(typeof(detector))")