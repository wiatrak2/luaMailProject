local function openFile( name )
	local file = io.input( name, "r" )
	if( file == nil ) then
		error("Could not open "..name)
	end
	return file
end

local function closeFile( file )
	io.input():close()
	io.input( io.stdin )
end

local function getFields( file )
	local fields = {}
	for line in io.lines() do
		fields[#fields + 1] = string.match(line, '[%a%s]+:%s(.+)')	
	end
	return fields
end

local function getTemplate( file )
	return io.read('all') 
end

local fileModule = { openFile = openFile, getFields = getFields, closeFile = closeFile, getTemplate = getTemplate }
return fileModule