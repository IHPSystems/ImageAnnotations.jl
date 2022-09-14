using GeometryBasics
using ImageAnnotations

@testset "PolygonDetection" begin
    vertices = [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]
    core_args = ("class", 0.7, 256, 256, MACHINE, "detector")
    detection = PolygonDetection(vertices, core_args...)

    @test centroid(detection) == [3, 7 / 3]
    bb = bounding_box(detection)
    @test bb.origin == [2.0, 2.0]
    @test bb.widths == [2.0, 1.0]

    @test_throws ArgumentError PolygonDetection([Point2(2.0, 2.0), Point2(4.0, 2.0)], core_args...)
end
