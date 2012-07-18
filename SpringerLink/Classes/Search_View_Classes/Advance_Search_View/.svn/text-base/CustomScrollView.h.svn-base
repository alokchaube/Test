//
//  CustomScrollView.h
//  SpringerLink
//
//  Created by kiwitech kiwitech on 29/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/* 
 CustomScrollView is subclass of UIScrollView, made to detect the touch within a scroll view.
 the protocol is returning a method when touch is detected, and we can perform our touct tasks here.
 */

#import <UIKit/UIKit.h>
#import "ProtocolDecleration.h"

@interface CustomScrollView : UIScrollView {
    __unsafe_unretained id <CustomScrollViewDelegate> _customDelegate;
}

@property (nonatomic,assign) id <CustomScrollViewDelegate> customDelegate;
@end
