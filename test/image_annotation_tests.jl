using ImageAnnotations
using Test

@testset "ImageAnnotation" begin
    @testset "Construction" begin
        type_param_combos = [Int, Float64, String]
        type_combos(L) = [ImageAnnotation{L}, ImageAnnotation]
        kwarg_combos = [(confidence = c, annotator_name = n) for c in [nothing, 0.5f0], n in [nothing, "annotator"]]
        for TLabel in type_param_combos, TImageAnnotation in type_combos(TLabel), kwargs in kwarg_combos
            label = ImageAnnotations.Dummies.create_label_1(TLabel)
            annotation = TImageAnnotation(label; kwargs...)
            @test annotation.label == label
            @test annotation.confidence == kwargs.confidence
            @test annotation.annotator_name == kwargs.annotator_name
        end
    end

    @testset "Accessors" begin
        for TLabel in [Int, Float64, String], confidence in [nothing, 0.5f0], annotator_name in [nothing, "annotator"]
            label = ImageAnnotations.Dummies.create_label_1(TLabel)
            annotation = ImageAnnotation(label; confidence = confidence, annotator_name = annotator_name)
            @test get_label(annotation) == label
            @test get_confidence(annotation) == confidence
            @test get_annotator_name(annotation) == annotator_name
        end
    end

    @testset "Mutability" begin
        annotation = ImageAnnotation(1)
        annotation.label = 2
        @test annotation.label == 2
    end

    @testset "Equality" begin
        @test ImageAnnotation(1) == ImageAnnotation(1)
        @test ImageAnnotation(1) != ImageAnnotation(2)
        @test ImageAnnotation(1) != ImageAnnotation("1")
    end

    @testset "Base.isless" begin
        @testset "Annotations that are equal are not less than each other" begin
            a = ImageAnnotation(1; confidence = 0.5f0, annotator_name = "annotator")
            b = ImageAnnotation(1; confidence = 0.5f0, annotator_name = "annotator")
            @test !isless(a, b)
            @test !isless(b, a)
        end
        @testset "Annotations are sorted by label, then confidence, then annotator_name" begin
            a = ImageAnnotation(1)
            b = ImageAnnotation(1; annotator_name = "annotator")
            c = ImageAnnotation(1; confidence = 0.5f0)
            d = ImageAnnotation(1; confidence = 0.5f0, annotator_name = "annotator")
            e = ImageAnnotation(1; confidence = 0.5f0, annotator_name = "annotator2")
            f = ImageAnnotation(1; confidence = 0.6f0, annotator_name = "annotator")
            g = ImageAnnotation(2; confidence = 0.5f0, annotator_name = "annotator")
            @test isless(a, b)
            @test isless(a, c)
            @test isless(a, d)
            @test isless(a, e)
            @test isless(a, f)
            @test isless(a, g)
            @test isless(b, c)
            @test isless(b, d)
            @test isless(b, e)
            @test isless(b, f)
            @test isless(b, g)
            @test isless(c, d)
            @test isless(c, e)
            @test isless(c, f)
            @test isless(c, g)
            @test isless(d, e)
            @test isless(d, f)
            @test isless(d, g)
            @test isless(e, f)
            @test isless(e, g)
            @test isless(f, g)
        end
    end

    @testset "Base.isapprox" begin
        for TLabel in [Int, Float64, String]
            a_label = ImageAnnotations.Dummies.create_label_1(TLabel)
            if TLabel <: AbstractFloat
                @testset "Annotations of $TLabel isapprox if label isapprox" begin
                    label_atol = eps(TLabel)
                    b_label = a_label + label_atol - eps(TLabel)
                    c_label = a_label + label_atol + eps(TLabel)
                    @assert isapprox(a_label, b_label; atol = label_atol)
                    @assert !isapprox(a_label, c_label; atol = label_atol)

                    a = ImageAnnotation(a_label)
                    b = ImageAnnotation(b_label)
                    c = ImageAnnotation(c_label)
                    @test a ≈ b atol = label_atol
                    @test a ≉ c atol = label_atol
                end
            else
                @testset "Annotations of $TLabel isapprox if label isequal" begin
                    label_atol = 0
                    b_label = ImageAnnotations.Dummies.create_label_1(TLabel)
                    a = ImageAnnotation(a_label)
                    b = ImageAnnotation(b_label)
                    @test a ≈ b atol = label_atol
                end
            end
        end
    end
end
