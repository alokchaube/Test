//
//  PopWebViewController.h
//  Springer
//
//  Created by Tarun on 25/05/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopWebViewController : UIViewController {

	IBOutlet UIWebView* _webView;;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	IBOutlet UIButton* backArrowButton;
	IBOutlet UIButton* forwardArrowButton;
}
 
@property (nonatomic, retain) NSString* webURLStr; 

-(IBAction)onClickCloseButton:(UIButton*)button;
@end

