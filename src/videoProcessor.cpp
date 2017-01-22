#include "videoProcessor.h"
#include "filterRunner.h"
#include "testLog.h"
#include "constants.h"
#include "timer.h"
#include "filter1.h"

VideoProcessor::VideoProcessor(t_config& config) {
	_config = config;
}

const char* VideoProcessor::createWindow(const Size & refS, const char* name) {
	
    const char* WIN_RF = name;

    namedWindow(WIN_RF, CV_WINDOW_NORMAL);  
    
    return WIN_RF;

}

void VideoProcessor::display(string& text) {
	if (_config.verbose)
		cout << text;
}

void VideoProcessor::display(const char* text) {
    if (_config.verbose)
        cout << text;
}



void VideoProcessor::displayLn(string& text) {
	if (_config.verbose)
		cout << text << endl;
        cout.flush();
}

void VideoProcessor::displayLn(long numberLong) {
    std::string number;
    std::stringstream strstream;
    strstream << numberLong;
    strstream >> number;
    displayLn(number);
}



t_process_result VideoProcessor::processImg(unsigned char* input, unsigned char* outputBW, unsigned char* outputColor) {
    FilterRunner* filters;
    Filter1 filter1(_config, input, outputBW, outputColor) ;
    
    switch (_config.filter_rule) {
        case 1:
            filters = &filter1;
            break;
        /* se pueden agregar mas procesos */
    } 
    filters->runFilters();
    return filters->getRunResult();
    
}

int VideoProcessor::start() {
	const string sourceReference = _config.videoDir.append(_config.filename);
    
    string text = "Video: ";
    text += sourceReference;
    text += "\n";
    
    display(text);
		

    VideoCapture captRefrnc(sourceReference);

    if (!captRefrnc.isOpened())
    {
        cout  << "Could not open reference " << sourceReference << endl;
        return -1;
    }


    Size refS = Size((int) captRefrnc.get(CV_CAP_PROP_FRAME_WIDTH),
                    (int) captRefrnc.get(CV_CAP_PROP_FRAME_HEIGHT));


   	const char* WIN_RF = createWindow(refS, "Soccer Player Finder");

    const char* WIN_RF_ORIG;
    if (_config.dual) {
        WIN_RF_ORIG = createWindow(refS, "Original Soccer Video");

    }

  	float fps = captRefrnc.get(CV_CAP_PROP_FPS);
    long totalFrames = captRefrnc.get(CV_CAP_PROP_FRAME_COUNT);

    Mat image;
    captRefrnc >> image;

    int height = image.rows;
    int width = image.cols;

    _config.width = width;
    _config.height = height;

    Mat resultBW( height, width, CV_8UC1, cv::Scalar(0) );
    Mat resultColor( height, width, CV_8UC3, cv::Scalar(0) );
    
    unsigned char* input; 
    unsigned char* outputBW;         
    unsigned char* outputColor;
        
    
  	float delay = (1/fps * 1000);
    float delta = 0;
    string lastProcess = "";

  	char c;
    int frameCount = 1;

 	bool end = false;
    bool pause=false;
    bool first = true;
    long totalTime = 20;

    TestLog test;

    if (_config.test_mode) {
        test.init("test.log");
    }


    while(!end && !image.empty()) //Show the image captured in the window and repeat
    {

        if (_config.part_end > 0 && _config.part_end <= frameCount) {
            end = true;
        }

        if (first && frameCount == _config.part_start) {
            pause = _config.pause;
            first = false;
        }

        if ((frameCount >= _config.part_start && frameCount <= _config.part_end) 
            || _config.part_end == 0) {

            if (!pause) {
                display("Total Time (ms):");
                displayLn(totalTime);
                display("process:");
                displayLn(lastProcess);


                display("Frames Qty: ");
                displayLn(totalFrames);
                display("FPS (frames): ");
                displayLn(fps);

                display("Frames each (ms): ");
                displayLn(delay);

                display("Increse Time: ");
                displayLn(delta);


                display("# Frame: ");
                displayLn(frameCount);

            }

            input = image.data;
            outputBW = resultBW.data;
            outputColor = resultColor.data;

        
        	t_process_result result = processImg(input, outputBW, outputColor);
            bool color = result.isColor;
            totalTime = result.totalTime;
            lastProcess = result.steps;


            if (!_config.quick) {
                if (color) { 
          		    imshow(WIN_RF, resultColor);
            	} else {
                    imshow(WIN_RF, resultBW);
                }

                if (_config.dual) {
                    imshow(WIN_RF_ORIG, image);
                }

                if (!_config.test_mode) {
               	    c = (char) cvWaitKey(delay-totalTime+delta);
                } else {
                    c = (char) cvWaitKey();
                }
            	// Press esc key
            	

                switch (c) {
                    
                    case 115: /* s */
                        imwrite("screenshot.bmp", resultBW);    
                        break;

                    case 99: /* c */    
                        imwrite("screenshot-color.bmp", resultColor);    
                        break;

                }

                if (!_config.test_mode) {
                    switch (c) {
                    case 27: /*ESC*/
                        end = true;
                        break;    
                    case 48: /*0 a 9*/
                    case 49:
                    case 50:
                    case 51:
                    case 52:
                    case 53:
                    case 54:
                    case 55:
                    case 56:
                    case 57:
                    case 58:
                    case 59:
                        _config.process.step = c - 48;
                        break;
                    case 43: /* incrementa velocidad + */
                        delta = delta - 10;
                        break;
                    case 45: /* decrece velocidad - */
                        delta = delta + 10;
                        break;   
                    case 32: /* barra espaciadora*/
                        pause = !pause;
                        _config.pause = pause;
                        break; 
                    }            
                } else {
                    // It's test mode
                    switch (c) {
                        case 27:
                            test.end();
                            end = true;
                        break;
                        case 48:
                        case 49:
                        case 50:
                        case 51:
                        case 52:
                            test.addResult(frameCount-1, c);
                        break;
                    }           
                }
            }
        }
        if (!pause) {
            captRefrnc >> image;
            frameCount++;
        }
        
    }

    captRefrnc.release();
    return 0;

}
