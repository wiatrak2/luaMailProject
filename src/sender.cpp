#include "sender.h"

std::vector< std::string > getStudentsMails( std::string const& pathToCsv )
{
	std::ifstream input(pathToCsv);
	std::vector<std::string> mails;
	std::string line;
	std::getline( input, line ); //first line
	while( std::getline( input, line ) )
	{
		std::size_t mailPos = line.find_first_of(";");
		std::string mail = line.erase( mailPos );
		mails.push_back(mail);
	}
	input.close();

	return mails;
}

void sendMail( std::string& mail, std::string& mailAddress, std::string& password, std::string const& pathToTask, std::string const& pathToQuest, std::string const& pathToTemplate )
{
	lua_State *L = luaL_newstate();
	luaL_openlibs( L );
	if (luaL_loadfile(L, "main.lua")  || lua_pcall(L, 0, 0, 0))
	    throw std::runtime_error( "Could not load lua script" );
	lua_getglobal(L, "sendMails");
	lua_pushstring(L, pathToTask.c_str());
	lua_pushstring(L, pathToQuest.c_str());
	lua_pushstring(L, pathToTemplate.c_str());
	lua_pushstring(L, mail.c_str());
	lua_pushstring(L, mailAddress.c_str());
	lua_pushstring(L, password.c_str());
	if( lua_pcall( L, 6, 0, 0 ) != LUA_OK )
		throw std::runtime_error("Error while sending mail to " + mail);
}