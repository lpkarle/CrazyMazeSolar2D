------------------------

M = {}

function M.stack()

    local stack = {}
    
    stack.empty = function()
        return #stack <= 0
    end

    stack.push = function( value )
        table.insert( stack, value )
    end

    stack.peek = function()
        if #stack > 0 then
            return stack[ #stack ]
        end
    end

    stack.pop = function()
        if #stack > 0 then
            local topValue = stack[ #stack ]
            table.remove( stack, #stack )

            return topValue
        end
    end

    return stack

end

return M