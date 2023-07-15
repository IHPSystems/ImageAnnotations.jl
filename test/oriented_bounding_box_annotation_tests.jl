using GeometryBasics
using ImageAnnotations

@testset "OrientedBoundingBoxAnnotationTests" begin
    class = "class"
    classification_args = (confidence = Float32(0.7), annotator_name = "annotator")
    annotation = OrientedBoundingBoxAnnotation(Point2(3.0, 3.0), 4.0, 2.0, pi / 2, class; classification_args...)

    bb = bounding_box(annotation)
    error_margin = 1.0e-5
    origin_diff = bb.origin - Point2(2.0, 1.0)
    @test abs(origin_diff.data[1]) < error_margin && abs(origin_diff.data[2]) < error_margin
    widths_diff = bb.widths - Point2(2.0, 4.0)
    @test abs(widths_diff.data[1]) < error_margin && abs(widths_diff.data[2]) < error_margin

    @testset "Equality" begin
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") ==
            OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car")
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") !=
            OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "person")
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") !=
            OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 4, "car")
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") !=
            OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 3.0, pi / 2, "car")
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") !=
            OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 2.0, 4.0, pi / 2, "car")
        @test OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car") !=
            OrientedBoundingBoxAnnotation(Point2(1.0, 3.0), 3.0, 4.0, pi / 2, "car")
    end
end
