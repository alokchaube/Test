//
//  ArticleDetailPageViewController.m
//  SpringerLink
//
//  Created by prakash raj on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArticleDetailPageViewController.h"
#import "LoaderView.h"
#import "ApplicationConfiguration.h"
#import "Utility.h"

#import "DetectNetworkConnection.h"
#import "SearchResultViewController.h"
#import "FindControllerOnDifferentViewController.h"
#import "VolumeListViewController.h"
#import "AdvanceSearchViewController.h"
#import "DownloadedPDFListViewController.h"

#import "ServerRequestHandler.h"
#import "Global.h"
#import "DBManager.h"
#import "PDFDownloadInfo.h"
#import "DBArticle.h"
#import "PDFViewerViewController.h"
#import "PopWebViewController.h"
#import "UISearchBar+UISearchBar_TextColor.h"

#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kArticleFolderName @"Articles-Html"


@interface ArticleDetailPageViewController ()

- (void)showArticle:(Article *)article;
- (void)creatArticleHtmldir;
- (void)copyCSSToCache;
- (void)openMailComposer;
- (void)downloadPdf;
- (NSString *)pdfURL:(NSString*)doi;
- (void)saveArticletoDB:(Article *)article;
- (void)makeViewsLayoutAccToDown:(BOOL)flag;
- (void)checkEnabilityOfNextPrevBtns;
- (void)checkTitleOfAdvCancelBtn;
- (void)checkEnabilityOfFontsSizeButtons;
- (void)upButtomSearchView;
- (void)downButtomSearchView;
- (void)checkEnabilityOfsearchWithinNextPrevBtns;
@end


@implementation ArticleDetailPageViewController

@synthesize currentArticle           = _currentArticle;
@synthesize thumbnailView            = _thumbnailView;
@synthesize shouldNextDesableOnLast  = _shouldNextDesableOnLast;
@synthesize totalCount               = _totalCount;
@synthesize currentArticleNumber     = _currentArticleNumber;

