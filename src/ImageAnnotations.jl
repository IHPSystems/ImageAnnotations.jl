module ImageAnnotations

using GeometryBasics

export AbstractConcept, AbstractConceptAttribute, CategoricalConceptAttribute, Concept

export AbstractLabel, Label

export AbstractImageAnnotation, ImageAnnotation, get_label, get_confidence, get_annotator_name

export AbstractObjectAnnotation, get_centroid, get_bounding_box, get_bounding_box_annotation, compute_iou
export BoundingBoxAnnotation, create_bounding_box_annotation_with_center
export OrientedBoundingBoxAnnotation, get_width, get_height, get_orientation
export PolygonAnnotation, get_vertices

export AnnotatedImage, get_annotations

export ImageAnnotationDataSet, get_labels

export AbstractObjectAnnotator, annotate
export StaticObjectAnnotator

include("label.jl")
include("concept.jl")

include("image_annotation.jl")

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
