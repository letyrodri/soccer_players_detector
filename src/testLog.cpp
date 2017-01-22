#include "testLog.h"
#include "constants.h"

TestLog::TestLog() {
	
}

TestLog::~TestLog() {
}

void TestLog::init(const char* filename) {
	_logFile.open (filename);
}


void TestLog::end() {
	_logFile.close();

}

void TestLog::addResult(long frame, char result) {
	std::string frameNbr;
    std::stringstream strstream;
    strstream << frame;
    strstream >> frameNbr;
  	strstream.flush();

  
  	
  	_logFile << frameNbr << "," << result << endl;
 	_logFile.flush();
}

