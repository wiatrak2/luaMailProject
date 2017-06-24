#ifndef receiver_h
#define receiver_h 1

#include <lua.hpp>
#include <string>
#include <vector>
#include <set>
#include <fstream>
#include <iostream>

void addPoints( std::set< std::string >& students, std::string const& taskName, std::string const& pathToCsv );
std::set< std::string > receiveMails(std::string& mailAddress, std::string& password, bool answers );
void getPathToFiles( std::string& pathToTask, std::string& pathToCsv );
std::string getTaskName( std::string const& pathToTask );

#endif