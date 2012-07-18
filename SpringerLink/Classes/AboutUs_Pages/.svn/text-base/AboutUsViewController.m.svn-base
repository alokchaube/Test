//
//  AboutUsViewController.m
//  SpringerLink
//
//  Created by Prakash Raj on 23/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "AboutUsViewController.h"

#import "Constant.h"
#import "Utility.h"
#import "Global.h"
#import "ApplicationConfiguration.h"
#import "FindControllerOnDifferentViewController.h"
#import "LoaderView.h"

#import "SearchResultViewController.h"
#import "AdvanceSearchViewController.h"
#import "PopWebViewController.h"

#import "SpringerLinkAppDelegate.h"

#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface AboutUsViewController ()
//private methods-
- (void)makeViewsLayoutAccToDown:(BOOL)flag;
- (void)checkTitleOfAdvCancelBtn;
- (void)showOuterLink:(NSString *)webURL;
@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_imgViewTopbar addSubview:[Global shared].imgViewBadge];
    [_imgViewTopbar addSubview:[Global shared].btnPdfView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    [_headersearchView setHidden:YES];
    
    _loader = [[LoaderView alloc] initWithFrame:[[self view]bounds]];
    
    NSString *_htmlfilename = (isIpad) ? @"/About/about_ipad_master.html" : @"/About/about.html";
    
    NSURL *url = [NSURL URLWithString:[[kCacheDir stringByAppendingString:_htmlfilename]stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    NSString *aboutHtmlPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
//    [_webView loadHTMLString:[NSString stringWithContentsOfFile:aboutHtmlPath encoding:NSUTF8StringEncoding error:nil] baseURL:[[NSBundle mainBundle] resourceURL]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (isIpad) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
        
    }
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark- IBActions

-(IBAction)backClicked:(id)sender {
    
    if(isIpad) {
        
        SpringerLinkAppDelegate *_appDelegate = (SpringerLinkAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _appDelegate.articleDetailNavController, nil];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
 }

-(IBAction)homeClicked:(id)sender {
    
    if(isIpad) {
        
        SpringerLinkAppDelegate *_appDelegate = (SpringerLinkAppDelegate *)[[UIApplication sharedApplication]delegate];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _appDelegate.articleDetailNavController, nil];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)topSearchClicked:(id)sender {
    
    [UIView beginAnimations: @"moveField"context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    BOOL shouldscreenDown = [_headersearchView isHidden];
    if(!shouldscreenDown)
        [_searchBar resignFirstResponder];
    [self makeViewsLayoutAccToDown:shouldscreenDown];
    
    [UIView commitAnimations];
}

- (IBAction)advCancelBtnClicked:(id)sender {
    
    if([sender tag] == 1) {
        
        [_searchBar resignFirstResponder];
        
    } else {
        
        AdvanceSearchViewController* controller =
        [FindControllerOnDifferentViewController findClass:[AdvanceSearchViewController class] onViews:[self.navigationController viewControllers]];
        
        if(controller != nil) {
            
            [controller clearAllClicked:nil];
            [self.navigationController popToViewController:controller animated:YES];
            
        } else {
            
            NSString *_xibName = (isIpad) ? @"AdvanceSearchViewController_ipad" : @"AdvanceSearchViewController";
            AdvanceSearchViewController *nextViewController = [[AdvanceSearchViewController alloc]initWithNibName:_xibName bundle:nil];
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }
}

#pragma mark - private methods
/*
 Method to set view layout according to @param flag.Since the view is going up when top searchBar is not visible and goes down in contradiction.
 
 @param flag : YES/NO - Down/Up    (only for basic search)
 */
- (void)makeViewsLayoutAccToDown:(BOOL)flag {
    
    float searchBtnAlpha = (flag) ? .6 : 1;
    [_topSearchBtn setAlpha:searchBtnAlpha];
    
    int margin = (flag) ? 44 : -44;
    
    CGRect frame = _webView.frame;
    frame.origin.y += margin;
    frame.size.height -= margin;
    _webView.frame = frame;
    
    [_headersearchView setHidden:!flag];
}

/*
 This method sets Title/Image of cancel/advance button as comatible. 
 */
- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

/*
 opening class PopWebViewController to open outer link.
 @param : urlStr - URL string which is to be open.
 */
-(void)showOuterLink:(NSString *)urlStr {
    
    PopWebViewController *nextViewController;
    
    if(isIpad) {
        
        nextViewController = [[PopWebViewController alloc] initWithNibName:@"PopWebViewController"bundle:nil];
        nextViewController.webURLStr = urlStr;
        [nextViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        //[nextViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        
        [self.splitViewController presentModalViewController:nextViewController animated:YES];
        
    } else {
        
        nextViewController = [[PopWebViewController alloc] initWithNibName:@"PopWebViewController_iphone"bundle:nil];
        nextViewController.webURLStr = urlStr;
        [self presentModalViewController:nextViewController animated:YES];
    }
}

#pragma mark - UISearchBarDelegate
//search bar begin editing
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 1;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

//search bar end editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 0;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

//search bar - Search button clicked.
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    if([[_searchBar text] isOnlySpace]) {
        
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not perform blank search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return;
    }
    
    SearchResultViewController* controller =
    [FindControllerOnDifferentViewController findClass:[SearchResultViewController class] onViews:[self.navigationController viewControllers]];
    
    if(controller != nil) {
        
        [controller reSearchWithQueryStr:searchBar.text];
        [self.navigationController popToViewController:controller animated:YES];
        
    } else {
        
        NSString *XIBFileName = isIphone ? @"SearchResultViewController_iPhone" : @"SearchResult_Ipad";
        
        SearchResultViewController *objSearchResult=[[SearchResultViewController alloc]initWithNibName:XIBFileName bundle:nil] ;
        ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
        FacetsQuery *     facetsQuery      = [[FacetsQuery alloc] init];
        NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
        constraintsQuery.journalArray = arrJournals;
        constraintsQuery.openaccess = NO;
        objSearchResult.constraintsQuery = constraintsQuery;
        objSearchResult.facetsQuery = facetsQuery;
        objSearchResult.searchKey = searchBar.text;
        objSearchResult.termsType = KeywordType;
        objSearchResult.currentSortBy = SortByRelevance;
        objSearchResult.isBasicSearch = YES;
        
        [self.navigationController pushViewController:objSearchResult animated:YES];
        [[Global shared] setSearchResultViewController:objSearchResult];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if(navigationType ==UIWebViewNavigationTypeLinkClicked)
	{
        NSArray *urlCoponents=[[request.URL absoluteString] componentsSeparatedByString:@"/"];
        
        if([urlCoponents count]>0) {
            
            NSRange range = [[urlCoponents lastObject] rangeOfString:@"#"];
            if(range.location == NSNotFound){
                
                NSLog(@"%@",[request.URL scheme]);
                if(![[request.URL scheme] isEqualToString:@"tel"])
                     [self showOuterLink:[request.URL absoluteString]];
                
            } else {
                //internal link--
            }
        }
        return NO;
    }
    return YES; 
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.view addSubview:_loader];
    [_loader showLoader];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [_loader removeFromSuperview];
}

@end
