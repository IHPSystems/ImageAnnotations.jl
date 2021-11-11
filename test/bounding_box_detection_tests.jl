using ObjectDetectors
using GeometryBasics

@testset "BoundingBoxDetection" begin
    core_args = ("class", 0.7, 256, 256, MACHINE, "detector")

    box1 = BoundingBoxDetection(Point2(0.0, 1.0), 3.0, 6.0, core_args...)
    @test centroid(box1) == [1.5, 4.0]

    box2 = BoundingBoxDetection(Point2(1.0, 2.0), Point2(3.0, 4.0), core_args...)
    @test centroid(box2) == [2.0, 3.0]

    box3 = BoundingBoxDetection([Point2(0.0, 0.0), Point2(2.0, 0.0), Point2(2.0, 2.0), Point2(0.0, 2.0)], core_args...)
    @test centroid(box3) == [1.0, 1.0]

    box4 = BoundingBoxDetection(Rect2(0.0, 0.0, 1.0, 1.0), core_args...)
    @test centroid(box4) == [0.5, 0.5]

    box5 = create_with_center(Point2(3.0, 3.0), 5.0, 3.0, core_args...)
    @test centroid(box5) == [3.0, 3.0]
end
