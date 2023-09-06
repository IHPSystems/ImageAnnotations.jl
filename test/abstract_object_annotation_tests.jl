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
            g = PolygonAnnotation(get_vertices(a), "aeroplane")
            h = PolygonAnnotation(get_vertices(b), "aeroplane")
            i = PolygonAnnotation(get_vertices(c), "aeroplane")
            j = PolygonAnnotation(get_vertices(d), "aeroplane")
            k = PolygonAnnotation(get_vertices(e), "aeroplane")
            l = PolygonAnnotation(get_vertices(f), "car")
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
