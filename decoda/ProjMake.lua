lfs = require"lfs"
print(lfs.currentdir())
--local resScriptPath = "D:/Work/Slamdunk/slamdunk_client/bin/gameres/res/script"
local resScriptPath = "D:/Work/cocos2d-2.1rc0-x-2.1.3/samples/Lua/qbwdemo/Resources/LuaScript"



local resOutPath = "D:/Work/cocos2d-2.1rc0-x-2.1.3/samples/Lua/qbwdemo/Resources/decoda/qbwdemo.deproj"


function getpathes(rootpath, pathes)
    pathes = pathes or {}
    for entry in lfs.dir(rootpath) do
        if entry ~= '.' and entry ~= '..' then
            local path = rootpath .. '\\' .. entry
            local attr = lfs.attributes(path)
            assert(type(attr) == 'table')
            --print("attr.mode "..attr.mode)
			
			--for i,v in pairs (attr) do
			--	print(i..": "..v)                                                                                                                                               
			--end
            if attr.mode == 'directory' then
                getpathes(path, pathes)
            else
                table.insert(pathes, path)
            end
        end
    end
    return pathes
end

local t = getpathes(resScriptPath)

local path = resOutPath
local file = io.open(path,"w")
file:write("<?xml version=\"1.0\" encoding=\"utf-8\"?>")
file:write("\r\n")
file:write("<project>")
file:write("\r\n")


for i,v in pairs(t)do
	--print(v)
	file:write("<file>")
	file:write("\r\n")
	local s = string.gsub(v, "/", "\\")
	file:write("<filename>"..s.."</filename>") --<filename>..\..\..\Work\Gundam\gundam_engine\Data\gameres\res\script\define.lua</filename>
	file:write("\r\n")
	file:write("</file>")
	file:write("\r\n")
	
end

 

file:write("</project>")
file:write("\r\n")
file:close()






















