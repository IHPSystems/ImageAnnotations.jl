using ImageAnnotations
using Test

const Dummies = ImageAnnotations.Dummies

@testset "Dummies" begin
    @testset "create_classes" begin
        classes = ["person", "bicycle", "car"]
        @test Dummies.create_classes_1(String) == classes
        @test Dummies.create_classes_1(Label{String}) == Label.(classes)
        @test Dummies.create_classes_1() == classes
    end

    @testset "create_label" begin
        for L in [Int, Float64, Float32]
            @test Dummies.create_label_1(L) == L(1)
            @test Dummies.create_label_2(L) == L(2)
            @test Dummies.create_label_3(L) == L(3)
        end
        for L in [String, Label{String}]
            @test Dummies.create_label_1(L) == L(Dummies.create_classes_1()[1])
            @test Dummies.create_label_2(L) == L(Dummies.create_classes_1()[2])
            @test Dummies.create_label_3(L) == L(Dummies.create_classes_1()[3])
        end
    end

    for L in [Int, Float64, Float32, String, Label{String}]
        @testset "ImageAnnotation{$L}" begin
            @test Dummies.create_image_annotation_1(L) == ImageAnnotation(Dummies.create_label_1(L))
            @test Dummies.create_image_annotation_2(L) == ImageAnnotation(Dummies.create_label_2(L))
            @test Dummies.create_image_annotation_3(L) == ImageAnnotation(Dummies.create_label_3(L); confidence = 0.6f0)

            @test Dummies.create_annotated_image_1(L) == AnnotatedImage(
                Dummies.create_image_annotation_1(L);
                image_file_path = joinpath("images", "image1.jpeg"),
                image_height = 9,
                image_width = 16,
            )

            @test Dummies.create_annotated_image_2(L) == AnnotatedImage(
                sort([Dummies.create_image_annotation_1(L), Dummies.create_image_annotation_2(L)]);
                image_file_path = joinpath("images", "image2.jpeg"),
                image_height = 9,
                image_width = 16,
            )

            @test Dummies.create_image_annotation_dataset_1(L) ==
                ImageAnnotationDataSet(Dummies.create_classes_1(L), [Dummies.create_annotated_image_1(L)])
            @test Dummies.create_image_annotation_dataset_2(L) ==
                ImageAnnotationDataSet(Dummies.create_classes_1(L), [Dummies.create_annotated_image_2(L)])
        end
    end

    @testset "AbstractObjectAnnotation" begin
        for L in [Int, Float64, Float32, String, Label{String}]
            for T in [Float64, Float32]
                @testset "BoundingBoxAnnotation{$L, $T}" begin
                    @test Dummies.create_bounding_box_annotation_1(L, T) ==
                        BoundingBoxAnnotation(Point2(T(0), T(0)), T(1), T(1), Dummies.create_label_1(L))
                    @test Dummies.create_bounding_box_annotation_2(L, T) ==
                        BoundingBoxAnnotation(Point2(T(0), T(1)), T(2), T(3), Dummies.create_label_2(L))
                    @test Dummies.create_bounding_box_annotation_3(L, T) ==
                        BoundingBoxAnnotation(Point2(T(0), T(1)), T(2), T(3), Dummies.create_label_3(L); confidence = 0.6f0)
                end
                @testset "OrientedBoundingBoxAnnotation{$L, $T}" begin
                    @test Dummies.create_oriented_bounding_box_annotation_1(L, T) ==
                        OrientedBoundingBoxAnnotation(Point2(T(0), T(0)), T(1), T(1), T(0), Dummies.create_label_1(L))
                    @test Dummies.create_oriented_bounding_box_annotation_2(L, T) ==
                        OrientedBoundingBoxAnnotation(Point2(T(0), T(1)), T(2), T(3), T(pi / 2), Dummies.create_label_2(L))
                    @test Dummies.create_oriented_bounding_box_annotation_3(L, T) == OrientedBoundingBoxAnnotation(
                        Point2(T(0), T(1)), T(2), T(3), T(pi / 2), Dummies.create_label_3(L); confidence = 0.6f0
                    )
                end
                @testset "PolygonAnnotation{$L, $T}" begin
                    @test Dummies.create_polygon_annotation_1(L, T) ==
                        PolygonAnnotation([Point2(T(0), T(0)), Point2(T(1), T(0)), Point2(T(1), T(1))], Dummies.create_label_1(L))
                    @test Dummies.create_polygon_annotation_2(L, T) ==
                        PolygonAnnotation([Point2(T(0), T(1)), Point2(T(2), T(3)), Point2(T(4), T(5))], Dummies.create_label_2(L))
                    @test Dummies.create_polygon_annotation_3(L, T) == PolygonAnnotation(
                        [Point2(T(0), T(1)), Point2(T(2), T(3)), Point2(T(4), T(5))], Dummies.create_label_3(L); confidence = 0.6f0
                    )
                end
                @testset "AnnotatedImage" begin
                    @test Dummies.create_annotated_image_3(L, T) == AnnotatedImage(
                        sort([
                            Dummies.create_image_annotation_1(L),
                            Dummies.create_image_annotation_2(L),
                            Dummies.create_bounding_box_annotation_1(L, T),
                            Dummies.create_bounding_box_annotation_2(L, T),
                            Dummies.create_oriented_bounding_box_annotation_1(L, T),
                            Dummies.create_oriented_bounding_box_annotation_2(L, T),
                            Dummies.create_polygon_annotation_1(L, T),
                            Dummies.create_polygon_annotation_2(L, T),
                        ]);
                        image_file_path = joinpath("images", "image3.jpeg"),
                        image_height = 9,
                        image_width = 16,
                    )
                    @test Dummies.create_annotated_image_4(L, T) == AnnotatedImage(
                        sort([
                            Dummies.create_image_annotation_3(L),
                            Dummies.create_bounding_box_annotation_3(L, T),
                            Dummies.create_oriented_bounding_box_annotation_3(L, T),
                            Dummies.create_polygon_annotation_3(L, T),
                        ]);
                        image_file_path = joinpath("images", "image4.jpeg"),
                        image_height = 9,
                        image_width = 16,
                    )
                end
                @testset "ImageAnnotationDataSet" begin
                    @test Dummies.create_image_annotation_dataset_3(L, T) ==
                        ImageAnnotationDataSet(Dummies.create_classes_1(L), [Dummies.create_annotated_image_3(L, T)])
                    @test Dummies.create_image_annotation_dataset_4(L, T) ==
                        ImageAnnotationDataSet(Dummies.create_classes_1(L), [Dummies.create_annotated_image_4(L, T)])
                end
            end
        end
    end

    @testset "Convenience methods" begin
        @test Dummies.create_label_1() == Dummies.create_label_1(String)
        @test Dummies.create_label_2() == Dummies.create_label_2(String)
        @test Dummies.create_label_3() == Dummies.create_label_3(String)

        @test Dummies.create_image_annotation_1() == Dummies.create_image_annotation_1(String)
        @test Dummies.create_image_annotation_2() == Dummies.create_image_annotation_2(String)
        @test Dummies.create_image_annotation_3() == Dummies.create_image_annotation_3(String)

        @test Dummies.create_bounding_box_annotation_1() == Dummies.create_bounding_box_annotation_1(String, Float64)
        @test Dummies.create_bounding_box_annotation_2() == Dummies.create_bounding_box_annotation_2(String, Float64)
        @test Dummies.create_bounding_box_annotation_3() == Dummies.create_bounding_box_annotation_3(String, Float64)

        @test Dummies.create_oriented_bounding_box_annotation_1() == Dummies.create_oriented_bounding_box_annotation_1(String, Float64)
        @test Dummies.create_oriented_bounding_box_annotation_2() == Dummies.create_oriented_bounding_box_annotation_2(String, Float64)
        @test Dummies.create_oriented_bounding_box_annotation_3() == Dummies.create_oriented_bounding_box_annotation_3(String, Float64)

        @test Dummies.create_polygon_annotation_1() == Dummies.create_polygon_annotation_1(String, Float64)
        @test Dummies.create_polygon_annotation_2() == Dummies.create_polygon_annotation_2(String, Float64)
        @test Dummies.create_polygon_annotation_3() == Dummies.create_polygon_annotation_3(String, Float64)

        @test Dummies.create_annotated_image_0() ==
            AnnotatedImage(; image_file_path = joinpath("images", "image0.jpeg"), image_height = 9, image_width = 16)
        @test Dummies.create_annotated_image_1() == Dummies.create_annotated_image_1(String)
        @test Dummies.create_annotated_image_2() == Dummies.create_annotated_image_2(String)
        @test Dummies.create_annotated_image_3() == Dummies.create_annotated_image_3(String, Float64)
        @test Dummies.create_annotated_image_4() == Dummies.create_annotated_image_4(String, Float64)

        @test Dummies.create_image_annotation_dataset_0() == ImageAnnotationDataSet(Dummies.create_classes_1(), AnnotatedImage[])
        @test Dummies.create_image_annotation_dataset_1() == Dummies.create_image_annotation_dataset_1(String)
        @test Dummies.create_image_annotation_dataset_2() == Dummies.create_image_annotation_dataset_2(String)
        @test Dummies.create_image_annotation_dataset_3() == Dummies.create_image_annotation_dataset_3(String, Float64)
        @test Dummies.create_image_annotation_dataset_4() == Dummies.create_image_annotation_dataset_4(String, Float64)
    end
end
