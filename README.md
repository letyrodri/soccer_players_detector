# Soccer Players Detector by Leticia Lorena Rodríguez

## About

Implementation of a soccer players video realtime detector written in C and Assembler Intel 64 bits.

Based on the paper:

Tags: Computer Vision - Image Processing - Soccer Players Detection - Realtime video processing

## Installation

For compile in Linux.
Prerequisites:

- OpenCV >= 2
Download from: http://opencv.org/downloads.html
Installation instructions: http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#building-opencv-from-source-using-cmake-using-the-command-line

- Yasm (assembler compiler)

sudo apt-get install yasm


## Run

`
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
`

## Techinical Details
