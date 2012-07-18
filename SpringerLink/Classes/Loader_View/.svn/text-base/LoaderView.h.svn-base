//
//  LoaderView.h
//  SpringerLink
//
//  Created by Prakash Raj on 11/04/12.
//  Copyright (c) 2012 __kiwitech__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

/** 
 * Displays a simple loader view containing a progress indicator and one optional label for short message.
 */

@interface LoaderView : UIView<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    UIView        *_overlayView;

}
/** 
 * Display the HUD in loader view. 
 */
- (void)showLoader;

/** 
 * Hide the HUD and remove loader view from superview . 
 */
- (void)hideLoader;
@end
