import ObjectDetectors: AbstractObjectDetector, detect
export DummyObjectDetector, detect

mutable struct DummyObjectDetector <: AbstractObjectDetector
    DummyObjectDetector() = new()
end

function _create_random_polygon()
    return [Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100))]
end

function detect(detector::DummyObjectDetector, image)
    return [ObjectDetection(_create_random_polygon(), 0, rand()),
            ObjectDetection(_create_random_polygon(), 1, rand())]
end
