//
//  SearchViewController.m
//  SpringerLink
//
//  Created by Prakash Raj on 10/04/12.
//  Copyright (c) 2012 KiwiTech. All rights reserved.

#import "SearchViewController.h"
#import "Constant.h" 
#import "LoaderView.h"
#import "SearchResultViewController.h"

#import "Utility.h"
#import "DetectNetworkConnection.h"
#import "NSString+Additions.h"

#import "SLService.h"
#import "VolumeListViewController.h"
#import "SearchResultsCell.h"
#import "ArticleDetailPageViewController.h"
#import "AdvanceSearchViewController.h"
#import "UILabelExtended.h"
#import "ApplicationConfiguration.h"
#import "SpringerLinkAppDelegate.h"
#import "DownloadedPDFListViewController.h"
#import "ApplicationConfiguration.h"
#import "ServerRequestHandler.h"
#import "XMLDictionary.h"
#import "Global.h"
#import "DBManager.h"
#import "DBArticle.h"
#import "PDFDownloadInfo.h"
#import "AboutUsViewController.h"
#import "PDFViewerViewController.h"
#import "FindControllerOnDifferentViewController.h"
#import "ArticalListViewController.h"
#import "AboutUsCreator.h"

#import "AboutUsDetailViewController.h"


#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define klbloffset 4  // offset for Volume and volumeNumber label


@interface SearchViewController ()
- (void)deleteNotDownloadedPdf;
- (void)deletePdfFromCache:(NSArray*)pdfdoiArray;
- (NSMutableString *)getPathForPDFFile:(NSString *)filename;
- (void)startSearchingWithQuery:(NSString *)qStr;
- (void)loadLatestArticles;
- (void)performBasicSearch;
- (void)loadThumbinalImage;
- (void)setBadgeImageView;
- (void)refreshTableView;
- (void)startParsingWithQuery:(NSString *)qStr;
- (void)setMetaDataForJournal;
- (void)setDefaultMetaDataForJournal;
- (void)setTextForLabel:(NSDictionary*)metadataDic;
- (void)setLabelFrame;
- (void)makeHeaderSearchViewVisible:(BOOL)shouldVisible;
- (void)checkTitleOfAdvCancelBtn;

- (void)creatAboutUsPageIfNotAvailable;

@end


@implementation SearchViewController
@synthesize articalListViewController = _articalListViewController;

short _selectedIndex;

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
    [_searchBar setText:@""];
    
    if (isIphone) {
        
        [_imgViewTopbar addSubview:[Global shared].imgViewBadge];
        [_imgViewTopbar addSubview:[Global shared].btnPdfView];
        
        if(_articalListViewController != nil) {
            [_articalListViewController  reloadTableData];
            _articalListViewController.tableHeight = 0;
        }
        
    } else {
        
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
        [_imgViewTopbar addSubview:[Global shared].btnPdfView];
        
        if(_articalListViewController != nil) {
            
            if(_selectedIndex < 0) {
                 [_appDelegate.articleDetailViewController makeHomeScreenLayout];
                
            } else {
                
                self.articalListViewController.selectedindex = _selectedIndex;
                [self.articalListViewController tableView:self.articalListViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
            }  
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController,_appDelegate.articleDetailNavController, nil];
        }
    } 
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
   
    _appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
    _selectedIndex = -1;
    
    //NSString *_xibName = @"ArticalListViewController";
    _articalListViewController = [[ArticalListViewController alloc] init];
    
    _articalListViewController.articalListViewType = HomeLatestArticalListType;
    _articalListViewController.callbackDelegate = self;
    _articalListViewController.navController = self.navigationController;
    
    // delete pdf from database and cache which are not downloaded completely when app fourc quit
    [self performSelectorInBackground:@selector(deleteNotDownloadedPdf) withObject:nil];
    
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    [self makeHeaderSearchViewVisible:YES];
    
    if (isIphone) {
         _loader  = [[LoaderView alloc] initWithFrame:[self.view bounds]];
       [_scrollView setContentSize:CGSizeMake(320, 340)]; 
        
    } else {
    
         _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 768)];
        [_scrollView setContentSize:CGSizeMake(320, 730)];
        [self.view bringSubviewToFront:_imgViewTopbar];
        [self.view bringSubviewToFront:_aboutUsBtn];
        [self.view bringSubviewToFront:_topSearchBtn];
    }
    
   
    _objVolumeXMLResponse = [[SLVolumeXMLResponse alloc] init];
    
    [[Global shared] setSearchViewController:self];
    [self setBadgeImageView];
    [self setDefaultMetaDataForJournal];
    
    [self creatAboutUsPageIfNotAvailable];
    
}

