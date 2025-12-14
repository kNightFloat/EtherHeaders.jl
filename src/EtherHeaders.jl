#=
  @ author: ChenyuBao <chenyu.bao@outlook.com>
  @ date: 2025-12-10 21:20:46
  @ license: MIT
  @ language: Julia
  @ declaration: EtherHeaders.jl uses NamedTuple to express variables.
  @ description: main file
 =#

module EtherHeaders

export dict2nt
export AbstractEtherHeader
export EHeader
export capacity, index

# * ===== ===== tools ===== ===== * #

@inline function dict2nt(d::AbstractDict{Symbol,<:Integer})::NamedTuple
    _names = Tuple(collect(keys(d)))
    _values = collect(values(d))
    return NamedTuple{_names}(Int.(_values))
end

@inline function dict2nt(d::AbstractDict{<:AbstractString,<:Integer})::NamedTuple
    _names = Tuple(Symbol.(collect(keys(d))))
    _values = collect(values(d))
    return NamedTuple{_names}(Int.(_values))
end

@inline function allint(nt::NamedTuple)::Bool
    for (_, value) in pairs(nt)
        if !(isa(value, Integer))
            return false
        end
    end
    return true
end

@inline function Base.Int(nt::NamedTuple)::NamedTuple
    if allint(nt)
        _names = keys(nt)
        _values = map(v -> Int(v), values(nt))
        return NamedTuple{_names}(_values)
    else
        throw(
            ArgumentError(
                "NamedTuple cannot be converted to NamedTuple{Int} because not all values are integers.",
            ),
        )
    end
end

@inline function Base.accumulate(nt::NamedTuple)::NamedTuple
    if allint(nt)
        _names = keys(nt)
        _values = collect(values(nt))
        len = length(_values)
        new_values = zeros(Int, len)
        new_values[1] = 1
        for i = 2:len
            new_values[i] = new_values[i-1] + _values[i-1]
        end
        return NamedTuple{_names}(new_values)
    else
        throw(
            ArgumentError(
                "NamedTuple cannot be accumulated because not all values are integers.",
            ),
        )
    end
end

# * ===== ===== AbstractEtherHeader ===== ===== * #

abstract type AbstractEtherHeader{Tnt<:NamedTuple} end

@inline function capacity(eh::AbstractEtherHeader{Tnt})::Tnt where {Tnt<:NamedTuple}
    return getfield(eh, :capacity_nt_)
end

@inline function index(eh::AbstractEtherHeader{Tnt})::Tnt where {Tnt<:NamedTuple}
    return getfield(eh, :index_nt_)
end

@inline function Base.length(eh::AbstractEtherHeader)::Int
    return capacity(eh)[end] + index(eh)[end] - 1
end

@inline function Base.show(io::IO, eh::AbstractEtherHeader)
    str::String = "$(String(nameof(typeof(eh)))){"
    str *= "$(length(eh))}"
    str *= "$(keys(index(eh)))"
    println(io, str)
end

@inline function Base.keys(eh::AbstractEtherHeader)
    return keys(index(eh))
end

# * ===== ===== EHeader ===== ===== * #

struct EHeader{Tnt<:NamedTuple} <: AbstractEtherHeader{Tnt}
    capacity_nt_::Tnt
    index_nt_::Tnt
end

@inline function EHeader(capacity_nt::NamedTuple)
    capacity_nt = Int(capacity_nt)
    index_nt = accumulate(capacity_nt)
    return EHeader{typeof(index_nt)}(capacity_nt, index_nt)
end

end # module EtherHeaders
