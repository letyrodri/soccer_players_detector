#include "timer.h"
#include "constants.h"

Timer::Timer() {

}

void Timer::start() {
	gettimeofday(&_startTime, 0);
}

void Timer::stop() {
	gettimeofday(&_endTime, 0);
}

long Timer::getTime() {
	long seconds  = _endTime.tv_sec  - _startTime.tv_sec;
    long useconds = _endTime.tv_usec - _startTime.tv_usec;
	 
	return ((seconds) * 1000 + useconds/1000.0) + 0.5;
}