- (void)viewDidUnload {
    
    _searchBar = nil;
    _btnBrowseByVolume    = nil;
    _scrollView           = nil;
    _articalListViewController  = nil;
    _lblJournalName = nil;
    _lblChiefeditors = nil;
    _lblVolumeNumber = nil;
    _lblIssueNumber = nil;
    _lblArticleNumber = nil;
    _lblVolumeDate = nil;
    _lblVolume = nil;
    _lblIssue = nil;
    _lblArticle = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isIphone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);   
    }
    else{
        return UIInterfaceOrientationIsLandscape(interfaceOrientation); 
    }
}

#pragma mark- public method

- (void)hitRequestForLatestArticles {
    
    _articalListViewController.tableHeight = 0;
   [self performSelector:@selector(startParsingWithQuery:) withObject:kBrowsexmlPath];
   [self performSelectorInBackground:@selector(loadThumbinalImage) withObject:nil];
}

#pragma mark- Button Actions

- (IBAction)aboutUsClicked:(id)sender {

    if(isIpad) return;//---line to be deleted--
    
    NSString *_xibName = (isIpad) ? @"AboutUsViewController_ipadMaster": @"AboutUsViewController";
    AboutUsViewController *nextViewController = [[AboutUsViewController alloc] initWithNibName:_xibName bundle:nil];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    if(isIpad) {
        
        //do something for detail page.....
        
        AboutUsDetailViewController *_aboutUsDetailViewController = [[AboutUsDetailViewController alloc] initWithNibName:@"AboutUsDetailViewController" bundle:nil];
        UINavigationController *_aboutUsDetailNavController = [[UINavigationController alloc]initWithRootViewController:_aboutUsDetailViewController];
        [_aboutUsDetailNavController setNavigationBarHidden:YES];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _aboutUsDetailNavController, nil];
        
    } 
}

