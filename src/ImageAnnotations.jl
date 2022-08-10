module ImageAnnotations

using GeometryBasics

export AbstractObjectDetection, DetectorType, HUMAN, MACHINE,
       class_name, confidence, image_width, image_height, detector_type, detector_name,
       centroid, bounding_box, bounding_box_detection, iou
export AbstractObjectDetector, detect
export BoundingBoxDetection, create_with_center
export OrientedBoundingBoxDetection, width, height, orientation, rotate_point
export PolygonDetection, vertices
export StaticObjectDetector, create_polygon

include("abstract_object_detection.jl")
include("bounding_box_detection.jl")
include("oriented_bounding_box_detection.jl")
include("polygon_detection.jl")

include("abstract_object_detector.jl")
include("static_object_detector.jl")

end # module
