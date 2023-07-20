using GeometryBasics
using ImageAnnotations

@testset "Intersection over Union" begin
    label = "class"
    annotation_args = (confidence = Float32(0.7), annotator_name = "annotator")

    box1 = BoundingBoxAnnotation(Point2(0.0, 0.0), Point2(3.0, 4.0), label; annotation_args...)
    @test compute_iou(box1, box1) == 1

    box2 = BoundingBoxAnnotation(Point2(1.0, 2.0), Point2(3.0, 4.0), label; annotation_args...)
    @test compute_iou(box1, box2) == 1 / 3

    box3 = BoundingBoxAnnotation(Point2(1.0, 2.0), Point2(4.0, 6.0), label; annotation_args...)
    @test compute_iou(box1, box3) == 1 / 5

    box4 = BoundingBoxAnnotation(Point2(5.0, 5.0), Point2(6.0, 6.0), label; annotation_args...)
    @test compute_iou(box1, box4) == 0
end
