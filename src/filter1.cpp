#include "filter1.h"
#include "constants.h"
#include "timer.h"
#include "filterRunner.h"


void Filter1::filtersProcess() {
    Mat tempImageColor( _config.width, _config.height, CV_8UC3, cv::Scalar(0) );
    Mat tempImageBW( _config.width, _config.height, CV_8UC1, cv::Scalar(0) );
    Mat tempImageBW2( _config.width, _config.height, CV_8UC1, cv::Scalar(0) );
    Mat noImageBW( _config.width, _config.height, CV_8UC1, cv::Scalar(0) );

    // Salvo la imagen original
    unsigned char* tempColor = tempImageColor.data;
    unsigned char* tempBW = tempImageBW.data;
    unsigned char* tempBW2 = tempImageBW2.data;
    unsigned char* tempNoImageBW = noImageBW.data;

    int step = 1;

    /* 1 */
    bool end = setInputOutput(step, _input, tempBW);
    removeGrass();

    if (end) return;
    
    /* 2 */
    end = setInputOutput(step, tempBW, tempBW2);
    filterDilatation();
 

    end = setInputOutput(step, tempBW2, tempBW);
    filterDilatation();
  
    end = setInputOutput(step, tempBW, tempBW2);
    filterDilatation();
    
    
    end = setInputOutput(step, tempBW2, tempBW);
    filterDilatation();

    end = setInputOutput(step, tempBW, tempBW2);
    filterDilatation();
    
    step++;

    end = setInputOutput(step++, tempBW2, tempBW);
    filterDilatation(); 

    if (end) return;

    
    /* 3 */
    end = setInputOutput(step++, tempBW, tempBW2);
    regionLabeling();

    if (end) return;
    
    /* 4 */
    end = setInputOutput(step++, tempBW2, tempBW);
    bool noImg = filterRegions();


    if (end) return;

    if (!noImg) {
        /* 5 */
        end = setInputOutput(step++, tempBW, tempBW2);
        convertBW();

          /* 7 */
        if (end) return;
        
        /* 6 */
        end = setInputOutput(step++, tempBW2, tempBW);
        filterSobel();

        if (end) return;
        
    
    }

    /* 7 */
   setInputOutput(100, _input, tempBW);
   filterMarkBorders(); 
    
       
}