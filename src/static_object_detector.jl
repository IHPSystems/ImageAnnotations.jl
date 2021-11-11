struct StaticObjectDetector{TDetection <: AbstractObjectDetection} <: AbstractObjectDetector{TDetection}
    detections::Vector{TDetection}
end

function detect(detector::StaticObjectDetector, image)
    return detector.detections
end
