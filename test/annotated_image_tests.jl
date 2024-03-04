using ImageAnnotations
using Test

@testset "AnnotatedImage" begin
    @testset "Construction with no annotations" begin
        empty_annotated_image = AnnotatedImage()
        @test get_annotations(empty_annotated_image) == []
    end
    @testset "Construction with single annotation" begin
        annotation = ImageAnnotations.Dummies.create_image_annotation_1()
        annotated_image = AnnotatedImage(annotation)
        @test length(get_annotations(annotated_image)) == 1
    end
    @testset "Construction with multiple annotations" begin
        annotations = [ImageAnnotations.Dummies.create_image_annotation_1(), ImageAnnotations.Dummies.create_image_annotation_2()]
        annotated_image = AnnotatedImage(annotations)
        @test length(get_annotations(annotated_image)) == 2
    end
    @testset "Construction with a mix of annotation types" begin
        annotations = [ImageAnnotations.Dummies.create_image_annotation_1(), ImageAnnotations.Dummies.create_bounding_box_annotation_1()]
        annotated_image = AnnotatedImage(annotations)
        @test length(get_annotations(annotated_image)) == 2
    end

    @testset "Equality" begin
        @test AnnotatedImage() == AnnotatedImage()
        @test AnnotatedImage([ImageAnnotation(1)]) == AnnotatedImage([ImageAnnotation(1)])
        @test AnnotatedImage([ImageAnnotation(1)]) != AnnotatedImage([ImageAnnotation(2)])
    end
end
