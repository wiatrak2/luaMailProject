#include "receiver.h"

bool studentMail( std::string line, std::set< std::string >& students )
{
	std::size_t mailPos = line.find_first_of(";");
	std::string mail = line.erase( mailPos );
	return ( students.find( mail ) != students.end() );
}

void addPoints( std::set< std::string >& students, std::string const& taskName )
{
	std::ifstream input("../students.csv");
	std::vector<std::string> lines;
	std::string line;
	std::getline( input, line ); //first line
	line += ';' + taskName +'\n';
	lines.push_back( line );
	while( std::getline( input, line ) )
	{
		line += studentMail( line, students ) ? ";1\n" : ";0\n";
		lines.push_back( line );
	}
	input.close();

	std::ofstream output("../students.csv");
	for( auto outLine : lines ) 
		output << outLine;
	output.close();
}

std::string luaString( lua_State *L )
{
	std::string result; 
  	if( ! lua_isstring( L, -1 ) )
  		throw std::runtime_error( "Failed to load board field - not a string" );
  	result = lua_tostring( L, -1 );
  	lua_pop( L, 1 );
  	return result;
}

std::set< std::string > receiveMails( std::string& mailAddress, std::string& password, bool answers )
{
	lua_State *L = luaL_newstate();
	luaL_openlibs( L );
	if (luaL_loadfile(L, "main.lua")  || lua_pcall(L, 0, 0, 0))
	    throw std::runtime_error( "Could not load lua script" );
	lua_getglobal(L, "getMails");
	lua_pushstring(L, "../task.txt");
	lua_pushstring(L, mailAddress.c_str());
	lua_pushstring(L, password.c_str());
	lua_pushboolean(L, answers);
	if( lua_pcall( L, 4, 1, 0 ) != LUA_OK )
		throw std::runtime_error("Error while loading messages");
	std::set< std::string > res;
	lua_pushnil(L);
	while( lua_next(L, -2) )
	{
		res.insert( luaString( L ) );
	}
	return res;
}

std::string getTaskName()
{
	std::ifstream input("../task.txt");
	std::string line;
	std::getline( input, line );
	line = line.substr( 6 );
	return line;
}