using GeometryBasics
using ImageAnnotations
using Test

@testset "AbstractImageAnnotation" begin
    @testset "Base.isless" begin
        @testset "Annotations are sorted by their type name" begin
            a = BoundingBoxAnnotation(Point2(0, 1), 2, 3, "car")
            b = ImageAnnotation("car")
            @test isless(a, b)
            @test !isless(b, a)
        end
    end
end
