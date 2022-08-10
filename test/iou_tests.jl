using GeometryBasics
using ImageAnnotations

@testset "Intersection over Union" begin
    core_args = ("class", 0.7, 256, 256, MACHINE, "detector")

    box1 = BoundingBoxDetection(Point2(0.0, 0.0), Point2(3.0, 4.0), core_args...)
    @test iou(box1, box1) == 1

    box2 = BoundingBoxDetection(Point2(1.0, 2.0), Point2(3.0, 4.0), core_args...)
    @test iou(box1, box2) == 1 / 3

    box3 = BoundingBoxDetection(Point2(1.0, 2.0), Point2(4.0, 6.0), core_args...)
    @test iou(box1, box3) == 1 / 5

    box4 = BoundingBoxDetection(Point2(5.0, 5.0), Point2(6.0, 6.0), core_args...)
    @test iou(box1, box4) == 0
end
