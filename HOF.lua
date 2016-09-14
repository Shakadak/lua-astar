-- https://gist.github.com/jcmoyer/5571987

-- shallowly clones an array table
function clone(t)
  local r = {}
  for i = 1, #t do
    r[#r + 1] = t[i]
  end
  return r
end

-- for any function 'f', the following is true:
--   curry(f)(x)(y)(z) == f(x, y, z)
--
-- if 'f' is some function of arity 3,
--   curry(f) == function(x) return function(y) return function(z) return f(x, y, z) end end end
--
-- for convenience, functions returned by curry do not *require* you to apply only one parameter
-- at a time (partial application):
--   curry(f)(x, y)(z) == f(x, y, z)
-- perhaps this function would be better named 'partial'
function curry(f)
  local info = debug.getinfo(f, 'u')

  local function docurry(s, left, ...)
    local ptbl = clone(s)
    local vargs = {...}
    for i = 1, #vargs do
      ptbl[#ptbl + 1] = vargs[i]
    end
    left = left - #vargs
    if left > 0 then
      return function(...)
        return docurry(ptbl, left, ...)
      end
    else
      return f(unpack(ptbl))
    end
  end

  return function(...)
    return docurry({}, info.nparams, ...)
  end
end

return {curry = curry}
