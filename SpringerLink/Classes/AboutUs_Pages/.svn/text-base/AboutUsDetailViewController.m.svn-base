//
//  AboutUsDetailViewController.m
//  SpringerLink
//
//  Created by kiwitech kiwitech on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutUsDetailViewController.h"

#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface AboutUsDetailViewController ()

@end

@implementation AboutUsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *_htmlfilename = @"/About/about_ipad_detail.html";
    NSURL *url = [NSURL URLWithString:[[kCacheDir stringByAppendingString:_htmlfilename]stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
