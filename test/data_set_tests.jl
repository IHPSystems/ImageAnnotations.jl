using ImageAnnotations
using Test

@testset "Data Set" begin
    @testset "Construction of empty set" begin
        empty_data_set = ClassificationImageAnnotationDataSet{Int}()
        @test length(empty_data_set) == 0
    end

    @testset "Equality" begin
        @test ClassificationImageAnnotationDataSet{Int}() == ClassificationImageAnnotationDataSet{Int}()
    end

    @testset "Implements MLUtils data set interface" begin
        @testset "Empty Data Set" begin
            data_set = ClassificationImageAnnotationDataSet(String[], AnnotatedImage[])

            @test length(data_set) == 0
        end

        @testset "Simple VOC-like data set" begin
            class = "aeroplane"
            aeroplane_classification_args = (annotator_name = "alice",)
            annotation1 = BoundingBoxAnnotation(Point2(0.0, 1.0), 2.0, 3.0, class; aeroplane_classification_args...)
            annotation2 = BoundingBoxAnnotation(Point2(0.0, 1.0), 2.0, 4.0, class; aeroplane_classification_args...)
            annotated_image1 = AnnotatedImage(BoundingBoxAnnotation{String, Float64}[]; image_file_path = "img1.jpeg")
            annotated_image2 = AnnotatedImage([annotation1]; image_file_path = "img2.jpeg")
            annotated_image3 = AnnotatedImage([annotation2]; image_file_path = "img3.jpeg")
            data_set = ClassificationImageAnnotationDataSet(["aeroplane"], [annotated_image1, annotated_image2, annotated_image3])

            @test length(data_set) == 3
            @test data_set[1] == annotated_image1
            @test data_set[2] == annotated_image2
            @test data_set[3] == annotated_image3
        end
    end

    @testset "Labels" begin
        @testset "Empty set" begin
            data_set = ClassificationImageAnnotationDataSet{Int}()
            @test get_labels(data_set) == []
        end
        @testset "Single annotation" begin
            label = "aeroplane"
            data_set = ClassificationImageAnnotationDataSet(AnnotatedImage(ClassificationImageAnnotation(label)))
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple annotations" begin
            label = "aeroplane"
            data_set = ClassificationImageAnnotationDataSet(
                AnnotatedImage([ClassificationImageAnnotation(label), ClassificationImageAnnotation(label)])
            )
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple annotated images" begin
            label = "aeroplane"
            data_set = ClassificationImageAnnotationDataSet([
                AnnotatedImage(ClassificationImageAnnotation(label)), AnnotatedImage(ClassificationImageAnnotation(label))
            ])
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple labels" begin
            label1 = "aeroplane"
            label2 = "car"
            data_set = ClassificationImageAnnotationDataSet([
                AnnotatedImage([ClassificationImageAnnotation(label1), ClassificationImageAnnotation(label2)]),
                AnnotatedImage(ClassificationImageAnnotation(label1)),
            ])
            @test get_labels(data_set) == [label1, label2]
        end
        @testset "Single label annotation" begin
            label = Label("aeroplane")
            data_set = ClassificationImageAnnotationDataSet(AnnotatedImage(ClassificationImageAnnotation(label)))
            @test get_labels(data_set) == [label]
        end
    end
end