short currentCss;
short currentStatus;
short _currentSearchResult;
short _totalSearchResult;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    if(_currentArticle != nil && isIphone) {
        [imgViewTopbar addSubview:[Global shared].imgViewBadge];
        [imgViewTopbar addSubview:[Global shared].btnPdfView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    currentCss = 1;
    [self checkEnabilityOfFontsSizeButtons];
    [self creatArticleHtmldir]; //create directory
    [self copyCSSToCache];   //copy all css
       
    CGRect loaderFrame = isIpad ? CGRectMake(0, 0, 1024, 768) : [[self view]bounds];
    _loader =  [[LoaderView alloc] initWithFrame:loaderFrame];
   
    if(_currentArticle == nil && isIpad) {
        [self makeHomeScreenLayout];
        
    } else if(isIphone) {
        
        [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
        [self makeViewsLayoutAccToDown:NO];//up
        [self showArticle:self.currentArticle];
        
        [_countView setHidden:YES];
        _withinArticleSearchview.frame = CGRectMake(0, 416, 320, 44);
        [[[_withinArticlesearchBar subviews]objectAtIndex:0]removeFromSuperview];
        [_withinArticlesearchBar setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
        [_withinArticlesearchBar setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
    } 
}

- (void)viewDidUnload {
    
    _loader = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   
    if (isIphone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation); // Support only portrait mode
    } else {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);  // Support only landscape mode
    }
}

#pragma mark - Public methods
//method to creat home screen layout.
- (void)makeHomeScreenLayout {
    
    _currentArticleNumber = -1;
    self.currentArticle = nil;
    NSArray *subViews = [self.view subviews];
    
    if (![subViews containsObject:_thumbnailView]) {
        
        _thumbnailView = [[ThumbnailView alloc] initWithFrame:CGRectMake(0, 0, 704, 768)];
        [_thumbnailView.thumbImageView setImage:[UIImage imageNamed:@"10853_ipad.jpg"]];
        [self.view addSubview:_thumbnailView];  
    }
    
    if([_articleDetailView superview] != nil) {
        [_articleDetailView removeFromSuperview];
    }
    
    if([self.callerDelegate respondsToSelector:@selector(setSelectedIndexOfTable:)])
        [self.callerDelegate setSelectedIndexOfTable:_currentArticleNumber];
}

/*
 * method to show article at index-
 * @param : index - index number of article in array.
 */
- (void)showArticleAtIndex:(short)index {
    
    if(self.articlesList != nil) {
        currentCss = 1;
        _currentArticleNumber = index;
        [self checkEnabilityOfFontsSizeButtons];
        [self checkEnabilityOfNextPrevBtns];
        NSLog(@"see the number %i",_currentArticleNumber);
        [self showArticle:[self.articlesList objectAtIndex:_currentArticleNumber]];
        
    }  
}

/*
 * method to set status of downloading.
 * @param : st - ststus to be set.
 */
- (void)setCurrentStatus:(NSInteger)st {
    [_articleDetailView setStatus:st];
}

#pragma mark- Button actions

-(IBAction)backClicked:(id)sender {
    
    if([_loader superview] != nil)
        [_loader removeFromSuperview];
    [_articleDetailView stopLoading];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)homeClicked:(id)sender {
    
    if([_loader superview] != nil)
        [_loader removeFromSuperview];
   [_articleDetailView stopLoading];
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
            AdvanceSearchViewController *nextViewController = [[AdvanceSearchViewController alloc]initWithNibName:@"AdvanceSearchViewController" bundle:nil];
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }
}

//----for iphone/ipad---
- (IBAction)changeFontClicked:(id)sender {
    
    ([sender tag] == 1) ? currentCss++ : currentCss--;
    [_articleDetailView uploadCssNumber:currentCss];
    [self checkEnabilityOfFontsSizeButtons];
}

//----for iphone/ipad---
- (IBAction)searchWithinArticleClicked:(id)sender {
    
    if(isIpad) {
        
    } else {
        [self.view addSubview:_withinArticleSearchview];
    }
}

//----for iphone/ipad---
- (IBAction)shareClicked:(id)sender {
    
    if(isIpad) {
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share by Email", nil];
        [actionSheet showInView:self.view];
    }
}

//----for ipad only--
- (IBAction)nextPrevClicked:(id)sender {
    
    ([sender tag]) ? _currentArticleNumber ++ : _currentArticleNumber --;
    
    if([self.callerDelegate respondsToSelector:@selector(setSelectedIndexOfTable:)])
        [self.callerDelegate setSelectedIndexOfTable:_currentArticleNumber];
    
    if (_currentArticleNumber <= [_articlesList count]-1)
        [self showArticleAtIndex:_currentArticleNumber];
}

- (IBAction)cancelDoneClicked:(id)sender {
    //-----remove search Buttom View----
    [_withinArticleSearchview removeFromSuperview];
    [_cancelDoneButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_withinArticlesearchBar setText:@""];
    [_articleDetailView clearInnerSearch];
    [_countLabel setText:@""];
    [_countView setHidden:YES];
    CGRect frame = _articleDetailView.webView.frame;
    frame.size.height += 45;
    _articleDetailView.webView.frame = frame;
}

- (IBAction)searchWithinNextPrevClicked:(id)sender {
    
    short prevIndex = _currentSearchResult;
    _currentSearchResult += [sender tag];
    [self checkEnabilityOfsearchWithinNextPrevBtns];
    [_articleDetailView makeSelectionAtText:_currentSearchResult andUnselectPrevIndex:prevIndex];
}

//----cell button action code targated--
- (void)downloadPdf {
    
    Article *article                = self.currentArticle;
    RequestHandler *objRequest      = [[RequestHandler alloc] init];
    objRequest.delegate             = [Global shared];//self;
    objRequest.selector             = @selector(onRecievingPdfServerResponse:objectInfoDictionary:);
    objRequest.serverURL            = [self pdfURL:article.doi];
    objRequest.isHeader             = YES;
    objRequest.doi                  = article.doi;
    ServerRequestHandler *objServer = [ServerRequestHandler sharedRequestHandler];
    
    [objServer addRequest:objRequest];
    [objServer.doiArray addObject:article.doi];
    [objServer startRequets];
    [self saveArticletoDB:article];
}

#pragma mark- private methods
/*
 * method to show article.
 * @param : article - pass an article to show
 */
- (void)showArticle:(Article *)article {
    
    self.currentArticle = article;
    [[Global shared] setArticleDetailPageViewController:self];
    
    //only ipad
    if([_thumbnailView superview] != nil && isIpad)
        [_thumbnailView removeFromSuperview];
    
    if(_articleDetailView == nil) {
        CGRect frame = (isIpad) ? CGRectMake(0, 44, 702, 724) : CGRectMake(0, 44, 320 , 415);
        _articleDetailView = [[ArticleDetailView alloc]initWithFrame:frame];
        _articleDetailView.delegate = self;
    } 
    
    if([_articleDetailView superview] == nil) {
        [self.view addSubview:_articleDetailView];
        [self.view sendSubviewToBack:_articleDetailView];
    }
    
    [_articleDetailView showArticle:article];
}

//---method to creat directory
- (void)creatArticleHtmldir {
    
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    
    if(![_fileManager fileExistsAtPath:[kCacheDir stringByAppendingFormat:@"/%@",kArticleFolderName]]) {
        if([_fileManager createDirectoryAtPath:[kCacheDir stringByAppendingFormat:@"/%@",kArticleFolderName] withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"dir created");
    }
}

//Method to copy all CSS files to cache directory.
- (void)copyCSSToCache {
    
    NSString *_cssName = (isIpad) ? @"ipad_style" : @"style";
    
    for(int k = 1; k <= 3; k++) {
        
        NSString *cssStr = [NSString stringWithFormat:@"%@%i.css",_cssName,k];
        NSString *cssSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:cssStr];
        
        NSString *cssDestPath = [kCacheDir stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",kArticleFolderName,cssStr]];
        NSError *error;
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if(![filemgr fileExistsAtPath:cssDestPath]) {
            if([filemgr copyItemAtPath:cssSourcePath 
                                toPath:cssDestPath
                                 error:&error]) {
                NSLog(@"copied");
            } 
        }
    }
}

//----Method to open mail composer
- (void)openMailComposer {
    
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Email is not configured in this device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
        alrt = nil;
        return;
    }

    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
    [mailComposer setMailComposeDelegate:self];
    NSString *subject = [NSString stringWithFormat:@"Recommended article from %@",kJournalName];
    [mailComposer setSubject:subject];
    [mailComposer setBccRecipients:nil];
    [mailComposer setCcRecipients:nil];
    
    Article *record = self.currentArticle;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *mnthStr = [formatter stringFromDate:record.publicationDate];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *yrStr = [formatter stringFromDate:record.publicationDate];
    NSString *nmStr = [NSString stringWithFormat:@"<BR>%@,Volume %@,%@ %@,Pages %@",
                         kJournalName,record.volume,mnthStr,yrStr,record.startingPage];
    NSString *artcleLink = [NSString stringWithFormat:
                            @"http://www.springerlink.com/content/%@/",kAPIKey];
    
    NSString *bodyMessage = [NSString stringWithFormat:@"<HTML><Head><style type=\"text/css\">a {text-decoration:none;text-align: left;font-size: 10pt;font-family: Helvetica neue;color: #0176C3;}  p {font-size: 10pt;text-align: left;font-family: Helvetica neue;color: #333333;}</style></Head><BODY><p>I thought you would find this article useful.</p><a href=\"%@\">%@</a><p>%@<BR>%@<BR>doi:%@</p></BODY></HTML>",artcleLink,record.title,nmStr,record.authors,record.doi];
    
    [mailComposer setMessageBody:bodyMessage isHTML:YES];
    [self presentModalViewController:mailComposer animated:YES];
}
/*
 * method to get pdf url of doi.
 * @param : doi - doi of article.
 */
- (NSString *)pdfURL:(NSString *)doi {
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", kPDFURL,doi];
    return urlStr;
}

/*
 * method to save article to database.
 * @param : srticle - specify article to save.
 */
- (void)saveArticletoDB:(Article *)article {
    
    if(![[DBManager sharedDBManager] isDoi:article.doi existInTable:@"PDFTable"]) {
        
        PDFDownloadInfo *pdf = [[PDFDownloadInfo alloc] init];
        pdf.doi = article.doi;
        pdf.name = @"";
        pdf.downloadStatus = PDFIsDownloading;
        pdf.isPDFFileRead = NO;
        [[DBManager sharedDBManager] savePDF:pdf];
        
        if(![[DBManager sharedDBManager] isDoi:article.doi existInTable:@"ArticleTable"]) {
            
            DBArticle *dbArticle = [[DBArticle alloc] init];
            dbArticle.title = article.title;
            dbArticle.type = @"Article";
            dbArticle.journalNo = article.journalId;
            dbArticle.authors = article.authors;
            dbArticle.doi = article.doi; 
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MM-yyyy"];
            dbArticle.date = [formatter stringFromDate:article.publicationDate];
            [[DBManager sharedDBManager] saveArticle:dbArticle];
        }
        
    } else {
        
        [[DBManager sharedDBManager]changeStatusOfPdfWithDoi:article.doi withStatus:2];
    }
    [self setCurrentStatus:2];
}

//  YES/NO: Down/Up- only for basic search
- (void)makeViewsLayoutAccToDown:(BOOL)flag {
    
    float searchBtnAlpha = (flag) ? .6 : 1;
    [_topSearchBtn setAlpha:searchBtnAlpha];
    
    int margin = (flag) ? 44 : -44;
    
    CGRect frame = _articleDetailView.frame;
    frame.origin.y += margin;
    frame.size.height -= margin;
    _articleDetailView.frame = frame;
        
    [_headersearchView setHidden:!flag];
}


- (void)checkEnabilityOfNextPrevBtns {
    
    if(_currentArticleNumber == 0) {
        [_prevbtn setEnabled:FALSE]; 
        [_nextbtn setEnabled:TRUE];
        
    } else if ((_currentArticleNumber == [_articlesList count]-1 && _shouldNextDesableOnLast) ||(self.totalCount == _currentArticleNumber + 1)){
        [_nextbtn setEnabled:FALSE];
        [_prevbtn setEnabled:TRUE];
        
    } else {
        [_nextbtn setEnabled:TRUE];
        [_prevbtn setEnabled:TRUE];
    }
}

- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
}

