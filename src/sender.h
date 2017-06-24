#ifndef sender_h
#define sender_h 1

#include "receiver.h"

std::vector< std::string > getStudentsMails( std::string const& pathToCsv );
void sendMail( std::string& mail, std::string& mailAddress, std::string& password );

#endif