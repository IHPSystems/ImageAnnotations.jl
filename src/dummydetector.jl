import Detectors: AbstractDetector, detect
export DummyDetector, detect

mutable struct DummyDetector <: AbstractDetector
    DummyDetector() = new()
end

function _create_random_polygon()
    return [Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100)),
            Point(round(rand()*100), round(rand()*100))]
end

function detect(detector::DummyDetector, image)
    return [Detection(_create_random_polygon(), 0, rand()),
            Detection(_create_random_polygon(), 1, rand())]
end