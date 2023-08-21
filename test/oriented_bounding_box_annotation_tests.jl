using GeometryBasics
using ImageAnnotations

@testset "OrientedBoundingBoxAnnotationTests" begin
    @testset "Construction" begin
        type_param_combos = [(L, T) for L in [Int, String], T in [Float32, Float64]]
        type_combos(L, T) = (OrientedBoundingBoxAnnotation{L, T}, OrientedBoundingBoxAnnotation)
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
            @testset "$(TAnnotation) with TLabel = $L, TCoordinate = $T, center, width, height, orientation, and kwargs = $kwargs" begin
                center = T.(Point2(3.0, 3.0))
                width = T(4.0)
                height = T(2.0)
                orientation = T(pi / 2)
                annotation = TAnnotation(center, width, height, orientation, label_args...; kwargs...)
                @test annotation.center == center
                @test annotation.width == width
                @test annotation.height == height
                @test annotation.orientation ≈ orientation atol = 1.0e-7
                @test annotation.annotation == expected_image_annotation
            end
        end
    end

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

    @testset "get_bounding_box" begin
        annotation = OrientedBoundingBoxAnnotation(Point2(3.0, 3.0), 4.0, 2.0, pi / 2, "car")
        rect = get_bounding_box(annotation)
        error_margin = 1.0e-5
        origin_diff = rect.origin - Point2(2.0, 1.0)
        @test abs(origin_diff.data[1]) < error_margin && abs(origin_diff.data[2]) < error_margin
        widths_diff = rect.widths - Point2(2.0, 4.0)
        @test abs(widths_diff.data[1]) < error_margin && abs(widths_diff.data[2]) < error_margin
    end
end
