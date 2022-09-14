using GeometryBasics
using ImageAnnotations

@testset "OrientedBoundingBoxDetectionTests" begin
    core_args = ("class", 0.7, 256, 256, MACHINE, "detector")
    detection = OrientedBoundingBoxDetection(Point2(3.0, 3.0), 4.0, 2.0, pi / 2, core_args...)

    bb = bounding_box(detection)
    error_margin = 1.0e-5
    origin_diff = bb.origin - Point2(2.0, 1.0)
    @test abs(origin_diff.data[1]) < error_margin && abs(origin_diff.data[2]) < error_margin
    widths_diff = bb.widths - Point2(2.0, 4.0)
    @test abs(widths_diff.data[1]) < error_margin && abs(widths_diff.data[2]) < error_margin
end
