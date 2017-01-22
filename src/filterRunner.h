#ifndef __FRUNNER_H__
#define __FRUNNER_H__
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

Clase abstracta. Puede ser extendida para implementar procesos en distinta secuencias.
Contiene metodos que trabajan sobre una imagen y aplican un filtro o secuencia de filtros.

*/

class FilterRunner {

	public:
		friend class Filter1;
		friend class Filter2;

		FilterRunner(t_config& config, unsigned char* input, unsigned char* outputBW, unsigned char* outputColor);
		void runFilters(); 
		t_process_result getRunResult();
		

	private:
		t_config _config;

		unsigned char* _input;
		unsigned char* _outputBW; 
		unsigned char* _outputColor;
		
		unsigned char* _tmpInput;
		unsigned char* _tmpOutput;
		

		t_process_result _run_result;
		
		bool setInputOutput(int step, unsigned char* temp, unsigned char* temp2);
		void displayFilterInfo(string& filter_name, region_data_type* region_data, int size);

		virtual void filtersProcess(){};
		
		bool filterRegions();
		void removeGrass();
		void regionLabeling();
		void filterSobel() ;
		void filterMarkBorders();
		void filterDilatation();
		void convertBW();

		



};


#endif