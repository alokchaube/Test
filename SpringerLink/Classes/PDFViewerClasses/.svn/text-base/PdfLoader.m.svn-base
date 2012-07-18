//
//  PdfLoader.m
//  SRPS
//
//  Created by Subhash on 17/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PdfLoader.h"


@implementation PdfLoader


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
      /*  if(isPortrait) {
            
            indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,70,70)];
            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            indicatorView.hidesWhenStopped = YES;
            [self addSubview:indicatorView];
            [indicatorView startAnimating];
        }*/
    }
    return self;
}


- (void) chnageOnOrientationChange {
    indicatorView.frame = CGRectMake((self.frame.size.width-40)/2,(self.frame.size.height-70)/2,70,70);
    
}

- (void)chnageOnOrientationChangeLandScape
{
    indicatorView.frame = CGRectMake(480.0,300.0,70,70);
    
}

- (void)setLoaderHidden:(BOOL)hide {

	self.hidden = hide;
	if(hide) {
		[indicatorView stopAnimating];	
	}else {
		[indicatorView startAnimating];
	}

}



@end
