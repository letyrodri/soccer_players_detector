CC = g++
ASM = yasm
DBG = gdb
CFLAGS = -ggdb  -pedantic -m64
ASMFLAGS = -f elf64 -g dwarf2
OPENCV_LIB = `  pkg-config --cflags  --libs opencv `


CPP_FILES := $(wildcard src/*.cpp)
ASM_FILES := $(wildcard src/*.asm)

BIN = fplayers
BIN_DIR = bin
SRC_DIR = src
OBJ_DIR = obj


OBJS = $(OBJ_DIR)/filter1.o $(OBJ_DIR)/region_metrics.o $(OBJ_DIR)/filter_regions.o  $(OBJ_DIR)/main.o $(OBJ_DIR)/filterRunner.o $(OBJ_DIR)/testLog.o $(OBJ_DIR)/timer.o $(OBJ_DIR)/mark_borders_in_image.o $(OBJ_DIR)/convert_bw.o $(OBJ_DIR)/region_labeling.o  $(OBJ_DIR)/remove_grass.o  $(OBJ_DIR)/copy_image.o $(OBJ_DIR)/sobel.o $(OBJ_DIR)/dilatation.o  $(OBJ_DIR)/videoProcessor.o

 		
.PHONY: all clean

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(OPENCV_LIB) 

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CFLAGS)  -c -o $@ $< -lm


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM) $(ASMFLAGS)  -o $@ $<

all: $(BIN)

clean:
	rm -f $(OBJS)
	rm -f ./$(BIN)
	rm -f $(BIN_DIR)/$(BIN)
