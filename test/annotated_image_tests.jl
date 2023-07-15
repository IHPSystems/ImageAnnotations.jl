using ImageAnnotations
using Test

@testset "AnnotatedImage" begin
    @testset "Construction with no annotations" begin
        empty_annotated_image = AnnotatedImage{ClassificationImageAnnotation}()
        @test length(annotations(empty_annotated_image)) == 0
    end
    @testset "Construction with single annotation" begin
        annotated_image = AnnotatedImage(ClassificationImageAnnotation(1))
        @test length(annotations(annotated_image)) == 1
    end
    @testset "Construction with multiple annotations" begin
        annotated_image = AnnotatedImage([ClassificationImageAnnotation(1), ClassificationImageAnnotation(2)])
        @test length(annotations(annotated_image)) == 2
    end

    @testset "Equality" begin
        @test AnnotatedImage{ClassificationImageAnnotation}() == AnnotatedImage{ClassificationImageAnnotation}()
        @test AnnotatedImage([ClassificationImageAnnotation(1)]) == AnnotatedImage([ClassificationImageAnnotation(1)])
        @test AnnotatedImage([ClassificationImageAnnotation(1)]) != AnnotatedImage([ClassificationImageAnnotation(2)])
    end
end
