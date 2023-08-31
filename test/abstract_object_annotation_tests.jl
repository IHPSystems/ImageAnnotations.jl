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
        @testset "Annotations are sorted by type name, then bounding box, then image annotation" begin
            a = BoundingBoxAnnotation(Point2(0, 0), 1, 1, "aeroplane")
            b = BoundingBoxAnnotation(Point2(0, 0), 1, 2, "aeroplane")
            c = BoundingBoxAnnotation(Point2(0, 0), 2, 1, "aeroplane")
            d = BoundingBoxAnnotation(Point2(0, 1), 1, 1, "aeroplane")
            e = BoundingBoxAnnotation(Point2(1, 0), 1, 1, "aeroplane")
            f = BoundingBoxAnnotation(Point2(1, 0), 1, 1, "car")
            g = PolygonAnnotation(Point2.(coordinates(get_bounding_box(a))), "aeroplane")
            h = PolygonAnnotation(Point2.(coordinates(get_bounding_box(b))), "aeroplane")
            i = PolygonAnnotation(Point2.(coordinates(get_bounding_box(c))), "aeroplane")
            j = PolygonAnnotation(Point2.(coordinates(get_bounding_box(d))), "aeroplane")
            k = PolygonAnnotation(Point2.(coordinates(get_bounding_box(e))), "aeroplane")
            l = PolygonAnnotation(Point2.(coordinates(get_bounding_box(f))), "car")
            annotations = [a b c d e f g h i j k l]
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
