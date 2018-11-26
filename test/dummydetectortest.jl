using Test
import Detectors

@testset "DummyDetector" begin
    detector = Detectors.DummyDetector()
    img = Array{UInt8}(undef, 10, 10, 3)
    detections = Detectors.detect(detector, img)
    @test length(detections) > 0
    @test typeof(detections[1].class) == Int32
    @test typeof(detections[1].confidence) == Float32
    @test detections[1].confidence >= 0.0 && detections[1].confidence <= 1.0
    @test length(detections[1].polygon) == 4
end