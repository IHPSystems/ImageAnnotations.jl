module Dummies

using GeometryBasics
using ..ImageAnnotations

"Excerpt of the COCO classes."
create_classes_1(::Type{String}) = ["person", "bicycle", "car"]
create_classes_1(::Type{Label{String}}) = [Label(l) for l in create_classes_1(String)]
create_classes_1(::Type{Int}) = Int.(1:length(create_classes_1(String)))
create_classes_1(::Type{Float32}) = Float32.(create_classes_1(Int))
create_classes_1(::Type{Float64}) = Float64.(create_classes_1(Int))
create_classes_1() = create_classes_1(String)

for L in [Int, Float64, Float32]
    @eval create_label_1(::Type{$L}) = $L(1)
    @eval create_label_2(::Type{$L}) = $L(2)
    @eval create_label_3(::Type{$L}) = $L(3)
end
for L in [String, Label{String}]
    @eval create_label_1(::Type{$L}) = $L(create_classes_1()[1])
    @eval create_label_2(::Type{$L}) = $L(create_classes_1()[2])
    @eval create_label_3(::Type{$L}) = $L(create_classes_1()[3])
end

for L in [Int, Float64, Float32, String, Label{String}]
    @eval create_image_annotation_1(::Type{$L}) = ImageAnnotation(create_label_1($L))
    @eval create_image_annotation_2(::Type{$L}) = ImageAnnotation(create_label_2($L))
    @eval create_image_annotation_3(::Type{$L}) = ImageAnnotation(create_label_3($L); confidence = 0.6f0)

    @eval function create_annotated_image_1(::Type{$L})
        return AnnotatedImage(
            create_image_annotation_1($L); image_file_path = joinpath("images", "image1.jpeg"), image_height = 9, image_width = 16
        )
    end
    @eval function create_annotated_image_2(::Type{$L})
        return AnnotatedImage(
            sort([create_image_annotation_1($L), create_image_annotation_2($L)]);
            image_file_path = joinpath("images", "image2.jpeg"),
            image_height = 9,
            image_width = 16,
        )
    end

    @eval create_image_annotation_dataset_1(::Type{$L}) = ImageAnnotationDataSet(create_classes_1($L), [create_annotated_image_1($L)])
    @eval create_image_annotation_dataset_2(::Type{$L}) = ImageAnnotationDataSet(create_classes_1($L), [create_annotated_image_2($L)])

    for T in [Float64, Float32]
        @eval create_bounding_box_annotation_1(::Type{$L}, ::Type{$T}) =
            BoundingBoxAnnotation(Point2{$T}($T(0), $T(0)), $T(1), $T(1), create_label_1($L))
        @eval create_bounding_box_annotation_2(::Type{$L}, ::Type{$T}) =
            BoundingBoxAnnotation(Point2{$T}($T(0), $T(1)), $T(2), $T(3), create_label_2($L))
        @eval create_bounding_box_annotation_3(::Type{$L}, ::Type{$T}) =
            BoundingBoxAnnotation(Point2{$T}($T(0), $T(1)), $T(2), $T(3), create_label_3($L); confidence = 0.6f0)

        @eval create_oriented_bounding_box_annotation_1(::Type{$L}, ::Type{$T}) =
            OrientedBoundingBoxAnnotation(Point2{$T}($T(0), $T(0)), $T(1), $T(1), $T(0), create_label_1($L))
        @eval create_oriented_bounding_box_annotation_2(::Type{$L}, ::Type{$T}) =
            OrientedBoundingBoxAnnotation(Point2{$T}($T(0), $T(1)), $T(2), $T(3), $T(pi / 2), create_label_2($L))
        @eval create_oriented_bounding_box_annotation_3(::Type{$L}, ::Type{$T}) =
            OrientedBoundingBoxAnnotation(Point2{$T}($T(0), $T(1)), $T(2), $T(3), $T(pi / 2), create_label_3($L); confidence = 0.6f0)

        @eval create_polygon_annotation_1(::Type{$L}, ::Type{$T}) =
            PolygonAnnotation([Point2{$T}($T(0), $T(0)), Point2{$T}($T(1), $T(0)), Point2{$T}($T(1), $T(1))], create_label_1($L))
        @eval create_polygon_annotation_2(::Type{$L}, ::Type{$T}) =
            PolygonAnnotation([Point2{$T}($T(0), $T(1)), Point2{$T}($T(2), $T(3)), Point2{$T}($T(4), $T(5))], create_label_2($L))
        @eval create_polygon_annotation_3(::Type{$L}, ::Type{$T}) = PolygonAnnotation(
            [Point2{$T}($T(0), $T(1)), Point2{$T}($T(2), $T(3)), Point2{$T}($T(4), $T(5))], create_label_3($L); confidence = 0.6f0
        )

        @eval function create_annotated_image_3(::Type{$L}, ::Type{$T})
            return AnnotatedImage(
                sort([
                    create_image_annotation_1($L),
                    create_image_annotation_2($L),
                    create_bounding_box_annotation_1($L, $T),
                    create_bounding_box_annotation_2($L, $T),
                    create_oriented_bounding_box_annotation_1($L, $T),
                    create_oriented_bounding_box_annotation_2($L, $T),
                    create_polygon_annotation_1($L, $T),
                    create_polygon_annotation_2($L, $T),
                ]);
                image_file_path = joinpath("images", "image3.jpeg"),
                image_height = 9,
                image_width = 16,
            )
        end
        @eval function create_annotated_image_4(::Type{$L}, ::Type{$T})
            return AnnotatedImage(
                sort([
                    create_image_annotation_3($L),
                    create_bounding_box_annotation_3($L, $T),
                    create_oriented_bounding_box_annotation_3($L, $T),
                    create_polygon_annotation_3($L, $T),
                ]);
                image_file_path = joinpath("images", "image4.jpeg"),
                image_height = 9,
                image_width = 16,
            )
        end

        @eval function create_image_annotation_dataset_3(::Type{$L}, ::Type{$T})
            return ImageAnnotationDataSet(create_classes_1($L), [create_annotated_image_3($L, $T)])
        end
        @eval function create_image_annotation_dataset_4(::Type{$L}, ::Type{$T})
            return ImageAnnotationDataSet(create_classes_1($L), [create_annotated_image_4($L, $T)])
        end
    end
