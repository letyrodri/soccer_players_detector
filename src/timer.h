#ifndef __TIMER_H__
#define __TIMER_H__
#include <iostream> // for standard I/O
#include <string>   // for strings
#include <iomanip>  // for controlling float print precision
#include <sstream>  // string to number conversion


#include <sys/time.h>
#include "constants.h"
// 720 x 1280
using namespace std;

/* 
Organizacion del Computador II
TP Final - Leticia Rodriguez
Abril 2016

Soccer Players Finder

Permite tomar tiempos
*/


class Timer {

	public:
		Timer();
		void start();
		void stop();
		long getTime();

	private:
		struct timeval _startTime, _endTime;
		long _totalTime;



};


#endif