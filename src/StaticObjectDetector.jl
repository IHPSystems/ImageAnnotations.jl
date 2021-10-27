import ObjectDetectors: AbstractObjectDetector, detect, ObjectDetection, Point
export StaticObjectDetector, detect, createpolygon

function createpolygon(center_x::UInt32, center_y::UInt32)::Array{Point, 1}
    return [Point(center_x, center_y)]
end

mutable struct StaticObjectDetector <: AbstractObjectDetector
    detections::Array{ObjectDetection, 1}

    StaticObjectDetector(detections::Array{ObjectDetection, 1}) = new(detections)
    function StaticObjectDetector(detectionparams...) :: StaticObjectDetector
        detector = new(ObjectDetection[])
        for detectionparam = detectionparams
            class = Int32(detectionparam[3])
            confidence = detectionparam[4]
            polygon = createpolygon(Array{UInt32, 1}(detectionparam[1:2])...)
            detection = ObjectDetection(polygon, class, confidence)
            push!(detector.detections, detection)
        end
        return detector
    end
end

function detect(detector::StaticObjectDetector, image)
    return detector.detections
end
