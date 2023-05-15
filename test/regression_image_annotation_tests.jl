using ImageAnnotations
using Test

@testset "RegressionImageAnnotation" begin
    for TValue in [Float32, Float64]
        expected_value = TValue(0.5)
        annotation = RegressionImageAnnotation(expected_value)
        @test value(annotation) == expected_value
    end

    annotated_image1 = AnnotatedImage([RegressionImageAnnotation(0.5)]; image_file_path = "img1.jpeg")
    @test value(first(annotations(annotated_image1))) == 0.5

    annotated_image2 = AnnotatedImage([RegressionImageAnnotation(0.5f0)]; image_file_path = "img1.jpeg")
    @test value(first(annotations(annotated_image2))) == 0.5f0
end
