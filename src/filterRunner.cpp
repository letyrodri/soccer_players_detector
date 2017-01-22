#include "filterRunner.h"
#include "constants.h"
#include "timer.h"

FilterRunner::FilterRunner(t_config& config, unsigned char* input, unsigned char* outputBW, unsigned char* outputColor) {
    _config = config;
    _input = input;
    _outputBW = outputBW;
    _outputColor = outputColor;
}


void FilterRunner::displayFilterInfo(string& filter_name, region_data_type* region_data, int size) {
    bool notZero = true;
    int regionsQty = 0;

    if (_config.filter_info && !_config.pause) {
        cout << filter_name <<" information:" << endl;
        for (int i=0 ; i < size && notZero; i++) {
            if (region_data[i].qty > 0) {
                cout << i << ',' << (int) (region_data[i].color) << ", " << region_data[i].qty << " | ";
                regionsQty++;
            } else {
                notZero = false;
            }
        }
        cout << endl;
        
        cout << "Regions Qty: " << regionsQty << endl;

        cout.flush();
    }
}

void FilterRunner::convertBW() {
    _run_result.steps += "convert_bw ";
    convert_bw(_tmpInput,  _config.width, _config.height, _tmpOutput);

}
void FilterRunner::filterSobel() {
    _run_result.steps += "sobel ";
   sobel(_tmpInput,  _config.width, _config.height, _tmpOutput);
}

void FilterRunner::filterMarkBorders() {
    _run_result.steps += "markBordersInImage ";
    _run_result.isColor = true;

    mark_borders_in_image(_tmpInput, _config.width, _config.height, _outputColor, _tmpOutput);
}



bool FilterRunner::filterRegions() {
    _run_result.steps += "filterRegions ";
    _run_result.isColor = false;
 
    bool noImage = false;

    region_data_type* region_data = new region_data_type[256];

    for (int i=0 ; i < 256; i++) {
        region_data[i].color =0;
        region_data[i].qty = 0;
    }

    unsigned int* tmp = new unsigned int[256];

    for (int i=0 ; i < 256; i++) {
        tmp[i] =0;
    }
    

    region_metrics(_tmpInput,  _config.width, _config.height, _tmpOutput, tmp, region_data);

    string filter_name = "RegionMetrics";
    displayFilterInfo(filter_name, region_data, 256);


    bool notZero = true;
    int i=0;
    
    for (; i < 256 && notZero; i++) {
        if (region_data[i].qty == 0) {
            notZero = false;
        }
    }

    if (i < NO_IMAGE) {
        if (_config.filter_info && !_config.pause)
            cout << "no image" << endl;
        
        Mat noImageBW(  _config.width, _config.height, CV_8UC1, cv::Scalar(0) );

        unsigned char* tempNoImageBW = noImageBW.data;

        copy_image(tempNoImageBW,  _config.width, _config.height, _tmpOutput, 0);
        
        noImage = true;
    
    } else {
    

        t_color_range*  range = new t_color_range;

        range->from = FROM_FRAME;
        range->to = TO_FRAME;


        filter_regions(_tmpInput,  _config.width, _config.height, _tmpOutput, region_data, range);

        delete range;
    }

    delete[] region_data;
    delete[] tmp;
    
    return noImage;

}

void FilterRunner::filterDilatation() {
    _run_result.steps += "dilatation ";
    _run_result.isColor = false;
    
    dilatation(_tmpInput,  _config.width, _config.height, _tmpOutput);
    
}    

// Boca Banfield 31

void FilterRunner::removeGrass() {
    _run_result.steps += "removeGrass ";
    _run_result.isColor = false;
    remove_grass(_tmpInput,  _config.width, _config.height, _tmpOutput, _config.grass_offset);
}

void FilterRunner::regionLabeling() {
    unsigned char* equivalences = new unsigned char[256];

    for (int i=0 ; i < 256; i++) {
        equivalences[i] =0;
    }

    _run_result.steps += "region_labeling ";

    region_labeling(_tmpInput, _config.width, _config.height, _tmpOutput, equivalences);
    delete[] equivalences;
}


bool FilterRunner::setInputOutput(int step,   unsigned char* temp, unsigned char* temp2) {
    if (step == _config.process.step) {
        _tmpInput = temp; 
        _tmpOutput = _outputBW;
        return true;

    } else {
        _tmpInput = temp; 
        _tmpOutput = temp2;
        
    }
    return false;
}

t_process_result FilterRunner::getRunResult() {
    return _run_result;
}

void FilterRunner::runFilters() {
    
    _run_result.isColor = false;
    _run_result.totalTime = 0;
    _run_result.steps = "";


    Timer runFiltersTimer;
    runFiltersTimer.start();

    
    filtersProcess();

    
    runFiltersTimer.stop();
    
    _run_result.totalTime  = runFiltersTimer.getTime();


}

