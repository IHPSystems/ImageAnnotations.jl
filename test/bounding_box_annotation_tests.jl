using GeometryBasics
using ImageAnnotations
using Test

@testset "BoundingBoxAnnotation" begin
    @testset "Construction / Centroid" begin
        for TLabel in [Int, String]
            for TCoordinate in [Float32, Float64, Int32, Int64]
                label = ImageAnnotations.Dummies.create_label(TLabel)
                confidence = Float32(0.7)
                annotator_name = "annotator"
                for kwargs in [NamedTuple(), (confidence = confidence,), (confidence = confidence, annotator_name = annotator_name)]
                    @testset "Construction with top-left, width, height, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        top_left = TCoordinate.(Point2(0.0, 1.0))
                        width = TCoordinate(3.0)
                        height = TCoordinate(6.0)
                        box = BoundingBoxAnnotation(top_left, width, height, label; kwargs...)
                        @test get_centroid(box) == [1.5, 4.0]
                    end
                    @testset "Construction with top_left, bottom_right, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        top_left = TCoordinate.(Point2(1.0, 2.0))
                        bottom_right = TCoordinate.(Point2(3.0, 4.0))
                        box = BoundingBoxAnnotation(top_left, bottom_right, label; kwargs...)
                        @test get_centroid(box) == [2.0, 3.0]
                    end

                    @testset "Construction with vertices, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        vertices = [Point2(0.0, 0.0), Point2(2.0, 0.0), Point2(2.0, 2.0), Point2(0.0, 2.0)]
                        vertices = [TCoordinate.(v) for v in vertices]
                        box = BoundingBoxAnnotation(vertices, label; kwargs...)
                        @test get_centroid(box) == [1.0, 1.0]
                    end

                    @testset "Construction with rect, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        origin = TCoordinate.(Point2(0.0, 0.0))
                        width, height = TCoordinate.((1.0, 1.0))
                        rect = Rect2(origin, width, height)
                        box = BoundingBoxAnnotation(rect, label; kwargs...)
                        @test get_centroid(box) == [0.5, 0.5]
                    end

                    @testset "create_bounding_box_annotation_with_center, TCoordinate = $TCoordinate, and kwargs = $kwargs" begin
                        box = create_bounding_box_annotation_with_center(Point2(3.0, 3.0), 5.0, 3.0, label; kwargs...)
                        @test get_centroid(box) == [3.0, 3.0]
                    end
                end
            end
        end
    end

    @testset "Mutability" begin
        annotation = BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car")
        annotation.rect = Rect2(Point2(2.0, 3.0), 4.0, 5.0)
        annotation.annotation = ImageAnnotation("person")
        @test annotation.rect == Rect2(Point2(2.0, 3.0), 4.0, 5.0)
        @test annotation.annotation == ImageAnnotation("person")
    end

    @testset "Equality" begin
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") == BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "person")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 3.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 2.0), 2.0, 4.0, "car")
        @test BoundingBoxAnnotation(Point2(1.0, 2.0), 3.0, 4.0, "car") != BoundingBoxAnnotation(Point2(1.0, 3.0), 3.0, 4.0, "car")
    end
end