- (IBAction)btnBrowseByVolumeClicked:(id)sender {
    
    
    if([Global shared].volumeXMLResponse == Nil) {
       
        showAlert(NetworkErrorMessage);
        return;
    }
    if(isIpad)
    {
        VolumeListViewController *nextViewController = [[VolumeListViewController alloc] initWithNibName:@"VolumeListViewController_ipad" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else{
        VolumeListViewController *nextViewController = [[VolumeListViewController alloc] initWithNibName:@"VolumeListViewController" bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
    
}

- (IBAction)topSearchClicked:(id)sender {
    
    [UIView beginAnimations: @"moveField"context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    BOOL shouldscreenDown = [_headersearchView isHidden];
    if(!shouldscreenDown)
        [_searchBar resignFirstResponder];
    [self makeHeaderSearchViewVisible:shouldscreenDown];
    
    [UIView commitAnimations];
}

- (IBAction)advCancelBtnClicked:(id)sender {
    
    if([sender tag] == 1) {
        [_searchBar resignFirstResponder];
        
    } else {
        NSString *xibName = (isIphone) ? @"AdvanceSearchViewController" : @"AdvanceSearchViewController_ipad";       
        AdvanceSearchViewController *nextViewController = [[AdvanceSearchViewController alloc]initWithNibName:xibName bundle:nil];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

// Action for downloaded pdf icon in top bar
- (IBAction)btnDownloadPdfViewClicked:(id)sender {
    
    NSString *xibName = (isIphone) ? @"DownloadedPDFListViewController" : @"DownloadListViewController_ipad";
    DownloadedPDFListViewController* controller =
    [FindControllerOnDifferentViewController findClass:[DownloadedPDFListViewController class] onViews:[self.navigationController viewControllers]];
    
    if(controller != nil) {
        [self.navigationController popToViewController:controller animated:YES];
        
    } else {
        DownloadedPDFListViewController *objDownloadList = [[DownloadedPDFListViewController alloc] initWithNibName:xibName bundle:nil];
        [self.navigationController pushViewController:objDownloadList animated:YES];
    }
}

#pragma mark- Private methods

- (void)deleteNotDownloadedPdf {
    
    NSArray *pdfdoiArray =  [[DBManager sharedDBManager] doiForNotDownloadedPdf];
    [self deletePdfFromCache:pdfdoiArray];
    [[DBManager sharedDBManager] deleteNotDownloadedPDFFromPdfTable];
}


- (void)deletePdfFromCache:(NSArray*)pdfdoiArray {
    
    for (NSString *doi in pdfdoiArray) {
        NSString *fileName = [doi stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        NSString *filePath = [self getPathForPDFFile:fileName];
        NSLog(@"%@",filePath);
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if([manager fileExistsAtPath:filePath])
            if([manager removeItemAtPath:filePath error:nil]) {
                NSLog(@"removed successfully from cache");
            }  
    }
}

- (NSMutableString *)getPathForPDFFile:(NSString *)filename {
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                            NSUserDomainMask, YES);
    NSMutableString *pdfFilePath = [dirPaths objectAtIndex:0];
	pdfFilePath=(NSMutableString*)[pdfFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pdf/%@.pdf",filename]];
    return pdfFilePath;
}


- (void)startSearchingWithQuery:(NSString *)qStr {
    
    qStr = [qStr stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
    qStr = [qStr stringByReplacingOccurrencesOfString:@"\""  withString:@"%22"];
    NSURL *url = [NSURL URLWithString:qStr];
    NSLog(@"url :%@",url);
    isVolumeParsing = NO;
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];

}

- (void)loadLatestArticles {
    
    _objSLService = [[SLService alloc] init];
    NSString *querry = [_objSLService search:nil
                                 startNumber:1 
                             numberOfResults:5 
                                 facetsQuery:nil 
                            constraintsQuery:nil 
                                   termsType:MostRecentType];
    NSLog(@"query : %@",querry);
    [self startSearchingWithQuery:querry];
}

- (void)performBasicSearch {
    
    NSString *XIBFileName = isIphone ? @"SearchResultViewController_iPhone" : @"SearchResult_Ipad";
    SearchResultViewController *objSearchResult=[[SearchResultViewController alloc]initWithNibName:XIBFileName bundle:nil] ;
    ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
    FacetsQuery *     facetsQuery      = [[FacetsQuery alloc] init];
    NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
    constraintsQuery.journalArray = arrJournals;
    constraintsQuery.openaccess = NO;
    objSearchResult.constraintsQuery = constraintsQuery;
    objSearchResult.facetsQuery = facetsQuery;
    objSearchResult.searchKey = [_searchBar text];
    objSearchResult.termsType = KeywordType;
    objSearchResult.currentSortBy = SortByRelevance;
    
    objSearchResult.isBasicSearch = YES;
    [self.navigationController pushViewController:objSearchResult animated:YES];
    [[Global shared] setSearchResultViewController:objSearchResult];
}



- (void)loadThumbinalImage {
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSCachesDirectory,
                                                            NSUserDomainMask, YES);
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath;
     NSString *urlString;
    
    if (isIphone) {
        filePath = [NSString stringWithFormat:@"%@/%@.jpg", docDirectory,kJournalID];
        urlString = [NSString stringWithFormat:@"http://coverimages.cmgsites.com/journal/%@.jpg",kJournalID];
        _thumbnailImgView.image = [UIImage imageWithContentsOfFile:filePath];
        
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@_ipad.jpg", docDirectory,kJournalID];
         urlString = [NSString stringWithFormat:@"ftp://ftp.springer.de/pub/covers/journals/%@.tif",kJournalID];
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath])
            [_appDelegate.articleDetailViewController.thumbnailView.thumbImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    }
    
    if(![DetectNetworkConnection isNetworkConnectionActive]) {
        
        if(_thumbnailImgView.image == nil)
            _thumbnailImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",kJournalID]];
               return;
    }
   
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    if (imageData) {
        [imageData writeToFile:filePath atomically:YES]; 
    }
     
    UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    isIphone ?  [_thumbnailImgView setImage:image] : [_appDelegate.articleDetailViewController.thumbnailView.thumbImageView setImage:image];

    if(_thumbnailImgView.image == nil)
        _thumbnailImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",kJournalID]];
}



// method for set badge number and downloaded PDF icon for all navigation bar
- (void)setBadgeImageView {
    
    if (isIphone) {
        [Global shared].lblBadge = [[UILabel alloc]initWithFrame:CGRectMake(1.5, 0, 13, 13)];
        [Global shared].imgViewBadge = [[UIImageView alloc]initWithFrame:CGRectMake(245 , 4, 16, 16)]; 
        [Global shared].btnPdfView = [UIButton buttonWithType:UIButtonTypeCustom];
        [[Global shared].btnPdfView setFrame:CGRectMake(251, 7, 30, 30)];
        [[Global shared].btnPdfView setImage:[UIImage imageNamed:@"btn_download_nav.png"] forState:UIControlStateNormal];
        
    } else {
        [Global shared].lblBadge = [[UILabel alloc]initWithFrame:CGRectMake(1.5, 0, 13, 13)];
        [Global shared].imgViewBadge = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 16, 16)]; 
        [Global shared].btnPdfView = [UIButton buttonWithType:UIButtonTypeCustom];
        [[Global shared].btnPdfView setFrame:CGRectMake(218, 7, 44, 30)];
        [[Global shared].btnPdfView setImage:[UIImage imageNamed:@"btn_download_ipad.png"] forState:UIControlStateNormal];
        
    }

    [Global shared].lblBadge.backgroundColor = [UIColor clearColor];
    // show badge number from NSUserDefaults if user not see the Downloaded PDF list View
    int badgeNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"badgeNumber"];
    [Global shared].badgeNumber = badgeNumber;
    [Global shared].lblBadge.text = [NSString stringWithFormat:@"%d",badgeNumber];
    [[Global shared].lblBadge setFont:[UIFont fontWithName:@"Helvetica-Bold" size:8]];
    [[Global shared].lblBadge setTextAlignment:UITextAlignmentCenter];
    [Global shared].lblBadge.textColor  = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
        
    [Global shared].imgViewBadge.image = [UIImage imageNamed:@"buzz_white.png"];
    [[Global shared].imgViewBadge addSubview:[Global shared].lblBadge];
   
    if (badgeNumber>0) {
     [[Global shared].imgViewBadge setHidden:NO]; 
        
    } else {
        [[Global shared].imgViewBadge setHidden:YES];
    }
    
    // show donloaded pdf icon in navigation bar if atleast 1 pdf is downloaded
    if ([[DBManager sharedDBManager] totalDownloadedPdfs] >= 1) {
        [[Global shared].btnPdfView setEnabled:YES];
        
    } else {
        [[Global shared].btnPdfView setEnabled:NO];
    }
    
    [[Global shared].btnPdfView addTarget:self action:@selector(btnDownloadPdfViewClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshTableView {
    
    ENSLog(self, _cmd);
    if([_articalListViewController.tableViewDataSource count]>0) {
        [_searchBar setText:@""];
        [_searchBar resignFirstResponder];
        [_lblLatestArticles setHidden:NO];
        [_articalListViewController reloadTableData];

        [_articalListViewController.view setHidden:NO];
         _articalListViewController.tableView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
        [_scrollView addSubview:_articalListViewController.view]; // add table view in main view
        [self performSelector:@selector(changeFrameOfTable) withObject:nil afterDelay:0.1];
    }
}


- (void)changeFrameOfTable {
    
    if (isIphone) {
        [_articalListViewController.view setFrame:CGRectMake(0,295 , 320, _articalListViewController.tableHeight)];
        [_scrollView setContentSize:CGSizeMake(320, _articalListViewController.tableHeight+295)];
        
    } else {
        
        [_articalListViewController.view setFrame:CGRectMake(0,260 , 320, _articalListViewController.tableHeight)];
        [_scrollView setContentSize:CGSizeMake(320, _articalListViewController.tableHeight+275)];
    }
    ENSLog(self, _cmd);
}

- (void)startParsingWithQuery:(NSString *)qStr {
    
    NSURL *url = [NSURL URLWithString:qStr];
    NSLog(@"url :%@",url);
    isVolumeParsing = YES;
    
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];
}


- (void)setMetaDataForJournal {
    
    VolumeListInfo * firstObjVolume = [_objVolumeXMLResponse.records objectAtIndex:0];
    VolumeListInfo * lastObjVolume = [_objVolumeXMLResponse.records lastObject];
    NSString *chiefeditor = [NSString stringWithFormat:@"Editor-in-Chief: %@",_objVolumeXMLResponse.Editor_in_Chief];
    int totalIssue = 0;
    
    for (VolumeListInfo *objVolume in _objVolumeXMLResponse.records) {
        totalIssue = totalIssue + [objVolume.arrayIssues count];
    }
    
    MetadataInfoResult *objresult = _response.currentResult;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:objresult.total]];
   
    // store journal metadata in NSUserDefaults for offline case
    NSMutableDictionary *metaDataDic = [[NSMutableDictionary alloc] init];
    [metaDataDic setObject:_objVolumeXMLResponse.journalName forKey:@"journalName"];
    [metaDataDic setObject:chiefeditor forKey:@"Editor_in_Chief"];
    [metaDataDic setObject:[NSString stringWithFormat:@"%@ - %@",lastObjVolume.year,firstObjVolume.year] forKey:@"volumeDate"];
    [metaDataDic setObject:[NSString stringWithFormat:@"%d",totalIssue] forKey:@"totalIssue"];
    [metaDataDic setObject:formattedNumberString forKey:@"totalArticle"];
    [metaDataDic setObject:[NSString stringWithFormat:@"%d",[_objVolumeXMLResponse.records count]] forKey:@"totalVolume"];
  
    [metaDataDic setObject:_objVolumeXMLResponse.publisherName forKey:@"publisherName"];
    [metaDataDic setObject:_objVolumeXMLResponse.JournalPrintISSN forKey:@"journalPrintISSN"];
    [metaDataDic setObject:_objVolumeXMLResponse.JournalElectronicISSN forKey:@"journalElectronicISSN"];
    [[NSUserDefaults standardUserDefaults] setObject:metaDataDic forKey:@"volumeMetadata"];
    [self setTextForLabel:metaDataDic];
    //creating about us page ...
    [[AboutUsCreator shared]createAboutUsPage];
}

// method for set offline metaData for journal 
- (void)setDefaultMetaDataForJournal {
    
    NSMutableDictionary * metadataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"volumeMetadata"];
    
    if (metadataDic) {
        [self setTextForLabel:metadataDic];
        [self setLabelFrame];
        
    } else {
      // store journal metadata in NSUserDefaults for offline case
        NSMutableDictionary *metaDataDic = [[NSMutableDictionary alloc] init];
        [metaDataDic setObject:kJournalName forKey:@"journalName"];
        [metaDataDic setObject:kEditor_in_Chief forKey:@"Editor_in_Chief"];
        [metaDataDic setObject:kVolumeDate forKey:@"volumeDate"];
        [metaDataDic setObject:kIssueNumber forKey:@"totalIssue"];
        [metaDataDic setObject:kArticleNumber forKey:@"totalArticle"];
        [metaDataDic setObject:kVolumeNumber forKey:@"totalVolume"];
        [metaDataDic setObject:kPublisherName forKey:@"publisherName"];
        [metaDataDic setObject:kJournalPrintISSN forKey:@"journalPrintISSN"];
        [metaDataDic setObject:kJournalElectronicISSN forKey:@"journalElectronicISSN"];
        
        [[NSUserDefaults standardUserDefaults] setObject:metaDataDic forKey:@"volumeMetadata"];
        [self setTextForLabel:metaDataDic];
        [self setLabelFrame];
    }
}

- (void)setTextForLabel:(NSDictionary*)metadataDic {

    _lblJournalName.text = [metadataDic objectForKey:@"journalName"];
    _lblChiefeditors.text = [metadataDic objectForKey:@"Editor_in_Chief"];
    _lblVolumeNumber.text = [metadataDic objectForKey:@"totalVolume"] ;
    _lblVolumeDate.text = [metadataDic objectForKey:@"volumeDate"];
    _lblIssueNumber.text   = [metadataDic objectForKey:@"totalIssue"];
    _lblArticleNumber.text = [metadataDic objectForKey:@"totalArticle"];
}

- (void)setLabelFrame {

    // set dynamic width for label lblVolumeNumber
    [_lblVolumeNumber setWidthOfLabelWithMaxWidth:50];
    [_lblVolume setFrame:CGRectMake(_lblVolumeNumber.frame.size.width+_lblVolumeNumber.frame.origin.x+klbloffset,_lblVolume.frame.origin.y, _lblVolume.frame.size.width, _lblVolume.frame.size.height)];
    // set dynamic width for label lblIssueNumber
    [_lblIssueNumber setWidthOfLabelWithMaxWidth:50];
    [_lblIssue setFrame:CGRectMake(_lblIssueNumber.frame.size.width+_lblIssueNumber.frame.origin.x+klbloffset,_lblIssue.frame.origin.y, _lblIssue.frame.size.width, _lblIssue.frame.size.height)];
    // set dynamic width for label lblArticleNumber
    [_lblArticleNumber setWidthOfLabelWithMaxWidth:50];
    [_lblArticle setFrame:CGRectMake(_lblArticleNumber.frame.size.width+_lblArticleNumber.frame.origin.x+klbloffset,_lblArticle.frame.origin.y, _lblArticle.frame.size.width, _lblArticle.frame.size.height)];
}

- (void)makeHeaderSearchViewVisible:(BOOL)shouldVisible {
    int margin;
    if (isIphone) {
        float searchBtnAlpha = (shouldVisible) ? .6 : 1;
        [_topSearchBtn setAlpha:searchBtnAlpha]; 
          margin = (shouldVisible) ? 46 : -46;
        
    } else {
    
        margin = (shouldVisible) ? 48 : -48;
        
        if(shouldVisible) {
            [_topSearchBtn setImage:[UIImage imageNamed:@"btn_search_dull_ipad.png"] forState:UIControlStateNormal];
            
        } else {
        [_topSearchBtn setImage:[UIImage imageNamed:@"btn_search_normal_ipad.png"] forState:UIControlStateNormal];
        }
        
    }
  
    CGRect frame = _scrollView.frame;
    frame.origin.y += margin;
    frame.size.height -= margin;
    _scrollView.frame = frame; 
    
    if([_articleArray count]) {
        
        frame = _articalListViewController.view.frame;
        frame.size.height -= margin;
        _articalListViewController.view.frame = frame;
    }
    
    [_headersearchView setHidden:!shouldVisible];
}

- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

- (void)creatAboutUsPageIfNotAvailable {
    
    NSString *htmlPath = (isIpad) ? [kCacheDir stringByAppendingFormat:@"/About/about_ipad_master.html"]: [kCacheDir stringByAppendingFormat:@"/About/about.html"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:htmlPath]) {
        [[AboutUsCreator shared]createAboutUsPage];
    } 
}

#pragma mark- ASIHTTPRequest delegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    if (isVolumeParsing) {
        [self.view addSubview:_loader];
        [_loader showLoader]; 
    }  
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (isVolumeParsing) {
        SLVolumeXMLParser *objParser =[[SLVolumeXMLParser alloc] init];
        [objParser setDelegate:self];
        [objParser parseXMLData:[request responseData]];  
        
    } else {
        
        SLMetadataXMLParser *metadataParser=[[SLMetadataXMLParser alloc] init]; //SLMetadataXMLParser object.
        [metadataParser setDelegate:self];
        [metadataParser parseXMLData:[request responseData]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"failed");
    [_loader hideLoader]; 
    _appDelegate.isResponseGet = YES;
    NSError *error= [request error];
    NSLog(@"error%d",[error code]);
    NSLog(@"error%@",[[error userInfo] objectForKey:NSUnderlyingErrorKey]);
    
    if ([error code] == 1) {
      [[[UIAlertView alloc]initWithTitle:@"No internet connection" message:@"Some features may not be available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] show];  
        
    } else if ([error code] == 2) {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"This feature is temporarily unavailable." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil] show];  
    }
}



