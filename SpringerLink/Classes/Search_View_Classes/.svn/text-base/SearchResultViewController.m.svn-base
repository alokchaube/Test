//
//  SearchResultController.m
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//
/*
 helvetica neue bold : 36 (RGB : 255,255,255).
 helvetica neue Regular : 26 (RGB : 1,118,195).
 helvetica neue Regular : 26 (RGB : 51,51,51).
 Georgia  Regular : 40 (RGB : 51,51,51)
 
 helvetica neue Regular : 26 (RGB : 51,51,51).
 helvetica neue Regular : 26 (RGB : 1,118,195).
 
 Georgia  Regular : 36 (RGB : 51,51,51)
 helvetica neue Regular : 30 (RGB : 51,51,51).
 helvetica neue Regular : 26 (RGB : 51,51,51).
 */

#import "SearchResultViewController.h"
#import "DetectNetworkConnection.h"
#import "SLXMLResponse.h"
#import "LoaderView.h"
#import "Constant.h"
#import "Utility.h"
#import "SLService.h"
#import "UILabelExtended.h"
#import "ArticleDetailPageViewController.h"
#import "ApplicationConfiguration.h"
#import "ServerRequestHandler.h"
#import "DownloadedPDFListViewController.h"
#import "XMLDictionary.h"
#import "Global.h"
#import "PDFViewerViewController.h"
#import "SLPickerViewController.h"
#import "AdvanceSearchViewController.h"
#import "FindControllerOnDifferentViewController.h"
#import "NSString+Additions.h"

#import "DBManager.h"
#import "DBArticle.h"
#import "PDFDownloadInfo.h"
#import "SpringerLinkAppDelegate.h"


#define koffset 3
#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SearchResultViewController ()

/*
 it start searching content for a particular query 
 @param: qStr-> query for which content is to be find
 */
- (void)startSearchingWithQuery:(NSString *)qStr;
- (void)loadMoreResults;
- (void)sortBy:(NSInteger)k;
- (void)performSorting;
- (void)checkHomeBtnAppearance;
- (void)makeViewsLayoutAccToDown:(BOOL)flag; 
- (void)loadMoreResults;
- (void)resetCountLabels;

- (void)retainLastObject;
@end

@implementation SearchResultViewController
@synthesize articalListViewController = _articalListViewController;
@synthesize  searchKey;
@synthesize  response;
@synthesize  facetsQuery;
@synthesize  constraintsQuery;
@synthesize  termsType;
@synthesize currentSortBy;
@synthesize isBasicSearch;
@synthesize shouldShowInDetailArea    = _shouldShowInDetailArea; 
@synthesize dontHitService = _dontHitService;

@synthesize dataSourceArray = _dataSourceArray;
@synthesize totalCount = _totalCount;
@synthesize rightViewController = _rightViewController;

