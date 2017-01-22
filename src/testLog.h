#ifndef __TESTLOG_H__
#define __TESTLOG_H__
#include <iostream> // for standard I/O
#include <string>   // for strings
#include <iomanip>  // for controlling float print precision
#include <sstream>  // string to number conversion
#include "constants.h"
#include <fstream>
// 720 x 1280
using namespace std;

/* 
Organizacion del Computador II
TP Final - Leticia Rodriguez
Abril 2016

Soccer Players Finder

Abre un archivo y permite escribir en el informacion de logueo.
*/

class TestLog {

	public:
		TestLog();
		~TestLog();
		void init(const char* filename);
		void addResult(long frame, char result);
		void end();

	private:
		ofstream _logFile;
  

};


#endif