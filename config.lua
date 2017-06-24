questToSend = 4
mailToFlag = 2
deleteFromMainMailbox = false

nameOfCsv = "students.csv";
nameOfTask = "task.txt";
nameOfQuest = "quest.txt";
nameOfTemplate = "template.txt";





local module = { questToSend = questToSend,
				 mailToFlag = mailToFlag, 
				 deleteFromMainMailbox = deleteFromMainMailbox,
				 nameOfTask = nameOfTask,
				 nameOfTemplate = nameOfTemplate,
				 nameOfQuest = nameOfQuest
				}
return module