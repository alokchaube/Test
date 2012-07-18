//
//  ThumbnailView.m
//  SpringerLink
//
//  Created by prakash raj on 11/06/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView
@synthesize thumbImageView = _thumbImageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
        UIImageView *_topImageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(0, 0, frame.size.width, 50)];
        [_topImageView setImage:[UIImage imageNamed:@"bar_top_right_ipad.png"]];
        [self addSubview:_topImageView];
        
         _thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 105, 435, 568)];
        [self addSubview:_thumbImageView];
    }
    return self;
}

- (void)dealloc {
    _thumbImageView = nil;
}
@end
