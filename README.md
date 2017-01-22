# Soccer Players Detector 
## by Leticia Lorena Rodríguez

## About

Implementation of a soccer players video realtime detector written in C and Assembler Intel 64 bits.

Based on the paper: M. M. Naushad Ali, M. Abdullah-Al-Wadud and Seok-Lyong Lee,
*An Efficient Algorithm for Detection of Soccer Ball and Players*

Tags: Computer Vision - Image Processing - Soccer Players Detection - Realtime video processing

## Installation

For compile in Linux.
Prerequisites:

- OpenCV >= 2


Prerequisites:
```
[compiler] sudo apt-get install build-essential
[required] sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
```

Download from: 
```
http://opencv.org/downloads.html
```

Installation instructions: 

```
http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#building-opencv-from-source-using-cmake-using-the-command-line
```

- Yasm (assembler compiler)

```
sudo apt-get install yasm
```

## Compile

Makefile included.

```
make
```


## Run

To run included demo: 

```
./fplayers -f boca_banfield.avi -s 7
```

Other options:

```
Run: ./fplayers [-f <filename>] [-v] [-d] [-i] [-t] [-s <step>] [-h] [-r <process>] [-g <offset>] [-p <frame_from> <frame_to>]
Command line parameters:
	-f	<filename>	 Specifies video filename to process
	-v			 Verbose. Prints realtime information
	-d			 Dual. Shows two windows of the video.
	-i			 Add detail information for each filter
	-p			 Start the video in pause
	-s	<step>   	 Start Step (default 1)
	-r	<process>	 Filter rule (process), default 1
	-g	<offset>	 Color number offset to adjust in delete grass, default 0
	-c	<fr_from> <fr_to>	 Cut. Plays video only from fr_from to fr_to
	-t			 Test process
	-q			 Quick. Fast. Doesn't show video, no key waiting.
	-h			 Show this help

EOM
```

## Key Settings

While running, the detection window is interactive, you could use the keyboard for:

In Standard Mode:

- *ESC* Quit

- *0-9* Set step number

- *s* Takes a screenshot in black and white and save it in screenshot.bmp

- *c* Takes a screenshot in color and save it in screenshot\-color.bmp

- *Space Bar* Pause/Play video

In Test Mode: 

The frames pass each time a key is pressed. In test.log file is saved the key press in each frame. This could be use to mark frames as ok or not ok and take statistics about the implementation performance. 

## Techinical Details

Wiki: https://github.com/letyrodridc/soccer_players_detector/wiki

Document (in Spanish): https://github.com/letyrodridc/soccer_players_detector/blob/master/ORGA2-TP_FINAL_LRODRIGUEZ-INFORME-v2.pdf
