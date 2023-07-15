using GeometryBasics
using ImageAnnotations
using Test

@testset "BoundingBoxAnnotation" begin
    @testset "Construction / Centroid" begin
        for TClass in [Int, String]
            for TCoordinate in [Float32, Float64, Int32, Int64]
                class = ImageAnnotations.Dummies.create_class(TClass)
                confidence = Float32(0.7)
                annotator_name = "annotator"
                for kwargs in [NamedTuple(), (confidence = confidence,), (confidence = confidence, annotator_name = annotator_name)]
                    @testset "Construction with top-left, width, height, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        top_left = TCoordinate.(Point2(0.0, 1.0))
                        width = TCoordinate(3.0)
                        height = TCoordinate(6.0)
                        box = BoundingBoxAnnotation(top_left, width, height, class; kwargs...)
                        @test centroid(box) == [1.5, 4.0]
                    end
                    @testset "Construction with top_left, bottom_right, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        top_left = TCoordinate.(Point2(1.0, 2.0))
                        bottom_right = TCoordinate.(Point2(3.0, 4.0))
                        box = BoundingBoxAnnotation(top_left, bottom_right, class; kwargs...)
                        @test centroid(box) == [2.0, 3.0]
                    end

                    @testset "Construction with vertices, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        vertices = [Point2(0.0, 0.0), Point2(2.0, 0.0), Point2(2.0, 2.0), Point2(0.0, 2.0)]
                        vertices = [TCoordinate.(v) for v in vertices]
                        box = BoundingBoxAnnotation(vertices, class; kwargs...)
                        @test centroid(box) == [1.0, 1.0]
                    end

                    @testset "Construction with rect, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        origin = TCoordinate.(Point2(0.0, 0.0))
                        width, height = TCoordinate.((1.0, 1.0))
                        rect = Rect2(origin, width, height)
                        box = BoundingBoxAnnotation(rect, class; kwargs...)
                        @test centroid(box) == [0.5, 0.5]
                    end

                    @testset "bounding_box_annotation_with_center, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        box = bounding_box_annotation_with_center(Point2(3.0, 3.0), 5.0, 3.0, class; kwargs...)
                        @test centroid(box) == [3.0, 3.0]
                    end
                end
            end
        end
    end

    @testset "Equality" begin
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") == BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "person")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 3.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 2.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 3.0), 3.0, 4.0, "car")
    end
end
