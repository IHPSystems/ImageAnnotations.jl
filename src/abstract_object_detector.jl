let TDetection = AbstractObjectDetection{T} where {T <: Real}
    abstract type AbstractObjectDetector{TDetection} end

    detect(detector::AbstractObjectDetector{TDetection}, image)::Vector{TDetection} = error("No implementation for $(typeof(detector))")
end
