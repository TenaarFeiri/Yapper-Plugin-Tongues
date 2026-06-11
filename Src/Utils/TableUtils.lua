local name, Tongues = ...
local Utils = Tongues.Core.Utils or nil

if not Utils then
    print("Tongues Utils could not load. This should never happen; make sure Core is the first file to load.")
    return
end

local TableUtils = {}

--- Creates a deep copy of a table
--- @param tbl table The table to copy
--- @return table copy The copied table
function TableUtils:DeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = TableUtils:DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--- Creates a shallow copy of a table
--- @param tbl table The table to copy
--- @return table copy The copied table
function TableUtils:ShallowCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = v
    end
    return copy
end

--- Merges multiple tables into one
--- @param ... table The tables to merge
--- @return table result The merged table
function TableUtils:MergeTables(...)
    local result = {}
    for _, tbl in ipairs({...}) do
        for k, v in pairs(tbl) do
            result[k] = v
        end
    end
    return result
end

--- Performs a deep search through nested tables
--- @param tbl table The table to search
--- @param key string The key to search for
--- @param ... any Additional keys to search for in nested tables
--- @return any The found value or nil if not found
function TableUtils:DeepSearch(tbl, key, ...)
    if type(tbl) ~= "table" then
        return nil
    end
    
    local value = tbl[key]
    
    if select("#", ...) == 0 then
        return value
    end
    
    if type(value) == "table" then
        return TableUtils:DeepSearch(value, ...)
    end
    
    return nil
end

Utils.TableUtils = TableUtils
return TableUtils