#pragma mark- SLMetadataXMLParserDelegate Delegate

/*
 * delegate method for the latest article metadata.
 * @param: metadataResponse-> object of SLXMLResponse class which contain the metadata of articles
 */
- (void)returnMetadataResponse:(SLXMLResponse*)metadataResponse {
    
    [_loader hideLoader];  // hide the loader
    _response = metadataResponse;
    _articalListViewController.tableViewDataSource = metadataResponse.records;
    _articalListViewController.totalCount          = metadataResponse.currentResult.total; 
    [_articalListViewController  reloadTableData];
    [self setMetaDataForJournal]; // set metadata for journal label ,volume label, issue label etc.
    [self refreshTableView];     // load latest article in table
    _appDelegate.isResponseGet = YES; 
}
#pragma mark- SLVolumeXMLResponseDelegate 

/**
 * delegate method for the volume metadata.
 * @param: metadataResponse-> object of SLVolumeXMLResponse class which contain the metadata of volume
 */
-(void)returnVolumeMetadataResponse:(SLVolumeXMLResponse*)metadataResponse {
    
    /*
     set  SLVolumeXMLResponse object in Global class this global object used in VolumeListViewController class
     */
    [[Global shared] setVolumeXMLResponse:metadataResponse];
    _objVolumeXMLResponse = [Global shared].volumeXMLResponse;
    NSLog(@"SLVolumeXMLResponse get");
    [self loadLatestArticles];
}


#pragma mark - Implement UITableViewDataSource

- (void)onSelectingTableViewCell:(NSIndexPath*)indexPath  
    withTableViewDataSourceArray:(NSArray*)dataSourceArray {
    
    [_searchBar setText:@""];
    [_searchBar resignFirstResponder];
    
    if (indexPath.row == [dataSourceArray count] || isIphone) 
        return;
    if(isIpad) {
        _selectedIndex = indexPath.row;
         self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController,_appDelegate.articleDetailNavController, nil];
    }
}


#pragma mark- search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   
    _advCancelBtn.tag = 1;
    [self checkTitleOfAdvCancelBtn];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar  {
    
    _advCancelBtn.tag = 0;
    [self checkTitleOfAdvCancelBtn];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  {
    
    [searchBar resignFirstResponder];
    
    if ([[_searchBar text] length] <= 0) 
        return;
    
    if([[_searchBar text] isOnlySpace]) {
        
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not perform blank search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return;
    }
    
    if(![DetectNetworkConnection isNetworkConnectionActive]) {
        showAlert(NetworkErrorMessage);
        return;
    }
    
    [self performBasicSearch];
}

@end