short tempSortBy;
BOOL isSorting;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil 
                           bundle:nibBundleOrNil];
    if (self) {
        
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
    
    [super viewWillAppear:YES];
    
    if(isIphone) {
        [_imgViewTopbar addSubview:[Global shared].imgViewBadge];
        [_imgViewTopbar addSubview:[Global shared].btnPdfView];
        
    } else {
        
        if(_shouldShowInDetailArea == NO) {
            [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
            [topHeaderView addSubview:[Global shared].btnPdfView];
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController,_appDelegate.articleDetailNavController, nil];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (isIphone) {
        
        _articalListViewController = [[ArticalListViewController alloc] initWithNibName:@"ArticalListViewController" bundle:nil];
        _articalListViewController.tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _articalListViewController.view.frame = CGRectMake(0, 3, 320, 413);
        _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        // add header view in table
        _articalListViewController.tableView.tableHeaderView = headerView;
        
    } else {
        
        _articalListViewController = [[ArticalListViewController alloc] initWithNibName:@"ArticalListViewController_ipad" bundle:nil];
        _articalListViewController.tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        
        _articalListViewController.shouldLargeCell = _shouldShowInDetailArea;
        [searchHeaderView setHidden:_shouldShowInDetailArea];
        [self resetControlsFraming];
       
        if(self.dontHitService) {
            _articalListViewController.tableViewDataSource = [_dataSourceArray mutableCopy];
            _articalListViewController.totalCount = self.totalCount;
             [self resetCountLabels];
        }
        _slSortListViewController = nil;
        isTableScrolled = NO;
    }
    
    
    _articalListViewController.articalListViewType = SearchResultArticalListType;
    
    [detailView addSubview:_articalListViewController.view];
    _articalListViewController.callbackDelegate = self;
    _articalListViewController.navController = self.navigationController;
    
    sortingItems = [[NSArray alloc] initWithObjects:@"  Author",@"  Date",@"  Relevance",@"  Title", nil];
    tempSortBy = self.currentSortBy;
    isSorting = NO;
    isSearchViewVisible = YES;
    isTableScrolled     = NO;
    _objSLService = [SLService new];
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    
    
    if(isBasicSearch) {
        
        [self makeViewsLayoutAccToDown:isBasicSearch];
        
    } else {
        
        [searchHeaderView setHidden:YES];
        [_topSearchBtn setAlpha:1];
    } 
    
    // call method for load first 10 articles
    [_headersearchView bringSubviewToFront:searchHeaderView];
    // add sortTable in search table view
    if(self.dontHitService && isIpad)
        return;
    
    [self loadMoreResults];  
}


- (void)viewDidUnload
{
    
    _lblHeader = nil;
    topHeaderView = nil;
    [super viewDidUnload];
    _loader    = nil;
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

#pragma mark- public methods

- (void)resetControlsFraming {
    
    if(_shouldShowInDetailArea) {
        
        detailView.frame = CGRectMake(0, 40, 700, 700);
        _articalListViewController.view.frame = CGRectMake(25, 5, 655, 703);
        [topHeaderView removeFromSuperview];
        
    } else {
        
        detailView.frame = CGRectMake(0, 44, 320, 700);
        _articalListViewController.view.frame = CGRectMake(0, 0, 320, 700);
        topHeaderView.frame = CGRectMake(0, 0, 320, 49);
        [self.view addSubview:topHeaderView];
        
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
        [topHeaderView addSubview:[Global shared].btnPdfView];
    }
    
    _articalListViewController.shouldLargeCell = self.shouldShowInDetailArea;
    
    
    short _widthOfSortView =  (self.shouldShowInDetailArea) ? 670 : 320;
    short _rightShiftWidth = (self.shouldShowInDetailArea) ? 5 : -5;
    NSString *_imageName = (self.shouldShowInDetailArea) ? @"bar_search_type.png" : @"bar_sort.png";
    short _widthsortByBackImageView = (self.shouldShowInDetailArea) ? 653 : 320;
    short _fontSize = 18;//(self.shouldShowInDetailArea) ? 18 : 14;
    
    //----set font of labels------
    [_countLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:_fontSize]];
    [_resultLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:_fontSize]];
    [_resultItemLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:_fontSize]];
    
    //----set frame of sort by view---
    CGRect frame = headerView.frame;
    frame.size.width = _widthOfSortView;
    headerView.frame = frame;
    
    //----set frame of sort by back image---
    [_sortByBackImageView setImage:[UIImage imageNamed:_imageName]];
    frame = _sortByBackImageView.frame;
    frame.size.width = _widthsortByBackImageView;
    _sortByBackImageView.frame = frame;
    
    //----set frame of sort by Button---
    frame = _sortByButton.frame;
    frame.origin.x += _rightShiftWidth;
    _sortByButton.frame = frame;
    
    //----set frame of sort by label---
    frame = _sortByLabel.frame;
    frame.origin.x += _rightShiftWidth;
    _sortByLabel.frame = frame;
    
    _articalListViewController.tableView.tableHeaderView = headerView;
}

- (void)reSearchWithQueryStr:(NSString *)str {
    
    _searchBar.text = str;
    self.searchKey = str;
    self.termsType = KeywordType;
    self.currentSortBy = SortByRelevance;
    
    _startNumber = 1;
    isSorting = NO;
    self.isBasicSearch = YES;
    
    
    ConstraintsQuery* constraintsQuery1 = [[ConstraintsQuery alloc] init];
    FacetsQuery *     facetsQuery1      = [[FacetsQuery alloc] init];
    NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
    constraintsQuery1.journalArray = arrJournals;
    constraintsQuery1.openaccess = NO;
    self.constraintsQuery = constraintsQuery1;
    self.facetsQuery = facetsQuery1;
    
    NSString *querry = [_objSLService search:self.searchKey 
                                 startNumber:_startNumber 
                             numberOfResults:kPageLimit 
                                 facetsQuery:self.facetsQuery 
                            constraintsQuery:self.constraintsQuery 
                                   termsType:self.termsType];
    [_articalListViewController.tableViewDataSource removeAllObjects];
    
    [self startSearchingWithQuery:querry];
}

