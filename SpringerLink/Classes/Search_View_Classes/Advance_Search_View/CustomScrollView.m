//
//  CustomScrollView.m
//  SpringerLink
//
//  Created by kiwitech kiwitech on 29/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView
@synthesize customDelegate = _customDelegate;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event  {	
    
	if (!self.dragging) {
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	}		
    
    if(_customDelegate && [_customDelegate respondsToSelector:@selector(performTouchEndTasks)]) {
        [_customDelegate performTouchEndTasks];
    }
    
	[super touchesEnded: touches withEvent: event];
}

@end
