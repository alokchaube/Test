//
//  OnlineArticleListViewController.m
//  SpringerLink
//
//  Created by RAVI DAS on 28/06/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "OnlineArticleListViewController.h"
#import "SpringerLinkAppDelegate.h"
#import "SearchResultViewController.h"
#import "FindControllerOnDifferentViewController.h"
#import "Constant.h"
#import "ApplicationConfiguration.h"
#import "Global.h"
#import "DBManager.h"
#import "DBArticle.h"
#import "DownloadedPDFListViewController.h"
#import "AdvanceSearchViewController.h"
#import "SearchResultsCell.h"
#import "LoaderView.h"
#import "UILabelExtended.h"
#import "ArticleDetailPageViewController.h"
#import "Global.h"
#import "PDFViewerViewController.h"
#import "Utility.h"
#import "ArticalListViewController.h"


#define koffset 3
#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface OnlineArticleListViewController()

- (void)makeViewsLayoutAccToDown:(BOOL)flag;
- (void)checkTitleOfAdvCancelBtn;
- (void)loadMoreResults;
- (void)resetFramingInIpad ;
@end


@implementation OnlineArticleListViewController
@synthesize articalListViewController = _articalListViewController;

@synthesize response = _response;
@synthesize facetsQuery = _facetsQuery;
@synthesize constraintsQuery = _constraintsQuery;
@synthesize searchKey = _searchKey;
@synthesize termsType = _termsType;
@synthesize currentSortBy = currentSortBy;
@synthesize shouldShowInDetailArea = _shouldShowInDetailArea;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}  

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _articalListViewController = [[ArticalListViewController alloc] init];
    _articalListViewController.articalListViewType = IssueListArticleType;
    
    
    [detailView addSubview:_articalListViewController.view];
    _articalListViewController.callbackDelegate = self;
    _articalListViewController.navController = self.navigationController;
    
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    [_headersearchView setHidden:YES];
    
    _objSLService = [SLService new];
    
    if(isIphone) {
        
        _articalListViewController.view.frame = CGRectMake(0, 47, 320, 373);
        _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _articalListViewController.tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        
    } else {
        
        _articalListViewController.view.frame = CGRectMake(0, 0, 320, 700);
       _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self resetFramingInIpad];//set frames of inner views...
    }
    
    [self loadMoreResults];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if(isIphone) {
        [imgViewTopbar addSubview:[Global shared].imgViewBadge];
        [imgViewTopbar addSubview:[Global shared].btnPdfView];
        
    } else if (!_shouldShowInDetailArea) {
        
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
        [_topHeaderView addSubview:[Global shared].btnPdfView];
    }
    
}
- (void)resetFramingInIpad {
    
    _articalListViewController.shouldLargeCell = _shouldShowInDetailArea;
    
    if(_shouldShowInDetailArea) {
        
        _articalListViewController.view.frame = CGRectMake(30, 5, detailView.bounds.size.width-60, detailView.bounds.size.height - 45);
        _articalListViewController.tableView.tableHeaderView = _tableHeaderView;
        [_topHeaderView removeFromSuperview];
        [imgViewTopbar setImage:[UIImage imageNamed:@"bar_top_right_ipad.png"]];
        
    } else {
        
        _articalListViewController.tableView.tableHeaderView = _tableleftHeaderView;
        _tableHeaderView.frame     = CGRectMake(0, 0, 320, 49);
        [self.view addSubview:_topHeaderView];
        
         detailView.frame        = CGRectMake(0, 47, 320, 765);
        _lblInThisArticle.frame  = CGRectMake(10, 17, 123, 18);
       // _lblArtcleCount.frame    = CGRectMake(205, 38, 92, 12);
        _lblArtcleCount.frame = CGRectMake(205, 18, 161, 20);
        [_tableleftHeaderView addSubview:_lblArtcleCount];
        
        _articalListViewController.view.frame = CGRectMake(0, 0, detailView.bounds.size.width, detailView.bounds.size.height - 60);
        
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
        [_topHeaderView addSubview:[Global shared].btnPdfView];
        
        [imgViewTopbar setImage:[UIImage imageNamed:@"bar_top_left_ipad.png"]];
        
    }
   
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isIphone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);   
    }
    else{
        return UIInterfaceOrientationIsLandscape(interfaceOrientation); 
    }
}

#pragma mark- Button Actions

- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHomeClicked:(id)sender {
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


#pragma mark -private methods



//  YES/NO: Down/Up- only for basic search
- (void)makeViewsLayoutAccToDown:(BOOL)flag {
    
    float searchBtnAlpha = (flag) ? .6 : 1;
    [_topSearchBtn setAlpha:searchBtnAlpha];
    
    int margin = (flag) ? 47 : -47;
    
    CGRect frame = detailView.frame; 
    frame.origin.y += margin;
    frame.size.height -= margin;
    detailView.frame = frame;
    
    [_headersearchView setHidden:!flag];
}

- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

///
/*
 it start searching content for a particular query 
 @param: qStr-> query for which content is to be find
 */
- (void)startSearchingWithQuery:(NSString *)qStr {
  
    NSURL *url = [NSURL URLWithString:qStr];
    
    //allocate and call a Http request  
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];
}
- (void)loadMoreResults {
    
    _result = self.response.currentResult;
    
    if (_result.start == 0 || _result == nil) 
        _startNumber = 1;
    else
        _startNumber = [_articalListViewController.tableViewDataSource count]+1;
    
    NSString *querry = [_objSLService search:self.searchKey 
                                 startNumber:_startNumber 
                             numberOfResults:kPageLimit 
                                 facetsQuery:self.facetsQuery 
                            constraintsQuery:self.constraintsQuery 
                                   termsType:self.termsType];
    NSLog(@"query : %@",querry);
    
    [self startSearchingWithQuery:querry];
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 1;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    _advCancelBtn.tag = 0;
    [self checkTitleOfAdvCancelBtn];
    return YES;
}

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
        [self.navigationController popToViewController:controller 
                                              animated:YES];
    } 
    
    else {
        
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

//*****************************************************************************************//
#pragma mark- ASIHTTPRequest delegate

- (void)requestStarted:(ASIHTTPRequest *)request {
    (isIpad) ? [self.splitViewController.view addSubview:_loader]:[self.view addSubview:_loader];
    [_loader showLoader];

}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    SLMetadataXMLParser *metadataParser=[[SLMetadataXMLParser alloc] init]; //SLMetadataXMLParser object.
    [metadataParser setDelegate:self];
    [metadataParser parseXMLData:[request responseData]];
    
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"failed");
    //    [[[UIAlertView alloc]initWithTitle:@"No internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] show];
    NSError *error= [request error];
    NSLog(@"error%d",[error code]);
    NSLog(@"error%@",[[error userInfo] objectForKey:NSUnderlyingErrorKey]);
    if ([error code] == 1) {
        [[[UIAlertView alloc]initWithTitle:@"No internet connection" message:@"Some features may not be available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] show];  
    }
    
    else if ([error code] == 2) {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"This feature is temporarily unavailable." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] show];  
    }
    [_loader removeFromSuperview];
}

#pragma mark- SLMetadataReader Delegate

/**
 * delegate method for the metadata.
 * @param: metadataResponse-> object of SLXMLResponse class which contain the metadata of articles
 */
- (void)returnMetadataResponse:(SLXMLResponse*)metadataResponse {
    
    [_loader removeFromSuperview];
    NSLog(@"%@",metadataResponse);
    self.response = metadataResponse;
    int preCount = [_articalListViewController.tableViewDataSource count];
    
    if ([_articalListViewController.tableViewDataSource count] > 0) {
        [_articalListViewController.tableViewDataSource addObjectsFromArray:self.response.records];
    } else {
        
        if(_articalListViewController.tableViewDataSource == nil) {
            NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:10];
            _articalListViewController.tableViewDataSource = array;
        }
        [_articalListViewController.tableViewDataSource setArray:self.response.records];  
    }
    
    if ([_articalListViewController.tableViewDataSource count]==0) {
        // show alert if no record found
        UIAlertView * objAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No matching article found." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [objAlertView show];
        objAlertView = nil;
    } 
    
    _result = self.response.currentResult;
    
    
    _articalListViewController.totalCount          = _result.total;
    _lblArtcleCount.text = [NSString stringWithFormat:@"(%d articles)",_result.total] ;
    [_articalListViewController reloadTableData];
    
    if(preCount > 0)
        [_articalListViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:preCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView 
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Implement UITableViewDataSource

//- (void)onSelectingTableViewCell:(NSIndexPath*)indexPath  withTableViewDataSourceArray:(NSArray*)dataSourceArray {
//    
//    if (indexPath.row == [dataSourceArray count]) {
//        
//        [self loadMoreResults]; 
//        
//    } 
//}
- (void)onSelectingTableViewCell:(NSIndexPath*)indexPath  withTableViewDataSourceArray:(NSArray*)dataSourceArray {
    
    if (indexPath.row == [dataSourceArray count]) {
        
        [self loadMoreResults]; 
    }
    
    else if(isIpad) {
        if(_shouldShowInDetailArea) {
            return;
            SpringerLinkAppDelegate *appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
            UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:0];
            [navController pushViewController:self animated:YES];
            _shouldShowInDetailArea = NO;
            
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:navController,appDelegate.articleDetailNavController, nil];
            [self resetFramingInIpad];
            
            [_articalListViewController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        } 
    }
}
@end
