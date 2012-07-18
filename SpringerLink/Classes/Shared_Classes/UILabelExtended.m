//
//  UILabelExtended.m
//  Elsevier
//
//  Created by Tarun on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UILabelExtended.h"


@implementation UILabelExtended
@synthesize selector,customDelegate;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.selector)
        if([self.customDelegate respondsToSelector:self.selector]) {

  #pragma clang diagnostic ignored "-Warc-performSelector-leaks" 
            [self.customDelegate performSelector:self.selector withObject:self];
            return;
        }
}

- (void)dealloc {
	self.customDelegate = nil;
    self.selector = NULL;
}
@end


@implementation UILabel(UILabelCategory)

- (void)setHeightOfLabel {
    UILabel* label = self;
    
	//get the height of label content
	CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 99999) lineBreakMode:UILineBreakModeWordWrap].height;
	//set the frame according to calculated height
	CGRect frame = label.frame;
    if([label.text length] > 0) {
        
        frame.size.height = height;
    } 
    else {
        frame.size.height = 0;
    }
	label.frame = frame;
}


- (void)setWidthOfLabel {
    
	UILabel* label = self;
    
		//get the height of label content
	CGFloat width = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(99999, label.bounds.size.height) lineBreakMode:UILineBreakModeWordWrap].width;
		//set the frame according to calculated height
	CGRect frame = label.frame;
    if([label.text length] > 0) {
        
        frame.size.width = width+5;
    } 
    else {
        frame.size.width = 0;
    }
	label.frame = frame;
}

- (void)setHeightOfLabelWithMaxHeight:(float)maxHeight {
    UILabel* label = self;
    
	//get the height of label content
	CGFloat height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, maxHeight) lineBreakMode:UILineBreakModeWordWrap].height;
	//set the frame according to calculated height
	CGRect frame = label.frame;
    if([label.text length] > 0) {
        if (height > maxHeight) {
			frame.size.height = maxHeight;
		}
		else {
			frame.size.height = height;
		}
        
    } 
    else {
        frame.size.height = 0;
    }
	label.frame = frame;
}

- (void)setWidthOfLabelWithMaxWidth:(float)maxWidth  {
	UILabel* label = self;
    
	//get the height of label content
	CGFloat width = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(99999, label.bounds.size.height) lineBreakMode:UILineBreakModeWordWrap].width;
	//set the frame according to calculated height
	CGRect frame = label.frame;
    if([label.text length] > 0) {
		
        if (width > maxWidth) {
			frame.size.width = maxWidth;
		}
		else {
			frame.size.width = width;
		}
    } 
    else {
        frame.size.width = 0;
    }
	label.frame = frame;
}
@end