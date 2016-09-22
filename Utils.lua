local function  compose(f)
    return     function(g)
        return function(x)
            return f(g(x))
        end
    end
end

local function fromNil(default)
    return function(maybeNil)
        if maybeNil == nil
            then return default
            else return maybeNil
        end
    end
end

return {
    compose = compose,
    fromNil = fromNil
}