end

create_label_1() = create_label_1(String)
create_label_2() = create_label_2(String)
create_label_3() = create_label_3(String)

create_image_annotation_1() = create_image_annotation_1(String)
create_image_annotation_2() = create_image_annotation_2(String)
create_image_annotation_3() = create_image_annotation_3(String)

create_bounding_box_annotation_1() = create_bounding_box_annotation_1(String, Float64)
create_bounding_box_annotation_2() = create_bounding_box_annotation_2(String, Float64)
create_bounding_box_annotation_3() = create_bounding_box_annotation_3(String, Float64)

create_oriented_bounding_box_annotation_1() = create_oriented_bounding_box_annotation_1(String, Float64)
create_oriented_bounding_box_annotation_2() = create_oriented_bounding_box_annotation_2(String, Float64)
create_oriented_bounding_box_annotation_3() = create_oriented_bounding_box_annotation_3(String, Float64)

create_polygon_annotation_1() = create_polygon_annotation_1(String, Float64)
create_polygon_annotation_2() = create_polygon_annotation_2(String, Float64)
create_polygon_annotation_3() = create_polygon_annotation_3(String, Float64)

create_annotated_image_0() = AnnotatedImage(; image_file_path = joinpath("images", "image0.jpeg"), image_height = 9, image_width = 16)
create_annotated_image_1() = create_annotated_image_1(String)
create_annotated_image_2() = create_annotated_image_2(String)
create_annotated_image_3() = create_annotated_image_3(String, Float64)
create_annotated_image_4() = create_annotated_image_4(String, Float64)

create_image_annotation_dataset_0() = ImageAnnotationDataSet(create_classes_1(), AnnotatedImage[])
create_image_annotation_dataset_1() = create_image_annotation_dataset_1(String)
create_image_annotation_dataset_2() = create_image_annotation_dataset_2(String)
create_image_annotation_dataset_3() = create_image_annotation_dataset_3(String, Float64)
create_image_annotation_dataset_4() = create_image_annotation_dataset_4(String, Float64)

end
