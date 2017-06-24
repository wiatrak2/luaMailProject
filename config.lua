questToSend 			= 4 				-- Ilość pytań dla każdej wiadomości
mailToFlag 				= 2 				-- Ilość maili, jakie mają zostać oznaczone gwiazdką
deleteFromMainMailbox 	= false				-- Usunięcie maili z głównej skrzynki po przeniesieniu do folderu - true/false

nameOfCsv 				= "students.csv";	-- Nazwa pliku csv
nameOfTask 				= "task.txt";		-- Nazwa pliku z informacjami o zadaniu
nameOfQuest 			= "quest.txt";		-- Nazwa pliku z treścią pytań
nameOfTemplate 			= "template.txt";	-- Nazwa pliku z początkiem wiadomości





local module = { questToSend = questToSend,
				 mailToFlag = mailToFlag, 
				 deleteFromMainMailbox = deleteFromMainMailbox,
				 nameOfTask = nameOfTask,
				 nameOfTemplate = nameOfTemplate,
				 nameOfQuest = nameOfQuest
				}
return module