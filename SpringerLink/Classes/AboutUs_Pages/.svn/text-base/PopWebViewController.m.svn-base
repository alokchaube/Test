//
//  PopWebViewController.m
//  Springer
//
//  Created by Tarun on 25/05/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PopWebViewController.h"

@implementation PopWebViewController
@synthesize webURLStr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    _webView = nil;
    _webView.delegate = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	if(_webView) {
        
		[_webView stopLoading];
		_webView.delegate = nil;
	}
	_webView = nil;
	self.webURLStr = nil;
	//[super dealloc];
}


#pragma mark - View lifecycle

-(void)viewDidLoad {
	   
    backArrowButton.enabled = forwardArrowButton.enabled = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURLStr]]];
	[self.view bringSubviewToFront:activityIndicator];
  
}

-(IBAction)onClickCloseButton:(UIButton*)button {
	
	if(_webView) {
        
		[_webView stopLoading];
		_webView.delegate = nil;
	}
	
	_webView = nil;
    [self dismissModalViewControllerAnimated:YES];
}

-(void)awakeFromNib {
    
	//closeButton.autoresizingMask = UIViewAutoresizingNone;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
    if (isIpad) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);

    }
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
	[activityIndicator startAnimating];
	[self.view bringSubviewToFront:activityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	[activityIndicator stopAnimating];
   
    [backArrowButton setSelected:[_webView canGoBack]];
    backArrowButton.enabled = [_webView canGoBack];
	
    [forwardArrowButton setSelected:[_webView canGoForward]];
    forwardArrowButton.enabled = [_webView canGoForward];
}

@end
