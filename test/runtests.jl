using Test

@testset "ImageAnnotations" begin
    include("abstract_image_annotation_tests.jl")
    include("concept_tests.jl")
    include("image_annotation_tests.jl")
    include("label_tests.jl")
    include("static_object_annotator_tests.jl")
    include("abstract_object_annotation_tests.jl")
    include("bounding_box_annotation_tests.jl")
    include("oriented_bounding_box_annotation_tests.jl")
    include("polygon_annotation_tests.jl")
    include("iou_tests.jl")
    include("annotated_image_tests.jl")
    include("data_set_tests.jl")
    include("dummies_tests.jl")
end