- (void)checkEnabilityOfFontsSizeButtons {
    
    [_fontIncreasebtn setEnabled:(currentCss < 3)];
    [_fontDecreasebtn setEnabled:(currentCss > 1)];
}

//------methods for search within article--
- (void)upButtomSearchView {
    
    [UIView beginAnimations:@"moveField" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	_withinArticleSearchview.frame = CGRectMake(0, 200, 320, 44);
	[UIView commitAnimations];
    //_cancelDoneButton.tag = 1;
}

- (void)downButtomSearchView {
    
    [UIView beginAnimations:@"moveField" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [_withinArticlesearchBar resignFirstResponder];
	_withinArticleSearchview.frame = CGRectMake(0, 416, 320, 44);
	[UIView commitAnimations];
   // _cancelDoneButton.tag = 0;
}

- (void)checkEnabilityOfsearchWithinNextPrevBtns {
    
    [_searchWithinPrevBtn setEnabled:(_totalSearchResult > 0 && _currentSearchResult > 1)];
    [_searchWithinNextBtn setEnabled:(_totalSearchResult > 0 && _currentSearchResult < _totalSearchResult)];
}
//-----

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    if(searchBar == _withinArticlesearchBar) {
        [self upButtomSearchView];
        [_cancelDoneButton setTitle:@"Cancel" forState:UIControlStateNormal];
        
    } else {
        _advCancelBtn.tag = 1;
        [self checkTitleOfAdvCancelBtn];
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    if(searchBar == _withinArticlesearchBar) {
        [self downButtomSearchView];
        
    } else {
        _advCancelBtn.tag = 0;
        [self checkTitleOfAdvCancelBtn];
    }
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    if(searchBar == _withinArticlesearchBar) {
        //--------for buttom search bar------
        [self downButtomSearchView];
        _totalSearchResult = [_articleDetailView searchText:searchBar.text];
        
        if(_totalSearchResult > 0) {
            _currentSearchResult = 1;
            NSString *message = (_totalSearchResult > 1) ? [NSString stringWithFormat:@"%i Results",_totalSearchResult]:[NSString stringWithFormat:@"%i Result",_totalSearchResult];
            [_countLabel setText:message];
            [_articleDetailView makeSelectionAtText:_currentSearchResult andUnselectPrevIndex:0];
            [_cancelDoneButton setTitle:@"Done" forState:UIControlStateNormal];
            
        } else {
            _currentSearchResult = 0;
            [_countLabel setText:@"No Results"];
            [_cancelDoneButton setTitle:@"Cancel" forState:UIControlStateNormal];
        }
        
        [self checkEnabilityOfsearchWithinNextPrevBtns];
        
        CGRect frame = _articleDetailView.webView.frame;
        frame.size.height -= 45;
        _articleDetailView.webView.frame = frame;
        [_countView setHidden:NO];
        return; 
    } 
    
    //--------for top search bar------
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


#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet 
willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"%i",buttonIndex);
    
    if(buttonIndex == 0){
        [self openMailComposer];//mail
    }
}

#pragma mark- MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error {
    
    [controller dismissModalViewControllerAnimated:YES];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultSent:
            msg=@"Mail sent successfully.";
            break;
        case MFMailComposeResultSaved:
            msg=@"Mail saved to draft successfully.";
            break;
        case MFMailComposeResultFailed:
            msg=@"Error found.";
            break;
        case MFMailComposeResultCancelled:
            msg=@"Mail cancelled.";
            break;
            
        default:
            break;
    }
    
    UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alrt show];
    alrt = nil;
}

