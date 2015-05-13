/** Structures specific to the back end of the NOC compiler
 *  ========================================================================
 *
 *  Last Modified: 4/22/14
 *  Contributor(s): Nicholas Otto
 */

#ifndef BACKENDSTRUCTURES_H
#define BACKENDSTRUCTURES_H

struct intermediate_representation {
	long pointerD; 	//stores number of pointers

	long *arrayD;	//stores array declaration info
	long arrayD_size; //length of arrayD section (not length of arrayD)
	
	char *dataD;		//array of data declarations
	long dataD_size;	//length of dataD section (not length of dataD)

};



#endif
