using ImageAnnotations
using Test

@testset "Label" begin
    @testset "Mutability" begin
        label = Label("person")
        label.value = "car"
        label.attributes = Dict("colour" => "red")
        @test label.value == "car"
        @test label.attributes == Dict("colour" => "red")
    end
end
