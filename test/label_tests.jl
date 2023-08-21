using ImageAnnotations
using Test

@testset "Label" begin
    @testset "Construction" begin
        type_param_combos = [Int, String]
        type_combos(L) = [Label{L}, Label]
        args_combos = [Tuple{}(), (Dict{String, Any}(),)]
        for T in type_param_combos, TLabel in type_combos(T), args in args_combos
            if args == Tuple{}()
                label_attributes = Dict{String, Any}()
            else
                label_attributes = args[1]
            end
            @testset "$TLabel with type parameter $T and args $args" begin
                label_value = ImageAnnotations.Dummies.create_label(T)
                label = TLabel(label_value, args...)
                @test label.value == label_value
                @test label.attributes == label_attributes
            end
        end
    end
end
