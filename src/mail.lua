local socket = require("socket")
local smtp = require("socket.smtp")
local ssl = require("ssl")
local https = require("ssl.https")
local ltn12 = require("ltn12")
local imap = require("imap")

local function sslCreate()
    local sock = socket.tcp()
    return setmetatable({
        connect = function(_, host, port)
            local r, e = sock:connect(host, port)
            if not r then return r, e end
            sock = ssl.wrap(sock, {mode='client', protocol='tlsv1'})
            return sock:dohandshake()
        end
    }, {
        __index = function(t,n)
            return function(_, ...)
                return sock[n](sock, ...)
            end
        end
    })
end

function sendMessage(subject, body, rcpt, username, passwordMail)
    local msg = {
        headers = {
            to = rcpt,
            subject = subject
        },
        body = body
    }

    local ok, err = smtp.send {
        from = '<'..username..'>',
        rcpt = {'<'..rcpt..'>'},
        source = smtp.message(msg),
        user = username,
        password = passwordMail,
        server = 'smtp.gmail.com',
        port = 465,
        create = sslCreate
    }
    if not ok then
        print("Mail send failed", err)
    end
end

function openMail( username, password )
    local function prompt(str) io.write(str); return io.read() end
    local gmail = imap.connect("imap.gmail.com", 993, true)
    gmail:capability()
    gmail:login(username, password)
    gmail:select "Inbox"
    return gmail
end

function closeMail( gmail )
    gmail:logout()
end

local function parseMonth( month )
    local tab = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
    return tab[month]
end

local function parseHeader( headers )
	local mailInfo = {}
	for _,v in pairs(headers) do 
		if( string.match(v, 'From:.*') == v ) then 
			mailInfo.from =  string.match(v, '<(.+%@%w+%.%w+)')
		end
		if( string.match(v, 'Subject:.*') == v ) then
			mailInfo.sub = string.sub(v, 10)
		end

		if( string.match(v, 'Date:.*') == v ) then
            mailInfo.date = { day = tonumber(string.match(v, '(%d+)%s%w+%s%d+') ), month = parseMonth( string.match(v, '%d+%s(%w+)%s%d+') ), year = tonumber(string.match(v, '%d+%s%w+%s(%d+)') ) }
		end
	end
	return mailInfo
end

local function getUids( searchStr )
    local uidsTab = {}
    for uid in searchStr:gmatch('(%d+)') do uidsTab[#uidsTab + 1] = uid end
    return uidsTab
end

function createMailbox( gmail, mailboxName )
    gmail:create(mailboxName)
end

function getValidMails( gmail, dateSince, dateBefore, sub )
    local searchFilter = 'SUBJECT '..sub..' SINCE '..dateSince..' BEFORE '..dateBefore
    local searchedMsg = gmail:uid_search( searchFilter )
    local uidsTab = getUids( searchedMsg[1] )
    local validMails = {}
    for _, v in pairs(uidsTab) do
        local mail = gmail:uid_fetch(v..' RFC822')
        local mailInfo = parseHeader(mail)
        mailInfo.uid = v
        validMails[#validMails + 1] = mailInfo
    end
    return validMails
end

function moveToMailbox( gmail, mails, mailboxName, deleteFromMain )
    for _, v in pairs(mails) do
        gmail:uid('COPY '..v.uid..' '..mailboxName)
        if( deleteFromMain ) then
        	gmail:store(v.uid..' +FLAGS (\\Deleted)' )
        	gmail:expunge()
        end
    end
end

function flagMail( gmail, mailUID )
    local storeFilter = mailUID..' +FLAGS (\\Flagged)'
    gmail:store( storeFilter )
end


local mailModule = { 
    sendMessage = sendMessage,
    openMail = openMail,
    getValidMails = getValidMails,
    flagMail = flagMail,
    createMailbox = createMailbox,
    moveToMailbox = moveToMailbox,
    closeMail = closeMail
 }

return mailModule