//////method added ----prakash
- (void)performAdv_Search {
    
    if(!_shouldShowInDetailArea && isIpad)
        [self makeViewsLayoutAccToDown:isBasicSearch];
    _result = self.response.currentResult;
    _startNumber = 1; 
    NSString *querry = [_objSLService search:self.searchKey 
                                 startNumber:_startNumber 
                             numberOfResults:kPageLimit 
                                 facetsQuery:self.facetsQuery 
                            constraintsQuery:self.constraintsQuery 
                                   termsType:self.termsType];
    NSLog(@"query : %@",querry);
    
    [_articalListViewController.tableViewDataSource removeAllObjects];
    [self startSearchingWithQuery:querry];
    
    if(isIpad)
        [self resetControlsFraming];
}

#pragma mark- Button Actions
- (void)retainLastObject {
    
    _dataSourceArray = nil;
    _dataSourceArray = [[NSArray alloc] initWithArray:_articalListViewController.tableViewDataSource];
    
    _rightViewController = nil;
    _rightViewController = [[SearchResultViewController alloc]initWithNibName:@"SearchResult_Ipad" bundle:nil]; 
    _rightViewController.response = self.response;
    _rightViewController.dontHitService = YES;
    _rightViewController.shouldShowInDetailArea = YES;
    _rightViewController.dataSourceArray = _dataSourceArray; 
    _rightViewController.totalCount = self.totalCount;
    
    _rightViewController.constraintsQuery  =  self.constraintsQuery;
    _rightViewController.facetsQuery       =  self.facetsQuery;
    _rightViewController.searchKey         = self.searchKey;
    _rightViewController.termsType         =  KeywordType;
    _rightViewController.currentSortBy     =  SortByRelevance;
    _rightViewController.isBasicSearch     =  self.isBasicSearch;
}

