using ImageAnnotations
using Test

@testset "RegressionImageAnnotation" begin
    @testset "Accessors" begin
        for TValue in [Float32, Float64], conf in [nothing, 0.5f0], name in [nothing, "annotator"]
            expected_value = TValue(0.5)
            annotation = RegressionImageAnnotation(expected_value; confidence = conf, annotator_name = name)
            @test value(annotation) == expected_value
            @test confidence(annotation) == conf
            @test annotator_name(annotation) == name
        end
    end

    @testset "Equality" begin
        @test RegressionImageAnnotation(0.5) == RegressionImageAnnotation(0.5)
        @test RegressionImageAnnotation(0.5) == RegressionImageAnnotation(0.5f0)
        @test RegressionImageAnnotation(0.5) != RegressionImageAnnotation(0.6)
    end
end
