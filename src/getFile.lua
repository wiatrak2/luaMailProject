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

local function createMailBody( body, subject, taskInfo )
	body = body.. '\nBardzo proszę o przesłanie odpowiedzi w mailu zatytułowanym "'..subject..' - Rozwiazanie".\nPrzypominam, że sprawdzone zostaną tylko odpowiedzi wysłane przed '..taskInfo[3]..'\nWszelkie zapytania proszę kierować w osobnej wiadomości, w temacie podając tytuł zadania('..subject..')\n\nPozdrawiam i życzę owocnej pracy,\n\nXYZ\n\nMail wygenerowany automatycznie'
	return body
end

local fileModule = { openFile = openFile, getFields = getFields, closeFile = closeFile, getTemplate = getTemplate, createMailBody = createMailBody }
return fileModule