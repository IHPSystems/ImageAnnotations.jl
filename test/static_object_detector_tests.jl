using ObjectDetectors
using GeometryBasics

@testset "StaticObjectDetector" begin
    vertices = [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]
    core_args = ("class", 0.7, 256, 256, MACHINE, "detector")
    detection = PolygonDetection(vertices, core_args...)
    detector = StaticObjectDetector{PolygonDetection{Float64}}([detection])
    img = Array{UInt8}(undef, 10, 10, 3)
    detections = detect(detector, img)

    @test length(detections) == 1
    @test detections[1].core.class_name == "class"
    @test detections[1].core.confidence == 0.7f0
    @test centroid(detections[1]) == [3, 7 / 3]
end
