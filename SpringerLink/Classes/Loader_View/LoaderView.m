//
//  LoaderView.m
//  SpringerLink
//
//  Created by Prakash Raj on 11/04/12.
//  Copyright (c) 2012 __kiwitech__. All rights reserved.
//

#import "LoaderView.h"

@implementation LoaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlpha:1.0];
        
        _overlayView = [[UIView alloc] initWithFrame:self.bounds];
        [_overlayView setBackgroundColor:[UIColor grayColor]];
        [_overlayView setAlpha:.5];
    }

    return self;
}

/** 
 * Display the HUD in loader view. 
 */
- (void)showLoader {
     HUD = [[MBProgressHUD alloc] initWithView:self]; //creat MBProgressHUD object
    [self addSubview:_overlayView];
     [self addSubview:HUD];
     HUD.delegate = self;
     HUD.labelText = @"Loading";
     [HUD show:YES];  // show  HUD in loder view.
}

/** 
 * Hide the HUD and remove loader view from superview . 
 */
- (void)hideLoader {

    [HUD hide:YES];  // hide the HUD from loder view.
    [_overlayView removeFromSuperview];
    [self removeFromSuperview];

}



@end
