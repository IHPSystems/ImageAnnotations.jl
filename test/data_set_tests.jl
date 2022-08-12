using ImageAnnotations
using Test

import ImageAnnotations: AnnotatedImage, ObjectDetectionDataSet

@testset "Data Set" begin
    @testset "Implements MLUtils data set interface" begin
        @testset "Empty Data Set" begin
            data_set = ObjectDetectionDataSet(String[], AnnotatedImage{BoundingBoxDetection{Float64}}[])

            @test length(data_set) == 0
        end

        @testset "Simple VOC-like data set" begin
            aeroplane_core_args = ("aeroplane", nothing, 256, 256, HUMAN, "alice")
            annotation1 = BoundingBoxDetection(Point2(0.0, 1.0), 2.0, 3.0, aeroplane_core_args...)
            annotation2 = BoundingBoxDetection(Point2(0.0, 1.0), 2.0, 4.0, aeroplane_core_args...)
            annotated_image1 = AnnotatedImage("img1.jpeg", BoundingBoxDetection{Float64}[])
            annotated_image2 = AnnotatedImage("img2.jpeg", [annotation1])
            annotated_image3 = AnnotatedImage("img3.jpeg", [annotation2])
            data_set = ObjectDetectionDataSet(["aeroplane"], [annotated_image1, annotated_image2, annotated_image3])

            @test length(data_set) == 3
            @test data_set[1] == annotated_image1
            @test data_set[2] == annotated_image2
            @test data_set[3] == annotated_image3
        end
    end
end
