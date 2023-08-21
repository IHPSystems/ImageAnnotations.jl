using GeometryBasics
using ImageAnnotations
using Test

@testset "BoundingBoxAnnotation" begin
    @testset "Construction" begin
        type_param_combos = [(L, T) for L in [Int, String], T in [Float32, Float64, Int32, Int64]]
        type_combos(L, T) = (BoundingBoxAnnotation{L, T}, BoundingBoxAnnotation)
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
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, top-left, width, height, and kwargs = $kwargs" begin
                top_left = T.(Point2(0.0, 1.0))
                width = T(3.0)
                height = T(6.0)
                box = TAnnotation(top_left, width, height, label_args...; kwargs...)
                @test box.rect == Rect2(top_left, width, height)
                @test box.annotation == expected_image_annotation
            end
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, top_left, bottom_right, and kwargs = $kwargs" begin
                top_left = T.(Point2(1.0, 2.0))
                bottom_right = T.(Point2(3.0, 4.0))
                box = TAnnotation(top_left, bottom_right, label_args...; kwargs...)
                @test box.rect == Rect2(top_left, 2.0, 2.0)
                @test box.annotation == expected_image_annotation
            end
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, vertices, and kwargs = $kwargs" begin
                vertices = [T.(v) for v in [Point2(0.0, 0.0), Point2(2.0, 0.0), Point2(2.0, 2.0), Point2(0.0, 2.0)]]
                box = TAnnotation(vertices, label_args...; kwargs...)
                @test box.rect == Rect2(Point2(0.0, 0.0), 2.0, 2.0)
                @test box.annotation == expected_image_annotation
            end
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, rect, and kwargs = $kwargs" begin
                origin = T.(Point2(0.0, 0.0))
                width, height = T.((1.0, 1.0))
                rect = Rect2(origin, width, height)
                box = TAnnotation(rect, label_args...; kwargs...)
                @test box.rect == Rect2(Point2(0.0, 0.0), 1.0, 1.0)
                @test box.annotation == expected_image_annotation
            end
            @testset "create_bounding_box_annotation_with_center, with TLabel = $L, TCoordinate = $T, and kwargs = $kwargs" begin
                box = create_bounding_box_annotation_with_center(Point2(3.0, 3.0), 5.0, 3.0, label_args...; kwargs...)
                @test box.rect == Rect2(Point2(0.5, 1.5), 5.0, 3.0)
                @test box.annotation == expected_image_annotation
            end
        end
    end

    @testset "Equality" begin
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") == BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "person")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 3.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 2.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 3.0), 3.0, 4.0, "car")
    end

    @testset "get_centroid" begin
        annotation = BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car")
        @test get_centroid(annotation) == Point2(2.5, 4.0)
    end
end
