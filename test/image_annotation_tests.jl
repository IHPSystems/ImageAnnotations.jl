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
end
