#ifndef __VPROCESSOR_H__
#define __VPROCESSOR_H__
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
// 720 x 1280
using namespace std;
using namespace cv;

/* 
Organizacion del Computador II
TP Final - Leticia Rodriguez
Abril 2016

Soccer Players Finder

Lee y muestra el video acorde a los parametros especificados.
Separa el video en frames y por cada uno, aplica el Proceso.
*/

class VideoProcessor {

	public:
		VideoProcessor(t_config & config);
		int start();
		
	private:
		const char* createWindow(const Size & refS, const char* name);
		void display(string& text);
		void displayLn(string& text);
		void displayLn(long numberLong) ;
		void display(const char* text);

		t_process_result processImg(unsigned char* input, unsigned char* outputBW, unsigned char* outputColor);
	

		t_config _config;
		




};


#endif