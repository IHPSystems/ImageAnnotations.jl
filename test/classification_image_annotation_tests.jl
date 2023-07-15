using ImageAnnotations
using Test

@testset "ClassificationImageAnnotation" begin
    @testset "Accessors" begin
        for TClass in [Int, String], conf in [nothing, 0.5f0], name in [nothing, "annotator"]
            class_value = ImageAnnotations.Dummies.create_class(TClass)
            annotation = ClassificationImageAnnotation(class_value; confidence = conf, annotator_name = name)
            @test class(annotation) == class_value
            @test confidence(annotation) == conf
            @test annotator_name(annotation) == name
        end
    end

    @testset "Equality" begin
        @test ClassificationImageAnnotation(1) == ClassificationImageAnnotation(1)
        @test ClassificationImageAnnotation(1) != ClassificationImageAnnotation(2)
        @test ClassificationImageAnnotation(1) != ClassificationImageAnnotation("1")
    end
end
