abstract type AbstractImageAnnotation{L} end

function get_label end
function get_confidence end
function get_annotator_name end

function Base.isless(a::T, b::U) where {T <: AbstractImageAnnotation, U <: AbstractImageAnnotation}
    if Symbol(T) < Symbol(U)
        return true
    elseif Symbol(U) < Symbol(T)
        return false
    end
    if get_label(a) !== get_label(b)
        return get_label(a) < get_label(b)
    end
    if get_confidence(a) === nothing
        if get_confidence(b) === nothing
            if get_annotator_name(a) === nothing
                return get_annotator_name(b) !== nothing
            else
                if get_annotator_name(b) === nothing
                    return false
                else
                    return get_annotator_name(a) < get_annotator_name(b)
                end
            end
        else
            return true
        end
    else
        if get_confidence(b) === nothing
            return false
        else
            if get_confidence(a) !== get_confidence(b)
                return get_confidence(a) < get_confidence(b)
            else
                if get_annotator_name(a) === nothing
                    return get_annotator_name(b) !== nothing
                else
                    if get_annotator_name(b) === nothing
                        return false
                    else
                        return get_annotator_name(a) < get_annotator_name(b)
                    end
                end
            end
        end
    end
end
