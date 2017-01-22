/* 
Organizacion del Computador II
TP Final - Leticia Rodriguez
Abril 2016

Soccer Players Finder
Clase principal - MAIN
*/

#include <iostream> // for standard I/O
#include <string>   // for strings
#include <iomanip>  // for controlling float print precision
#include <sstream>  // string to number conversion
#include <opencv2/core/core.hpp>        
#include <opencv2/highgui/highgui.hpp>  // OpenCV window I/O
#include <fstream>
#include <sys/time.h>
#include "constants.h"
#include "videoProcessor.h"

// 720 x 1280
using namespace std;
using namespace cv;



// Prints command line use information
void printUse() {
	cout << "TP Final Organización del Computador II (A. Furfaro)" << endl;
	cout << "'Soccer Players Finder' by Leticia L. Rodríguez (@letyrodri)" << endl << endl;
	cout << "Universidad de Buenos Aires (UBA)"<< endl;
	cout << "Facultad de Ciencias Exactas y Naturales (FCEN)"<< endl;
	cout << "April 2016" << endl << endl;
	cout << "Run: ./fplayers [-f <filename>] [-v] [-d] [-i] [-t] [-s <step>] [-h] [-r <process>] [-g <offset>]"; 
	cout << " [-p <frame_from> <frame_to>]" << endl;
	cout << "Command line parameters:" << endl;
	cout << "\t-f\t<filename>\t Specifies video filename to process" << endl; 
	cout << "\t-v\t\t\t Verbose. Prints realtime information" << endl; 
	cout << "\t-d\t\t\t Dual. Shows two windows of the video." << endl; 
	cout << "\t-i\t\t\t Add detail information for each filter" << endl; 
	cout << "\t-p\t\t\t Start the video in pause" << endl; 
	cout << "\t-s\t<step>   \t Start Step (default 1)" << endl;
	cout << "\t-r\t<process>\t Filter rule (process), default 1" << endl;
	cout << "\t-g\t<offset>\t Color number offset to adjust in delete grass, default 0" << endl;
	cout << "\t-c\t<fr_from> <fr_to>\t Cut. Plays video only from fr_from to fr_to" << endl;
	cout << "\t-t\t\t\t Test process" << endl; 
	cout << "\t-q\t\t\t Quick. Fast. Doesn't show video, no key waiting." << endl;
	cout << "\t-h\t\t\t Show this help" << endl;

	cout << endl;
	cout << "EOM" << endl;
}

// Prints invalid option message
bool invalidOption() {
	cout << "Invalid parameters" << endl << endl;
	printUse();
	return false;
}

// Gets and validates parameters from commandline
// Returns: 1: OK 0: No OK - If it OK , config contains parameters data.
bool getParameters(int argc, char *argv[], t_config& config) {
	if (argc == 1) {
		return invalidOption();
	}

	config.videoDir = VIDEO_FOLDER;
	config.filter_info = false;
	config.verbose = false;
	config.process.step = 1;
	config.show_help = false;
	config.filter_rule = 1;
	config.pause = false;
	config.grass_offset = 31;
	config.part_start = 0;
	config.part_end = 0;
	config.quick = false;
	string validOptions = "-f -v -d -i -t -s -h -r -g -p -c -q ";

	int i=1;
	while (i < argc) {

		 string option(argv[i]);

		 if (validOptions.find(option) != string::npos) {
			if (option.compare("-f") == 0) {
				string value(argv[i+1]);
				config.filename = value;
				i++;
			} else {
				if (option.compare("-v") == 0) {
					config.verbose = true;
				} else {
					if (option.compare("-d") == 0) {
						config.dual = true;
					} else {
						if (option.compare("-i") == 0) {
							config.filter_info = true;
						} else {
							if (option.compare("-t") == 0) {
							config.test_mode = true;
							config.process.step = 9;
							} else {
								if (option.compare("-h") == 0) {
								config.show_help = true;
								} else {
									if (option.compare("-s") == 0) {
									string value(argv[i+1]);
									config.process.step = atoi(value.c_str());
									i++;
									} else {
										if (option.compare("-r") == 0) {
										string value(argv[i+1]);
										config.filter_rule = atoi(value.c_str());
										i++;
										} else {
											if (option.compare("-g") == 0) {
												string value(argv[i+1]);
												config.grass_offset = atoi(value.c_str());
												cout << config.grass_offset << endl;
												i++;
											} else {
												if (option.compare("-c") == 0) {
												string value(argv[i+1]);
												config.part_start = atoi(value.c_str());
												i++;
												string value2(argv[i+1]);
												config.part_end = atoi(value2.c_str());
												i++;
												} else {
													if (option.compare("-p") == 0) {
														config.pause = true;
													} else {
														if (option.compare("-q") == 0) {
															config.quick = true;
														}	
													}
												}	
											}	
										}	
									}
								}	
							}
						}
					}	
				}
			}
		} else {
			return invalidOption();
		}
		i++;

	}

	return true;

}



// Main process - The magic 
void process(t_config& config) {

	if (config.show_help) {
		printUse();	
	} else {
		cout << "Start processing videofile: " << config.filename << endl;
		cout << "Step: " << config.process.step << endl;

		VideoProcessor vp(config);

		vp.start();
	}

}

int main(int argc, char *argv[]) {	
	t_config config;

	bool ok = getParameters(argc, argv, config);

		
	if (ok) {
		// Parameters OK - Go on - Nothing to see here
 		process(config);
 	}

    return 0;
}

