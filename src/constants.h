#ifndef _MYLIB_CONSTANTS_H_
#define _MYLIB_CONSTANTS_H_ 

#include <string>   
using namespace std;


typedef struct __attribute__((packed)) { 
	unsigned char color;
	int qty;
} region_data_type ;


typedef struct __attribute__((packed)) {
	int from;
	int to;
} t_color_range;

extern "C" void remove_grass (unsigned char *src, int m, int n, unsigned char *dst, unsigned short int offset);
extern "C" void dilatation (unsigned char *src, int m, int n, unsigned char *dst);
extern "C" void convert_bw (unsigned char *src, int m, int n, unsigned char *dst);
extern "C" void region_labeling (unsigned char *src, int m, int n, unsigned char *dst, unsigned char *equiv);
extern "C" void region_metrics(unsigned char *src, int m, int n, unsigned char *dst, unsigned int *equiv, region_data_type *orden);
extern "C" void filter_regions(unsigned char *src, int m, int n, unsigned char *dst, region_data_type *orden, t_color_range *range );
extern "C" void sobel (unsigned char *src, int m, int n, unsigned char *dst);
extern "C" void mark_borders_in_image(unsigned char *src, int m, int n, unsigned char *dst, unsigned char *borders);
extern "C" void copy_image (unsigned char *src, int m, int n, unsigned char *dst, int color);

const string VIDEO_FOLDER = "videos/";
const int NO_IMAGE = 7;
const int FROM_FRAME = 200;
const int TO_FRAME = 13000;


typedef struct { 
	int step;
} t_process_cfg;

struct t_config {
	string filename;
	string videoDir;
	int width;
	int height;
	bool verbose;
	bool dual;
	bool filter_info;
	bool test_mode;
	bool show_help;
	int filter_rule;
	bool pause;
	int grass_offset;
	int part_start, part_end;
	bool quick;
	t_process_cfg process;
};

struct t_process_result {
	bool isColor;
	long totalTime;
	string steps;
};


#endif