using GeometryBasics
using ImageAnnotations
using Test

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

    @testset "Base.isapprox" begin
        linear_atol = 1e-1
        approx(v, atol = linear_atol, eps = 1e-2) = v + atol - eps
        napprox(v, atol = linear_atol, eps = 1e-2) = v + atol + eps
        a = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2, "car")

        b = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, approx(pi / 2, pi / 64, pi / 128), "car")
        c = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, napprox(pi / 2, pi / 64, pi / 128), "car")
        d = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2 - 2pi, "car")
        e = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2 - pi, "car")
        f = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2 + pi, "car")
        g = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, pi / 2 + 2pi, "car")
        @test a ≈ b atol = pi / 64
        @test a ≉ c atol = pi / 64
        @test a ≈ d orientation_symmetry = true
        @test a ≈ e orientation_symmetry = true
        @test a ≈ f orientation_symmetry = true
        @test a ≈ g orientation_symmetry = true

        b = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, approx(4.0), pi / 2, "car")
        c = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, napprox(4.0), pi / 2, "car")
        @test a ≈ b atol = linear_atol
        @test a ≉ c atol = linear_atol

        b = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), approx(3.0), 4.0, pi / 2, "car")
        c = OrientedBoundingBoxAnnotation(Point2(1.0, 2.0), napprox(3.0), 4.0, pi / 2, "car")
        @test a ≈ b atol = linear_atol
        @test a ≉ c atol = linear_atol

        b = OrientedBoundingBoxAnnotation(Point2(1.0, approx(2.0)), 3.0, 4.0, pi / 2, "car")
        c = OrientedBoundingBoxAnnotation(Point2(1.0, napprox(2.0)), 3.0, 4.0, pi / 2, "car")
        @test a ≈ b atol = linear_atol
        @test a ≉ c atol = linear_atol
    end

    @testset "get_bounding_box" begin
        annotation = OrientedBoundingBoxAnnotation(Point2(3.0, 3.0), 4.0, 2.0, pi / 2, "car")
        expected_rect = Rect2(Point2(2.0, 1.0), 2.0, 4.0)

        rect = get_bounding_box(annotation)
        @test rect.origin ≈ expected_rect.origin atol = 1.0e-5
        @test rect.widths ≈ expected_rect.widths atol = 1.0e-5
    end

    @testset "get_vertices" begin
        annotation = OrientedBoundingBoxAnnotation(Point2(3.0, 3.0), 4.0, 2.0, pi / 2, "car")
        expected_vertices = [Point2(4.0, 1.0), Point2(4.0, 5.0), Point2(2.0, 5.0), Point2(2.0, 1.0)]

        vertices = get_vertices(annotation)
        @test length(vertices) == length(expected_vertices)
        for (vertex, expected_vertex) in zip(vertices, expected_vertices)
            @test vertex ≈ expected_vertex atol = 1.0e-5
        end
    end
end
