using ImageAnnotations
using Test

@testset "Data Set" begin
    @testset "Construction of empty set" begin
        empty_data_set = ImageAnnotationDataSet{Int}()
        @test length(empty_data_set) == 0
    end

    @testset "Equality" begin
        @test ImageAnnotationDataSet{Int}() == ImageAnnotationDataSet{Int}()
    end

    @testset "Implements MLUtils data set interface" begin
        @testset "Empty Data Set" begin
            data_set = ImageAnnotationDataSet(String[], AnnotatedImage[])

            @test length(data_set) == 0
        end

        @testset "Non-empty data set" begin
            annotated_image1 = ImageAnnotations.Dummies.create_annotated_image_1()
            annotated_image2 = ImageAnnotations.Dummies.create_annotated_image_2()
            annotated_image3 = ImageAnnotations.Dummies.create_annotated_image_3()
            data_set = ImageAnnotationDataSet(
                ImageAnnotations.Dummies.create_classes_1(), [annotated_image1, annotated_image2, annotated_image3]
            )

            @test length(data_set) == 3
            @test data_set[1] == annotated_image1
            @test data_set[2] == annotated_image2
            @test data_set[3] == annotated_image3
        end
    end

    @testset "Labels" begin
        @testset "Empty set" begin
            data_set = ImageAnnotationDataSet{Int}()
            @test get_labels(data_set) == []
        end
        @testset "Single annotation" begin
            label = "aeroplane"
            data_set = ImageAnnotationDataSet(AnnotatedImage(ImageAnnotation(label)))
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple annotations" begin
            label = "aeroplane"
            data_set = ImageAnnotationDataSet(AnnotatedImage([ImageAnnotation(label), ImageAnnotation(label)]))
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple annotated images" begin
            label = "aeroplane"
            data_set = ImageAnnotationDataSet([AnnotatedImage(ImageAnnotation(label)), AnnotatedImage(ImageAnnotation(label))])
            @test get_labels(data_set) == [label]
        end
        @testset "Multiple labels" begin
            label1 = "aeroplane"
            label2 = "car"
            data_set = ImageAnnotationDataSet([
                AnnotatedImage([ImageAnnotation(label1), ImageAnnotation(label2)]), AnnotatedImage(ImageAnnotation(label1))
            ])
            @test get_labels(data_set) == [label1, label2]
        end
        @testset "Single label annotation" begin
            label = Label("aeroplane")
            data_set = ImageAnnotationDataSet(AnnotatedImage(ImageAnnotation(label)))
            @test get_labels(data_set) == [label]
        end
    end
end
