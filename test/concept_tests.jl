using ImageAnnotations
using Test

@testset "Concept" begin
    @testset "Label in Concept" begin
        @testset "Label value must be equal to Concept value" begin
            bicycle_concept = Concept("bicycle")
            car_concept = Concept("car")
            car_label = Label("car")
            @test car_label ∈ car_concept
            @test car_label ∉ bicycle_concept
        end

        @testset "Concept attributes must be in Label" begin
            red_car_concept = Concept("car"; attributes = [CategoricalConceptAttribute("colour", ["red"])])
            car_label = Label("car")
            red_car_label = Label("car", Dict{String, Any}("colour" => "red"))
            blue_car_label = Label("car", Dict{String, Any}("colour" => "blue"))

            @test car_label ∉ red_car_concept
            @test red_car_label ∈ red_car_concept
            @test blue_car_label ∉ red_car_concept
        end

        @testset "Superfluous Label attributes are ignored" begin
            car_concept = Concept("car")
            red_car_label = Label("car", Dict{String, Any}("colour" => "red"))
            @test red_car_label ∈ car_concept
        end
    end

    @testset "Label in Vector{Concept}" begin
        bicycle_concept = Concept("bicycle")
        car_concept = Concept("car")
        schema = [bicycle_concept, car_concept]
        car_label = Label("car")
        aeroplane_label = Label("aeroplane")

        @test car_label ∈ schema
        @test aeroplane_label ∉ schema
    end
end

@testset "CategoricalConceptAttribute" begin
    @testset "Constructor" begin
        @testset "Values must be non-empty" begin
            @test_throws ArgumentError CategoricalConceptAttribute("colour", String[])
        end
        @testset "Default value must be one of the values" begin
            @test_throws ArgumentError CategoricalConceptAttribute("colour", ["red", "green"], "blue")
        end
        @testset "Default value defaults to first value" begin
            attribute = CategoricalConceptAttribute("colour", ["red", "green"])
            @test attribute.default_value == "red"
        end
    end
end
