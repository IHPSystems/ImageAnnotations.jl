using GeometryBasics
using ImageAnnotations
using Test

@testset "AbstractImageAnnotation" begin
    @testset "Base.isless" begin
        @testset "Annotations are sorted by type name, then label, then confidence, then annotator_name" begin
            a = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "aeroplane")
            b = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car")
            c = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; annotator_name = "alice")
            d = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; annotator_name = "bob")
            e = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; confidence = 0.0f0)
            f = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; confidence = 0.1f0)
            g = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; confidence = 0.1f0, annotator_name = "alice")
            h = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car"; confidence = 0.1f0, annotator_name = "bob")
            i = ImageAnnotation("car")
            annotations = [a b c d e f g h i]
            for (idx1, x) in enumerate(annotations), (idx2, y) in enumerate(annotations)
                if idx1 >= idx2
                    continue
                end
                x_sym = Char(96 + idx1)
                y_sym = Char(96 + idx2)
                @testset "$x_sym < $y_sym and !($y_sym < $x_sym)" begin
                    @test isless(x, y)
                    @test !isless(y, x)
                end
            end
        end
    end
end
