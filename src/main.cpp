#include "receiver.h"
#include "sender.h"

int main(int argc, char const *argv[])
{
	std::string taskName = getTaskName();
	printf("Aby pobrać maile związanie z zadaniem %s wciśnij '1'\nAby pobrać odpowiedzi do zadania %s wciśnij '2'\nAby wysłać pytania do zadania %s wciśnij '3'\nAby wysłać maila testowego wciśnij '4'\n Następnie zatwierdź wciskająć ENTER\n", taskName.c_str(), taskName.c_str(), taskName.c_str());
	int option;
	scanf("%d", &option);
	if(option == 1 || option == 2)
	{
		printf("Podaj adres e-mail:\n");
		std::string mailAddress;
		std::cin >> mailAddress;
		printf("Podaj hasło:\n");
		std::string password;
		std::cin >> password;
		bool answers = ( option == 1 ) ? false : true ;
		auto mailSet = receiveMails(mailAddress, password, answers);
		if( answers )
		{
			printf("Otrzymano odpowiedzi od:\n");
			for( auto mail : mailSet )
				std::cout << mail << "\n";
			addPoints( mailSet, taskName );
			printf("Zaktualizowano plik students.csv oraz skrzynkę mailową\n");
		}
		else
		{
			printf("Zaktualizowano skrzynkę mailową\n");
		}
	}
	else if( option == 3 || option == 4 )
	{
		printf("Podaj adres e-mail:\n");
		std::string mailAddress;
		std::cin >> mailAddress;
		printf("Podaj hasło:\n");
		std::string password;
		std::cin >> password;
		auto mails = getStudentsMails();
		if( option == 4 )
		{
			sendMail( mailAddress, mailAddress, password );
			printf("Wysłano testowego maila na %s\n", mailAddress.c_str());
		}
		else
		{
			for( auto& m : mails )
			{
				sendMail( m, mailAddress, password );
				printf("Wysłano maila do %s\n", m.c_str());
			}
			printf("Wysyłanie zakończone.\n");
		}
	}

	return 0;
}