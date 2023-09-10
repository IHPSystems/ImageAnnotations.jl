using GeometryBasics
using ImageAnnotations
using Test

@testset "PolygonAnnotation" begin
    @testset "Construction" begin
        type_param_combos = [(L, T) for L in [Int, String], T in [Float32, Float64, Int32, Int64]]
        type_combos(L, T) = (PolygonAnnotation{L, T}, PolygonAnnotation)
        label_arg_combos(L) = (ImageAnnotation{L}, L)
        confidence = Float32(0.7)
        annotator_name = "annotator"
        kwarg_combos = [NamedTuple(), (confidence = confidence,), (confidence = confidence, annotator_name = annotator_name)]
        for (L, T) in type_param_combos, TAnnotation in type_combos(L, T), TLabelArg in label_arg_combos(L), kwargs in kwarg_combos
            label = ImageAnnotations.Dummies.create_label(L)
            if TLabelArg == ImageAnnotation{L}
                label_args = (ImageAnnotation(label; kwargs...),)
                kwargs = NamedTuple()
                expected_image_annotation = label_args[1]
            elseif TLabelArg == L
                label_args = (label,)
                expected_image_annotation = ImageAnnotation(label; kwargs...)
            end
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, and kwargs = $kwargs" begin
                vertices = [T.(v) for v in [Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)]]
                expected_vertices = deepcopy(vertices)
                annotation = TAnnotation(vertices, label_args...; kwargs...)
                @test annotation.vertices == expected_vertices
                @test annotation.annotation == expected_image_annotation
            end
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, and kwargs = $kwargs throws with 2 vertices" begin
                @test_throws ArgumentError PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0)], label_args...; kwargs...)
            end
        end
    end

    @testset "Equality" begin
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") ==
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car")
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") !=
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "person")
        @test PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car") !=
            PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 4.0)], "car")
    end

    @testset "get_bounding_box" begin
        annotation = PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car")
        rect = get_bounding_box(annotation)
        @test rect.origin == [2.0, 2.0]
        @test rect.widths == [2.0, 1.0]
    end

    @testset "get_centroid" begin
        annotation = PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car")
        @test get_centroid(annotation) == [3, 7 / 3]
    end
end