#pragma mark - ArticleDetailViewDelegate -

- (void)addLoader:(BOOL)flag {
    
    if(flag) {
        
        (isIphone) ? [self.view addSubview:_loader] : [self.splitViewController.view addSubview:_loader];
        [_loader showLoader];
        
    } else {
        
         [_loader removeFromSuperview];
    }
}

- (void)downloadBtnClicked {
    if(currentStatus == PDFHasDownloaded) {
        //move to view PDF.
        
        if(isIpad) {
            DownloadedPDFListViewController *objDownloadList = [[DownloadedPDFListViewController alloc] initWithNibName:@"DownloadListViewController_ipad" bundle:nil];
            objDownloadList.pdfFileName = self.currentArticle.doi;
            
            UINavigationController *navController = [[self.splitViewController viewControllers]objectAtIndex:0];
            [navController pushViewController:objDownloadList animated:YES];
            
        } else {
            
            PDFViewerViewController* viewController = [[PDFViewerViewController alloc] initWithNibName:@"PDFViewerViewController_iPhone" bundle:nil];
            viewController.pdfFileName = _currentArticle.doi;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        [[Global shared] refereshTableDataWithStatus:PDFHasDownloaded];
        
    } else if(currentStatus == PDFIsDownloading) {
        //do nothing , it is under downloading...
        
    } else {
        // do download...
        [self downloadPdf];
    }
}

/* 
 * method to open reference link with link string.
 * @param : linkUrlStr - pass link in string formate 
 */
- (void)openRefLink:(NSString *)linkUrlStr {
    
    NSLog(@"see ref link:%@",linkUrlStr);
    PopWebViewController *nextViewController;
    
    if(isIpad) {
        nextViewController = [[PopWebViewController alloc] initWithNibName:@"PopWebViewController"bundle:nil];
        nextViewController.webURLStr = linkUrlStr;
        [nextViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [nextViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self.splitViewController presentModalViewController:nextViewController animated:YES];
        
    } else {
        nextViewController = [[PopWebViewController alloc] initWithNibName:@"PopWebViewController_iphone"bundle:nil];
        nextViewController.webURLStr = linkUrlStr;
        [self presentModalViewController:nextViewController animated:YES];
    }
}

@end