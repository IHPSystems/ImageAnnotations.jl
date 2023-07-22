using GeometryBasics
using ImageAnnotations
using Test

@testset "AbstractObjectAnnotation" begin
    @testset "Base.isless" begin
        @testset "Annotations that are equal are not less than each other" begin
            a = BoundingBoxAnnotation(Point2(0, 0), 1, 1, "car")
            b = BoundingBoxAnnotation(Point2(0, 0), 1, 1, "car")
            @test !isless(a, b)
            @test !isless(b, a)
        end
        @testset "Annotations are sorted by their type name" begin
            a = PolygonAnnotation([Point2(0, 0), Point2(1, 0), Point2(1, 1), Point(0, 1)], "car")
            b = BoundingBoxAnnotation(a)
            @test isless(b, a)
        end
        @testset "Annotations of the same type are sorted by their bounding box" begin
            a = BoundingBoxAnnotation(Point2(0, 0), 1, 1, "car")
            b = BoundingBoxAnnotation(Point2(1, 0), 1, 1, "car")
            c = BoundingBoxAnnotation(Point2(0, 1), 1, 1, "car")
            d = BoundingBoxAnnotation(Point2(0, 0), 2, 1, "car")
            e = BoundingBoxAnnotation(Point2(0, 0), 1, 2, "car")
            @test isless(a, b)
            @test isless(a, c)
            @test isless(a, d)
            @test isless(a, e)
        end
    end
end
