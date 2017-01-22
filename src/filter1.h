#ifndef __Filter1_H__
#define __Filter1_H__
#include <iostream> // for standard I/O
#include <string>   // for strings
#include <iomanip>  // for controlling float print precision
#include <sstream>  // string to number conversion
#include <opencv2/core/core.hpp>        // Basic OpenCV structures (cv::Mat, Scalar)
#include <opencv2/imgproc/imgproc.hpp>  // Gaussian Blur
#include <opencv2/highgui/highgui.hpp>  // OpenCV window I/O
#include "opencv2/opencv.hpp"

#include <fstream>
#include <sys/time.h>
#include "constants.h"
#include "filterRunner.h"
// 720 x 1280
using namespace std;
using namespace cv;

/* 
Organizacion del Computador II
TP Final - Leticia Rodriguez
Abril 2016

Soccer Players Finder

Implementa un secuencia de filtros.

*/


class Filter1 : public FilterRunner {

	public:
		Filter1(t_config& config, unsigned char* input, unsigned char* outputBW, unsigned char* outputColor) :
			FilterRunner(config, input, outputBW, outputColor) {};
		void filtersProcess();
	private:


		



};


#endif