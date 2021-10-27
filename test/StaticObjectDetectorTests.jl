using Test
import ObjectDetectors

@testset "StaticObjectDetector" begin
    detector = ObjectDetectors.StaticObjectDetector([1,2,3,0.4])
    img = Array{UInt8}(undef, 10, 10, 3)
    detections = ObjectDetectors.detect(detector, img)
    @test length(detections) == 1
    @test detections[1].class == 3
    @test detections[1].confidence == Float32(0.4)

    center = ObjectDetectors.weighted_mean(detections[1].polygon)
    @test center.row == UInt32(1)
    @test center.col == UInt32(2)
end
