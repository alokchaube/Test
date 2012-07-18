//
//  PdfLoader.h
//  SRPS
//
//  Created by Subhash on 17/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 
    This class is used to display activity indicator for PDF.

*/

#import <UIKit/UIKit.h>


@interface PdfLoader : UIView {
	
    UIActivityIndicatorView *indicatorView;
    
    
}


- (void)chnageOnOrientationChange;
- (void)chnageOnOrientationChangeLandScape;
- (void)setLoaderHidden:(BOOL)hide; 
@end
