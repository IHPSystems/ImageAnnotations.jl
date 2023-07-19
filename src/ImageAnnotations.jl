module ImageAnnotations

using GeometryBasics

export AbstractLabel, Label

export AbstractClassificationImageAnnotation,
    AbstractImageAnnotation,
    AbstractRegressionImageAnnotation,
    ClassificationImageAnnotation,
    RegressionImageAnnotation,
    class,
    confidence,
    annotator_name,
    value

export AbstractObjectAnnotation, image_width, image_height, centroid, bounding_box, bounding_box_annotation, iou
export BoundingBoxAnnotation, bounding_box_annotation_with_center
export OrientedBoundingBoxAnnotation, width, height, orientation
export PolygonAnnotation, vertices

export AnnotatedImage, annotations

export ClassificationImageAnnotationDataSet, get_labels

export AbstractObjectAnnotator, annotate
export StaticObjectAnnotator

include("label.jl")

include("image_annotation.jl")
include("classification_annotation.jl")
include("regression_image_annotation.jl")

include("abstract_object_annotation.jl")
include("bounding_box_annotation.jl")
include("oriented_bounding_box_annotation.jl")
include("polygon_annotation.jl")
include("annotated_image.jl")
include("data_set.jl")

include("abstract_image_annotator.jl")
include("static_image_annotator.jl")

include("Dummies.jl")

end # module
