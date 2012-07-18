//
//  Constant.h
//  SpringerLink
//
//  Created by Prakash Raj on 11/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//



#define kPageLimit       10                              //Page limit: How many item will shown at a time.

//To on/off nslog
#define NSLog if(1)NSLog	
#define ENSLog(classPointer, functionPointer) NSLog(@"%@ -> Enter -> %@",[classPointer class], NSStringFromSelector(functionPointer));
#define ExNSLog(classPointer, functionPointer) NSLog(@"%@ -> Exit -> %@",[classPointer class], NSStringFromSelector(functionPointer));

#define isIphone !isIpad
BOOL isIpad;

typedef enum {
    
    SortByAuthor = 0,
    SortByDate,
    SortByRelevance,
    SortByTitle
} SortBy;
