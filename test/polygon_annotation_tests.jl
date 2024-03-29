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
            label = ImageAnnotations.Dummies.create_label_1(L)
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

    @testset "Base.isapprox" begin
        linear_atol = 1e-1
        approx(v, eps = 1e-2) = v + linear_atol - eps
        napprox(v, eps = 1e-2) = v + linear_atol + eps
        a = PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, 3.0)], "car")

        b = PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, approx(3.0))], "car")
        c = PolygonAnnotation([Point2(2.0, 2.0), Point2(4.0, 2.0), Point2(3.0, napprox(3.0))], "car")
        @test a ≈ b atol = linear_atol
        @test a ≉ c atol = linear_atol
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

    @testset "simplify_geometry" begin
        angular_atol = 1e-256
        @testset "Rectangles are converted to BoundingBoxAnnotation" begin
            expected_annotation = BoundingBoxAnnotation(Point2(0.0, 0.0), 1.0, 1.0, "car")
            annotation = PolygonAnnotation(get_vertices(expected_annotation), "car")
            @test simplify_geometry(annotation; angular_atol = angular_atol) == expected_annotation
        end
        @testset "Oriented rectangles are converted to OrientedBoundingBoxAnnotation" begin
            annotation = PolygonAnnotation([Point2(0.0, 0.0), Point2(1.0, 1.0), Point2(0.0, 2.0), Point2(-1.0, 1.0)], "car")
            expected_annotation = OrientedBoundingBoxAnnotation(Point2(0.0, 1.0), sqrt(2.0), sqrt(2.0), pi / 4, "car")
            @test simplify_geometry(annotation; angular_atol = angular_atol) ≈ expected_annotation
        end
        for numerator in (-(2 * 8)):(2 * 8)
            theta = numerator * pi / 8
            if mod(theta, pi / 2) == 0.0
                @testset "Oriented rectangles with θ = $(numerator)π / 8 are converted to OrientedBoundingBoxAnnotation" begin
                    oriented_annotation = OrientedBoundingBoxAnnotation(Point2(0.0, 1.0), 2.0, 3.0, theta, "car")
                    expected_annotation = BoundingBoxAnnotation(get_bounding_box(oriented_annotation), "car")
                    annotation = PolygonAnnotation(get_vertices(expected_annotation), "car")
                    @test simplify_geometry(annotation; angular_atol = angular_atol) == expected_annotation
                end
            else
                @testset "Oriented rectangles with θ = $(numerator)π / 8 are converted to OrientedBoundingBoxAnnotation" begin
                    expected_annotation = OrientedBoundingBoxAnnotation(Point2(0.0, 1.0), 2.0, 3.0, theta, "car")
                    annotation = PolygonAnnotation(get_vertices(expected_annotation), "car")
                    @test simplify_geometry(annotation; angular_atol = angular_atol) ≈ expected_annotation orientation_symmetry = true
                end
            end
        end
    end
end
