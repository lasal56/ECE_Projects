// ****************** Lab2.c ***************
// Program written by: put your names here
// Date Created: 1/18/2017 
// Last Modified: 12/31/2022 
#include "Lab2.h"
// Put your name and EID in the next two lines
char Name[] = "privacy reasons";
char EID[] = "edited for privacy";

#include <stdint.h>

// Inputs: x1,y1 is the first point
//         x2,y2 is the second point
// Output: calculate distance
// see UART window to see if you have square, Manhattan or ECE319K distance
// The input/output values will be displayed in the UART window
int32_t Distance(int32_t x1, int32_t y1, int32_t x2, int32_t y2){
// Replace this following line with your solution
	int32_t result; //use to return result (full word to match rest of in/out vals)
	
	//ECE319k distance
	
	int32_t x_diff, y_diff; //full word dec bc must match size of x1 y1 x2 y2
		
	//calc abs value of x distance
	if (x1 > x2 ) {	//calculating absolute value of diff, find larger and subtract the smaller from it
		x_diff = x1 -x2; //so.. if x1 larger, subtract x2
	}	else {
		x_diff = x2 -x1;	//if x2 larger, subtract x1
	}
	
	//calc abs value of y distance
		if (y1 > y2 ) {	//repeat same process as with x vals
		y_diff = y1 - y2;	
	}	else {
		y_diff = y2 - y1;
	}
	
	
	if (x_diff > y_diff) {	//319k distance takes whichever of x abs val diff and y abs val diff is larger, so compare
		result = x_diff;	//if x larger, it is result
	}	else {
		result = y_diff;	//if y larger, it is result
	}
		
		
	
  return result;
}

// Inputs: rect1 is x1,y1,w1,h1 the first rectangle
//         rect2 is x2,y2,w2,h2 the second rectangle
// Output: 1 if the rectangles overlap
//         0 if the rectances do not overlap
// Notes: x1 is rect1[0]  x2 is rect2[0]
//        y1 is rect1[1]  y2 is rect2[1]
//        w1 is rect1[2]  w2 is rect2[2]
//        h1 is rect1[3]  h2 is rect2[3]
// The input/output values will be displayed in the UART window
int32_t OverLap(int32_t rect1[4], int32_t rect2[4]){
// Replace this following line with your solution
 
//x2 >= x1 + w1
//x1 >= x2 + w2
//y2 >= y1 - h1
//y1 >= y2 - h2

	
	//start with x overlap
	if	(rect1[0] >= rect2[0] + rect2[2]) {		//initial x coordinate acts as offset of sorts, 
																						//add to width to orient rectangle properly in grid
		return 0;																// corner x coord of rec1 overlaps with rec2
	}
	if	(rect2[0] >= rect1[0] + rect1[2])	{
		return 0;																//corner x coord of rec2 overlaps with rec1
	}
	
	//take care of y overlap
	if	(rect1[1] >= rect2[1] + rect2[2]) {		//initial y coordinate acts as offset of sorts, 
																						//add to length to orient rectangle properly in grid
		return 0;																//corner y coord of rec1 overlaps somewhere on rec2
	}
	if	(rect2[1] >= rect1[1] + rect1[2])	{
		return 0;																//corner y coord of rec2 overlaps somewhere on rec1
	}
	return 1; 	//all overlap cases accounted for, so if 0 hasnt been returned there's no overlap
}

// do not edit this 2-D array
const char Hello[4][8] ={
   "Hello  ",    // language 0
   "\xADHola! ", // language 1
   "Ol\xA0    ", // language 2
   "All\x83   "  // language 3
};
// Hello[0][0] is 'H'
// Hello[0][1] is 'e'
// Hello[0][2] is 'l'
// Hello[0][3] is 'l'
// Hello[0][4] is 'o'
// Hello[1][0] is 0xAD
// Hello[1][1] is 'H'
// Hello[1][2] is 'o'
// Hello[1][3] is 'l'
// Hello[1][4] is 'a'
// Hello[1][5] is '!'
void LCD_OutChar(char letter);

// Print 7 characters of the hello message
// Inputs: language 0 to 3
// Output: none
// You should call LCD_OuChar exactly 7 times
void SayHello(uint32_t language){
// Replace this following line with your solution
for (int i = 0; i < 7; i++) {				//i incremented 7 times
	LCD_OutChar(Hello[language][i]);	//call main function 7 times 
}

}
