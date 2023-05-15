using ImageAnnotations
using Test

@testset "ClassificationImageAnnotation" begin
    for TClass in [Int, String]
        class_value = ImageAnnotations.Dummies.create_class(TClass)
        annotation = ClassificationImageAnnotation(class_value)
        @test class(annotation) == class_value
    end

    annotated_image1 = AnnotatedImage([ClassificationImageAnnotation("aeroplane")]; image_file_path = "img1.jpeg")
    @test class(first(annotations(annotated_image1))) == "aeroplane"

    annotated_image2 = AnnotatedImage([ClassificationImageAnnotation(1)]; image_file_path = "img1.jpeg")
    @test class(first(annotations(annotated_image2))) == 1
end
