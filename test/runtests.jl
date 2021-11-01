using Test

@testset "ObjectDetectors" begin
    include("DummyObjectDetectorTests.jl")
    include("StaticObjectDetectorTests.jl")
end
