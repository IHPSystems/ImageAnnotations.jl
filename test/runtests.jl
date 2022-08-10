using Test

@testset "ImageAnnotations" begin
    include("static_object_detector_tests.jl")
    include("bounding_box_detection_tests.jl")
    include("oriented_bounding_box_detection_tests.jl")
    include("polygon_detection_tests.jl")
    include("iou_tests.jl")
end
