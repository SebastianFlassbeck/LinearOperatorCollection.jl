module LinearOperatorCollection

import Base: length, iterate, \
using LinearAlgebra
import LinearAlgebra.BLAS: gemv, gemv!
import LinearAlgebra: BlasFloat, normalize!, norm, rmul!, lmul!
using SparseArrays
using Random

using Reexport
@reexport using Reexport
@reexport using LinearOperators

LinearOperators.use_prod5!(op::opEye) = false
LinearOperators.has_args5(op::opEye) = false

# Helper function to wrap a prod into a 5-args mul
function wrapProd(prod::Function)
  λ = (res, x, α, β) -> begin
    if β == zero(β)
      res .= prod(x) .* α
    else
      res .= prod(x) .* α .+ β .* res
    end
  end
  return λ
end

export linearOperatorList, constructLinearOperator
export AbstractLinearOperatorFromCollection, WaveletOp, FFTOp, DCTOp, DSTOp, NFFTOp,
       SamplingOp, NormalOp, WeightingOp, GradientOp

abstract type AbstractLinearOperatorFromCollection{T} <: AbstractLinearOperator{T} end
abstract type WaveletOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type FFTOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type DCTOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type DSTOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type NFFTOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type SamplingOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type NormalOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type WeightingOp{T} <: AbstractLinearOperatorFromCollection{T} end
abstract type GradientOp{T} <: AbstractLinearOperatorFromCollection{T} end

function constructLinearOperator(::Type{<:AbstractLinearOperatorFromCollection}, args...; kargs...) 
  error("Operator can't be constructed. You need to load another package!")
end

"""
  returns a list of currently implemented `LinearOperator`s
"""
function linearOperatorList()
  return subtypes(AbstractLinearOperatorFromCollection)
end

include("GradientOp.jl")
include("SamplingOp.jl")
include("WeightingOp.jl")
include("NormalOp.jl")

end
