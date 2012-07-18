//
//  FindControllerOnDifferentViewController.m
//  PainImaging
//
//  Created by Tarun on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FindControllerOnDifferentViewController.h"

@implementation FindControllerOnDifferentViewController

//find an object of particular inside a array's of objects
+ (id)findClass:(id)forClass 
        onViews:(NSArray *)onViews {
    
	//check whether forClass variable is not belong to NSString class if yes then fetch the name of class From the string
    Class class = ([forClass isKindOfClass:[NSString class]]) ? NSClassFromString(forClass) : forClass;
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@", class];   
    NSArray *retArray = [onViews filteredArrayUsingPredicate:predicate];
    id controller = nil;
    
	if([retArray count] > 0)
		controller = [retArray objectAtIndex:0];
	return controller;
}
@end
