import Detectors: AbstractDetector, detect, Detection, Point
export StaticDetector, detect, createpolygon

function createpolygon(center_x::UInt32, center_y::UInt32)::Array{Point, 1}
    return [Point(center_x, center_y)]
end

mutable struct StaticDetector <: AbstractDetector
    detections::Array{Detection, 1}

    StaticDetector(detections::Array{Detection, 1}) = new(detections)
    function StaticDetector(detectionparams...) :: StaticDetector
        detector = new(Detection[])
        for detectionparam = detectionparams
            class = Int32(detectionparam[3])
            confidence = detectionparam[4]
            polygon = createpolygon(Array{UInt32, 1}(detectionparam[1:2])...)
            detection = Detection(polygon, class, confidence)
            push!(detector.detections, detection)
        end
        return detector
    end
end

function detect(detector::StaticDetector, image)
    return detector.detections
end
