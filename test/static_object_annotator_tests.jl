using GeometryBasics
using ImageAnnotations
using Test

@testset "StaticObjectAnnotator" begin
    vertices = [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]
    label = "class"
    annotation_args = (confidence = Float32(0.7), annotator_name = "annotator")
    annotation = PolygonAnnotation(vertices, label; annotation_args...)
    annotator = StaticObjectAnnotator([annotation])
    img = Array{UInt8}(undef, 10, 10, 3)
    annotations = annotate(img, annotator)

    @test length(annotations) == 1
    @test get_label(annotations[1]) == "class"
    @test get_confidence(annotations[1]) == 0.7f0
    @test get_centroid(annotations[1]) == [3, 7 / 3]
end
