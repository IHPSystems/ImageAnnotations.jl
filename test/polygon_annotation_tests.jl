using GeometryBasics
using ImageAnnotations

@testset "PolygonAnnotation" begin
    vertices = [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]
    class = "class"
    classification_args = (confidence = Float32(0.7), annotator_name = "annotator")
    annotation = PolygonAnnotation(vertices, class; classification_args...)

    @test centroid(annotation) == [3, 7 / 3]
    bb = bounding_box(annotation)
    @test bb.origin == [2.0, 2.0]
    @test bb.widths == [2.0, 1.0]

    @test_throws ArgumentError PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0)], class; classification_args...)
end
