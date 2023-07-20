using ImageAnnotations
using Test

@testset "AnnotatedImage" begin
    @testset "Construction with no annotations" begin
        empty_annotated_image = AnnotatedImage()
        @test get_annotations(empty_annotated_image) == []
    end
    @testset "Construction with single annotation" begin
        annotated_image = AnnotatedImage(ImageAnnotation(1))
        @test length(get_annotations(annotated_image)) == 1
    end
    @testset "Construction with multiple annotations" begin
        annotated_image = AnnotatedImage([ImageAnnotation(1), ImageAnnotation(2)])
        @test length(get_annotations(annotated_image)) == 2
    end
    @testset "Construction with a mix of annotation types" begin
        annotated_image = AnnotatedImage([ImageAnnotation(1), BoundingBoxAnnotation(Point2(0.0, 1.0), 2.0, 3.0, "class")])
        @test length(get_annotations(annotated_image)) == 2
    end

    @testset "Equality" begin
        @test AnnotatedImage() == AnnotatedImage()
        @test AnnotatedImage([ImageAnnotation(1)]) == AnnotatedImage([ImageAnnotation(1)])
        @test AnnotatedImage([ImageAnnotation(1)]) != AnnotatedImage([ImageAnnotation(2)])
    end
end
