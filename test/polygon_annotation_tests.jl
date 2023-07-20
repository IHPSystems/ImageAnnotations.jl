using GeometryBasics
using ImageAnnotations

@testset "PolygonAnnotation" begin
    @testset "Construction" begin
        vertices = [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]
        label = "class"
        annotation_args = (confidence = Float32(0.7), annotator_name = "annotator")
        annotation = PolygonAnnotation(vertices, label; annotation_args...)

        @test get_centroid(annotation) == [3, 7 / 3]
        bb = get_bounding_box(annotation)
        @test bb.origin == [2.0, 2.0]
        @test bb.widths == [2.0, 1.0]

        @test_throws ArgumentError PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0)], label; annotation_args...)
    end

    @testset "Equality" begin
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") ==
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car")
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") !=
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "person")
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") !=
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 4.0)], "car")
    end
end
