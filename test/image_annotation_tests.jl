using ImageAnnotations
using Test

@testset "ImageAnnotation" begin
    @testset "Accessors" begin
        for TLabel in [Int, Float64, String], confidence in [nothing, 0.5f0], annotator_name in [nothing, "annotator"]
            label = ImageAnnotations.Dummies.create_label(TLabel)
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
end
