-- Pictures Link Generator

-- Functions
function makeNdigit(num, n)
	local numLen = #tostring(num)
	if numLen == n then
		return num
	elseif numLen < n then 
		return string.rep("0", n - numLen) .. num
	end
end

function parseURL(url)
	local ext  = string.match(url, "%d+(.%a+)$")
	local name = string.match(url, "(%d+).%a+$")
	local url  = string.sub(url, 1, #url - (#name + #ext))	
	return url, name, ext
end

--###############################################################

local inFile = io.open("Sunny Pics.txt", "r")
local outFile = io.open("Sunny Links.txt", "w+")

local lCount = 1

for line in inFile:lines() do 
	-- print(lCount, line)
	
	if (lCount % 3) == 1 then
		url, fNameStart, ext = parseURL(line)
	elseif (lCount % 3) == 2 then
		url2, fNameEnd, ext2 = parseURL(line)
		
		if (url == url2) and (ext == ext2) and (tonumber(fNameStart) < tonumber(fNameEnd)) then
			for i = tonumber(fNameStart), tonumber(fNameEnd) do
				outFile:write(url..makeNdigit(i, #fNameStart)..ext.."\n")
			end
			
			outFile:write("\n")
		end
	end
	
	lCount = lCount + 1
end