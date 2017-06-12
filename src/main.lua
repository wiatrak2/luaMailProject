local mail = require('mail')
local getFile = require('getFile')

questToSend = 3
mailToFlag = 2

local function getRandom( rndNum, maxNum )
	if( rndNum >= maxNum ) then
		local res = {}
		for i = 1, maxNum do res[ i ] = i end
		return res
	end

	math.randomseed(os.time())
	math.random() ; math.random() ; math.random();
	local check = {}
	local res = {}
	while( #res ~= rndNum ) do
		local rnd = math.random( maxNum )
		if( check[rnd] == nil ) then
			check[rnd] = true
			res[#res + 1] = rnd
		end
	end
	return res
end

function getMails( fileName, mailName, password, answers )
	local file = getFile.openFile( fileName )
	local taskInfo = getFile.getFields( file )
	getFile.closeFile( file )

	local gmail = mail.openMail(mailName, password)

	local mails 
	if answers then 
		mails = mail.getValidMails( gmail, taskInfo[2], taskInfo[3], taskInfo[1]:sub(1, taskInfo[1]:len()-1)..' - Rozwiazanie"' )
	else
		mails = mail.getValidMails( gmail, taskInfo[2], taskInfo[3], taskInfo[1])
	end
	if answers then
		local flaggedM = getRandom( mailToFlag, #mails )

		for i = 1, #flaggedM do
			mail.flagMail(gmail, mails[ flaggedM[i] ].uid)
		end
	end

	local mailboxName;
	if answers then
		mailboxName = taskInfo[1]:sub(1, taskInfo[1]:len()-1)..' - Rozwiazania"'
	else
		mailboxName = taskInfo[1]:sub(1, taskInfo[1]:len()-1)..' - Wszystkie"'
	end
	createMailbox(gmail, mailboxName )
	moveToMailbox(gmail, mails, mailboxName )
	closeMail(gmail)

	local res = {}
	for _, v in pairs(mails) do
		res[#res + 1] = v.from
	end
	return res
end

function sendMails( fileInfoName, taskContent, taskTemplate, mailRcpt, mailAddress, password )
	local file = getFile.openFile( fileInfoName )
	local taskInfo = getFile.getFields( file )
	getFile.closeFile( file )

	local subject = taskInfo[1]
	subject = subject:sub( 2, subject:len() - 1 )

	file = getFile.openFile(taskTemplate)
	local templateContest = getFile.getTemplate(file)
	getFile.closeFile( file )

	local quests = {}
	file = getFile.openFile(taskContent)
	for line in io.lines() do quests[#quests + 1] = line end
	getFile.closeFile(file)
	
	local questNums = getRandom( questToSend, #quests )

	for i = 1, #questNums do
		templateContest = templateContest..quests[questNums[i]]..'\n'
	end
	templateContest = getFile.createMailBody( templateContest, subject, taskInfo )
	mail.sendMessage( subject, templateContest, mailRcpt, mailAddress, password );
end