-(IBAction)backClicked:(id)sender {
    
    if([_loader superview] != nil)
        [_loader removeFromSuperview];
    [_httpRequest clearDelegatesAndCancel];
 
    if(isIpad) {
        
        [[Global shared] setSearchResultViewController:_rightViewController];
        
        UINavigationController *detailNavController = [[UINavigationController alloc]initWithRootViewController:_rightViewController];
        [detailNavController setNavigationBarHidden:YES];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, detailNavController, nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)homeClicked:(id)sender {
    
    if([_loader superview] != nil)
        [_loader removeFromSuperview];
    [_httpRequest clearDelegatesAndCancel];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)topSearchClicked:(id)sender {
    
    NSLog(@"see %f", detailView.frame.origin.y);
    
    if(isIpad && detailView.frame.origin.y < 44.00) {
        
        CGRect frame = detailView.frame;
        frame.origin.y = 44.0;
        detailView.frame = frame;
    }

    CGRect frame = searchHeaderView.frame;
    frame.origin.y = 40;
    [searchHeaderView setFrame:frame];
    
    [UIView beginAnimations: @"moveField"context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    BOOL shouldscreenDown = [searchHeaderView isHidden];
    isSearchViewVisible = shouldscreenDown;
    isTableScrolled = NO;//change..
    [self makeViewsLayoutAccToDown:shouldscreenDown];
    searchHeaderView.hidden = !shouldscreenDown;
    if(!shouldscreenDown)
        [_searchBar resignFirstResponder];
    
    [UIView commitAnimations];
}

- (IBAction)sortByButtonClicked:(id)sender {
    
    if(isIpad) {
        
        if(_slSortListViewController == nil) {
            _slSortListViewController = [[SLSortListViewController alloc] initWithNibName:@"SLSortListViewController" bundle:nil];
            _slSortListViewController.delegate = self;
        }
        
        if(_sortPopOverController == nil) {
            _sortPopOverController = [[UIPopoverController alloc] initWithContentViewController:_slSortListViewController];
        }
        
        if([_sortPopOverController isPopoverVisible]) {
            [_sortPopOverController dismissPopoverAnimated:YES];
            return;
        }
         _sortPopOverController.delegate = self;
        
        [_sortByButton setSelected:YES];
        
        [_sortPopOverController setPopoverContentSize:CGSizeMake(320, 88)];
        CGRect frame = [sender frame];
        short yy = ([searchHeaderView isHidden]) ? 30 : 74;
        CGRect popoverframe = (_shouldShowInDetailArea) ? CGRectMake(frame.origin.x, frame.origin.y, 296, 85): CGRectMake(frame.origin.x, frame.origin.y, 256, frame.origin.y + yy);
        
        [_sortPopOverController presentPopoverFromRect:popoverframe inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        
        if([_slpickerViewController.view superview]) {
            [_slpickerViewController.view removeFromSuperview];
            _slpickerViewController = nil;
        }
        
        _slpickerViewController = [[SLPickerViewController alloc] initWithNibName:@"SLPickerViewController_iPhone" bundle:nil];
        _slpickerViewController.selectedRow = self.currentSortBy;
        [self.view addSubview:_slpickerViewController.view];
        _slpickerViewController.delegate = self;
        _slpickerViewController.view.frame = CGRectMake(0, 460, 320, 260);
        
        [UIView beginAnimations:@"moveField" context: nil];
        [UIView setAnimationDelegate: self];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        _slpickerViewController.view.frame = CGRectMake(0, 200, 320, 260);
        [UIView commitAnimations];
    }
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

#pragma mark- private methods
/*
 it start searching content for a particular query 
 @param: qStr-> query for which content is to be find
 */
- (void)startSearchingWithQuery:(NSString *)qStr {
    
    if(_httpRequest != nil) {
        _httpRequest = nil;
        [_httpRequest clearDelegatesAndCancel];
    }
    
    NSURL *url = nil;
    url = [NSURL URLWithString:qStr];
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


- (void)performSorting {
    
    [_articalListViewController.tableViewDataSource removeAllObjects];
    _result = self.response.currentResult;
    
    if (_result.start == 0 || _result == nil) 
        _startNumber = 1;
    else
        _startNumber = [_articalListViewController.tableViewDataSource count]+1;
    
    NSString *query = [_objSLService search:self.searchKey 
                                startNumber:_startNumber 
                            numberOfResults:kPageLimit 
                                facetsQuery:self.facetsQuery 
                           constraintsQuery:self.constraintsQuery 
                                  termsType:self.termsType];
    
    NSLog(@"query : %@",query);
    [self startSearchingWithQuery:query];
}

- (void)sortBy:(NSInteger)k {
    
    if(k == currentSortBy)
        return;
    if(k == SortByTitle || k == SortByAuthor)
        return;
    
    if(k == SortByDate) {
        self.termsType = MostRecentType;
    } else if(k == SortByRelevance) {
        self.termsType = KeywordType;
    }
    
    tempSortBy = k;
    isSorting = YES;
    [self performSorting];
}


//check should home button appear.
- (void)checkHomeBtnAppearance {
    [_homeBtn setHidden:!([[self.navigationController viewControllers] count]>2)];
}

//  YES/NO: Down/Up- only for basic search
- (void)makeViewsLayoutAccToDown:(BOOL)flag {
    
    if(isIpad && _shouldShowInDetailArea)
        return;
    
    if (isTableScrolled) {
        isTableScrolled = NO;
        if (isIphone) {
            CGRect frame = detailView.frame;
            frame.origin.y = 44+48;
            detailView.frame = frame;
            
            frame = _articalListViewController.tableView.frame;
            frame.size.height = 413-48;
            _articalListViewController.tableView.frame = frame;  
        }
        else {
            CGRect frame = detailView.frame;
            frame.origin.y = 44+48;
            //frame.size.height = 700-48;
            detailView.frame = frame;
            
            frame = _articalListViewController.tableView.frame;
            frame.size.height -= 48;
            _articalListViewController.tableView.frame = frame;
        }
        
    }
    
    //////
    float searchBtnAlpha = (flag) ? .6 : 1;
    [_topSearchBtn setAlpha:searchBtnAlpha];
    
    int margin = (flag) ? 48 : -48;
    
    CGRect frame = detailView.frame;
    frame.origin.y += margin;
    detailView.frame = frame;
    
    frame = _articalListViewController.tableView.frame;
    frame.size.height -= margin;
    _articalListViewController.tableView.frame = frame;
    
    
    [searchHeaderView setHidden:!flag];
    [_searchBar setText:self.searchKey];
}


- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

- (void)resetCountLabels {
    
    NSString *str = (_totalCount <= 0) ?  @"No Result" : [NSString stringWithFormat:@"%i",_totalCount];
    _countLabel.text = str;//self.response.query;
    [_countLabel setWidthOfLabelWithMaxWidth:100];
    
    CGRect frame = _resultLabel.frame;
    frame.origin.x = _countLabel.frame.origin.x + _countLabel.frame.size.width + 4;
    _resultLabel.frame = frame;
    _resultLabel.text = (isBasicSearch && self.searchKey) ? @"Result(s) for" : @"Result(s)";
    [_resultLabel setWidthOfLabel];
    
    CGRect frame1 = _resultItemLabel.frame;
    frame1.origin.x = _resultLabel.frame.origin.x + _resultLabel.frame.size.width;
    _resultItemLabel.frame = frame1;
    
    _resultItemLabel.text = (isBasicSearch && self.searchKey) ? [NSString stringWithFormat:@"'%@'",self.searchKey]:@"";
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
    
    if([[_searchBar text] isOnlySpace]) {
        
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not perform blank search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return;
    }
    
    if(![self.searchKey isEqualToString:searchBar.text])
        [self reSearchWithQueryStr:searchBar.text];
    
    [searchBar resignFirstResponder];
}

#pragma mark- ASIHTTPRequest delegate

- (void)requestStarted:(ASIHTTPRequest *)request {
    
    (isIpad) ? [self.splitViewController.view addSubview:_loader] : [self.view addSubview:_loader];
    [_loader showLoader];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    SLMetadataXMLParser *metadataParser=[[SLMetadataXMLParser alloc] init]; //SLMetadataXMLParser object.
    [metadataParser setDelegate:self];
    [metadataParser parseXMLData:[request responseData]];
    
    
    //in case sorting
    if(isSorting) {
        self.currentSortBy = tempSortBy;
        [_sortByButton setTitle:[sortingItems objectAtIndex:self.currentSortBy] 
                       forState:UIControlStateNormal];
        if(isIpad && _articalListViewController.selectedindex >= 0) {
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_articalListViewController.selectedindex inSection:0];
            [_articalListViewController.tableView deselectRowAtIndexPath:indexpath animated:YES];
            _articalListViewController.selectedindex = -1;
        }
        
        isSorting = NO;
        
    } else {
        
        //        self.currentSortBy = SortByRelevance;
        //        [_sortByButton setTitle:[sortingItems objectAtIndex:self.currentSortBy] 
        //                       forState:UIControlStateNormal];
        
    }
    
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
    
    if ([_articalListViewController.tableViewDataSource count] == 0) {
        // show alert if no record found
        UIAlertView * objAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No matching article found." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [objAlertView show];
        objAlertView = nil;
    }
    
    _result = self.response.currentResult;
    
   
    ///
    _totalCount = _articalListViewController.totalCount = _result.total;
    
    [_articalListViewController reloadTableData];
    
    //only called for ipad. when next at last element or show more.
    if(_articalListViewController.selectedindex == preCount-1 && isIpad) {
        [_articalListViewController selectTableIndex:preCount];
    }
    
    
    if(preCount > 0)
        [_articalListViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:preCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self resetCountLabels];
    
//    NSString *str = (_result.total <= 0) ?  @"No Result" : [NSString stringWithFormat:@"%i",_result.total];
//    _countLabel.text = str;//self.response.query;
//    [_countLabel setWidthOfLabelWithMaxWidth:100];
//   
//    CGRect frame = _resultLabel.frame;
//    frame.origin.x = _countLabel.frame.origin.x + _countLabel.frame.size.width + 4;
//    _resultLabel.frame = frame;
//    _resultLabel.text = (isBasicSearch && self.searchKey) ? @"Result(s) for" : @"Result(s)";
//    [_resultLabel setWidthOfLabel];
//    
//    CGRect frame1 = _resultItemLabel.frame;
//    frame1.origin.x = _resultLabel.frame.origin.x + _resultLabel.frame.size.width;
//    _resultItemLabel.frame = frame1;
//    
//    _resultItemLabel.text = (isBasicSearch && self.searchKey) ? [NSString stringWithFormat:@"'%@'",self.searchKey]:@"";
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView 
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark Implement PickerViewControllerDelegate 
- (void)onSelectingPickerRow:(NSString*)rowTitle {
    
    if([[rowTitle lowercaseString] isContainSubstring:@"relevance"]) {
        [self sortBy:SortByRelevance];
        
    } else if([[rowTitle lowercaseString] isContainSubstring:@"author"]) {
        [self sortBy:SortByAuthor];
        
    } else if([[rowTitle lowercaseString] isContainSubstring:@"date"]) {
        [self sortBy:SortByDate];
        
    } else if([[rowTitle lowercaseString] isContainSubstring:@"title"]) {
        [self sortBy:SortByTitle];
        
    }
    
}

- (void)onChangingPickerTitleSelection:(NSString*)rowTitle {
    
    if([[rowTitle lowercaseString] isContainSubstring:@"relevance"]) {
        [_sortByButton setTitle:@"  Relevance" forState:UIControlStateNormal];
        
    }else if([[rowTitle lowercaseString] isContainSubstring:@"author"]) {
        [_sortByButton setTitle:@"  Relevance" forState:UIControlStateNormal];
        
    }else if([[rowTitle lowercaseString] isContainSubstring:@"date"]) {
        [_sortByButton setTitle:@"  Date" forState:UIControlStateNormal];
        
    }else if([[rowTitle lowercaseString] isContainSubstring:@"title"]) {
        
    }
}

- (void)onScrollTableView:(UIScrollView*)scrollView {
    if(isIpad && _shouldShowInDetailArea)
        return;
    
    if(_articalListViewController.tableView.contentOffset.y > 90 && 
       preY < _articalListViewController.tableView.contentOffset.y) {
        
        if (isSearchViewVisible) {
            CGRect frameSearchHeaderView = searchHeaderView.frame;
            
            if (frameSearchHeaderView.origin.y>=0) {
                isTableScrolled = YES;
                frameSearchHeaderView.origin.y -= 1;
                [searchHeaderView setFrame:frameSearchHeaderView];
                CGRect frame = detailView.frame;
                frame.origin.y -= 1;
                detailView.frame = frame;
                
                frame = _articalListViewController.tableView.frame;
                frame.size.height += 1;
                _articalListViewController.tableView.frame = frame;
                if (frameSearchHeaderView.origin.y==0) {
                    isTableScrolled = NO;
                    [_topSearchBtn setAlpha:1];
                    [searchHeaderView setHidden:YES];
                    isSearchViewVisible = NO;
                    [_searchBar setText:self.searchKey];
                    CGRect frame = detailView.frame;
                    frame.origin.y = 44;
                    detailView.frame = frame;
                    
                    frame = _articalListViewController.tableView.frame;
                    if (isIphone) {
                        frame.size.height = 413;  
                    }
                    else{
                        frame.size.height = 703;
                    }
                    
                    _articalListViewController.tableView.frame = frame;
                    return;
                }
            }
        }
    }
    CGRect frameSearchHeaderView = searchHeaderView.frame;
    if(preY>_articalListViewController.tableView.contentOffset.y&&frameSearchHeaderView.origin.y<40) {
        if (isSearchViewVisible) {
            
            if (frameSearchHeaderView.origin.y==40) {
                isTableScrolled = NO;
            }
            frameSearchHeaderView.origin.y += 1;
            [searchHeaderView setFrame:frameSearchHeaderView];
            CGRect frame = detailView.frame;
            frame.origin.y += 1;
            detailView.frame = frame;
            
            frame = _articalListViewController.tableView.frame;
            frame.size.height -= 1;
            _articalListViewController.tableView.frame = frame;
        }
    }
    preY = _articalListViewController.tableView.contentOffset.y;
}



- (void)onSelectingTableViewCell:(NSIndexPath*)indexPath  
    withTableViewDataSourceArray:(NSArray*)dataSourceArray {
    
    if (indexPath.row == [dataSourceArray count]) {
        [self loadMoreResults]; 
        
    } else if(isIpad) {
        
        SpringerLinkAppDelegate *appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
    
        if(_shouldShowInDetailArea) {
           
            UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:0];
            _shouldShowInDetailArea = NO;
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:navController,appDelegate.articleDetailNavController, nil];
             [navController pushViewController:self animated:YES];
            [self resetControlsFraming];
            [self retainLastObject];
            
        } else {
            
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController,appDelegate.articleDetailNavController, nil];
        }
    }
}

#pragma mark - SLSortListViewControllerDelegate
- (void)performSortingAccordingToIndex:(short)index {
    
    [_slSortListViewController setSelectedIndex:index];
     [_sortByButton setSelected:NO];
    
    if(index == 0)
        [self sortBy:SortByRelevance];
    else if(index == 1)
        [self sortBy:SortByDate];
    
    if([_sortPopOverController isPopoverVisible]) {
        [_sortPopOverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    [_sortByButton setSelected:NO];
    return YES;
}

@end
