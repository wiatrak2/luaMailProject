#include <lua.hpp>
#include <string>
#include <vector>
#include <set>
#include <fstream>
#include <iostream>
void addPoints( std::set< std::string >& students, std::string const& taskName );
std::set< std::string > receiveMails(std::string mailAddress, std::string password, bool answers);
std::string getTaskName();