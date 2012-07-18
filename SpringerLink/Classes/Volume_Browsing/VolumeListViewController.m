
//
//  VolumeListViewController.m
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "VolumeListViewController.h"
#import "IssueCell.h"

#import "SpringerLinkAppDelegate.h"

#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "SLVolumeXMLResponse.h"
#import "Utility.h"
#import "Constant.h"
#import "IssueDetailViewController.h"
#import "SearchResultViewController.h"
#import "FindControllerOnDifferentViewController.h"
#import "ApplicationConfiguration.h"
#import "Global.h"
#import "DBManager.h"

#import "AdvanceSearchViewController.h"

#import "SpringerLinkAppDelegate.h"
#import "IssuesInfo.h"
#import "OnlineArticleListViewController.h"


@interface VolumeListViewController ()

@property (nonatomic, strong) NSMutableArray* sectionInfoArray;
@property (nonatomic, assign) NSInteger openSectionIndex;

//
- (NSString *)getHeaderDateFormate:(NSString*)strDate;
- (NSString *)getIssueDateFormate:(NSString*)strDate;
- (void)loadVolumeXMLdata ;
- (void)makeViewsLayoutAccToDown:(BOOL)flag;
- (void)checkTitleOfAdvCancelBtn;



@end

#define DEFAULT_ROW_HEIGHT 45
#define HEADER_HEIGHT 45


@implementation VolumeListViewController

@synthesize arrayVolumes=arrayVolumes_, sectionInfoArray=sectionInfoArray_, quoteCell=newsCell_, openSectionIndex=openSectionIndex_;

NSIndexPath *_selectedIndexPath;

#pragma mark Initialization and configuration

-(BOOL)canBecomeFirstResponder {

    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (isIphone) {
        [imgViewTopbar addSubview:[Global shared].imgViewBadge];
        [imgViewTopbar addSubview:[Global shared].btnPdfView];
        
    } else {
        [[Global shared].btnPdfView addSubview:[Global shared].imgViewBadge];
        [imgViewTopbar addSubview:[Global shared].btnPdfView];
        
//        SpringerLinkAppDelegate *appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
//        [appDelegate.articleDetailViewController makeHomeScreenLayout];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    if (isIpad) {
//        NSIndexPath *_indexPath = [tblView indexPathForSelectedRow];
//        [tblView deselectRowAtIndexPath:_indexPath animated:YES];
//        _selectedIndexPath = nil;
//        selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    [[[_searchBar subviews]objectAtIndex:0]removeFromSuperview];
    [_headersearchView setHidden:YES];
    
    tblView.sectionHeaderHeight = (isIpad) ? HEADER_HEIGHT+20 : HEADER_HEIGHT; 
    openSectionIndex_ = NSNotFound;
    
    [self performSelector:@selector(loadVolumeXMLdata) withObject:nil];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
    if (isIpad) {
        selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
	self.sectionInfoArray = nil;
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

#pragma mark- Private Methods

- (NSString *)getHeaderDateFormate:(NSString*)strDate {
    NSString *str;
    if (isIpad) {
      
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *objEndDate = [dateFormat dateFromString:strDate];
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"MMMM yyyy"];
        str = [dateFormat2 stringFromDate:objEndDate];
        NSLog(@"%@",str);
    }
    else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *objEndDate = [dateFormat dateFromString:strDate];
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"MM/yy"];
        str = [dateFormat2 stringFromDate:objEndDate];
        NSLog(@"%@",str);
    }
    
    return str;
}

- (NSString *)getIssueDateFormate:(NSString*)strDate {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *objEndDate = [dateFormat dateFromString:strDate];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:@"MMMM yyyy"];
    NSString *str = [dateFormat2 stringFromDate:objEndDate];
    NSLog(@"%@",str);
    return str;
}


- (void)loadVolumeXMLdata {
    
    SLVolumeXMLResponse *objResponse = [Global shared].volumeXMLResponse;
    self.arrayVolumes = [[NSMutableArray alloc] init];
    
    for (int i =0; i<[objResponse.records count]+1; i++) {
        if (i==0) {
            VolumeListInfo *objVolume = [[VolumeListInfo alloc] init];
            objVolume.startId = @"";
            objVolume.endId  = @"";
            IssuesInfo *objIssue = [[IssuesInfo alloc] init];
            objIssue.title = [NSMutableString stringWithString:@"Online issue"];
            objVolume.arrayIssues = [NSMutableArray arrayWithObject:objIssue];
            [self.arrayVolumes addObject:objVolume];
        }
        else {
            VolumeListInfo * objVolume = [objResponse.records objectAtIndex:i-1];
            [self.arrayVolumes addObject:objVolume];
 
        }
    } 
    // code for display volume number in label
    VolumeListInfo *objFirstIssue = [self.arrayVolumes objectAtIndex:1];
    NSString *startDate = [NSString stringWithFormat:@"Volume %d / %@",[self.arrayVolumes count],objFirstIssue.year];
    VolumeListInfo *objLastIssue = [self.arrayVolumes lastObject];
    NSString *endDate = [NSString stringWithFormat:@"Volume 1 / %@",objLastIssue.year];
    NSString *volumeDate = [NSString stringWithFormat:@"%@ - %@",endDate,startDate];
    _lblVolumeDate.text = volumeDate;
    //
    NSMutableArray *infoArrays = [[NSMutableArray alloc] init];

    for ( VolumeListInfo *objVolume in self.arrayVolumes) {
        
        SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
        sectionInfo.objectVolume = objVolume;
        sectionInfo.open = NO;
        float height = (isIpad) ? DEFAULT_ROW_HEIGHT+20 : DEFAULT_ROW_HEIGHT;
        NSNumber *defaultRowHeight = [NSNumber numberWithInteger:height];
        NSInteger countOfQuotations = [[sectionInfo.objectVolume arrayIssues] count];
        
        for (NSInteger i = 0; i < countOfQuotations; i++) {
            [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
        }
        
        [infoArrays addObject:sectionInfo];
    }
    
    self.sectionInfoArray = infoArrays;
    [tblView reloadData];
    
    if(isIpad) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self tableView:tblView didSelectRowAtIndexPath:indexPath];
        [tblView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
 
}

//  YES/NO: Down/Up- only for basic search
- (void)makeViewsLayoutAccToDown:(BOOL)flag {
    
    float searchBtnAlpha = (flag) ? .6 : 1;
    [_topSearchBtn setAlpha:searchBtnAlpha];
    
    int margin = (flag) ? 44 : -44;
    
    CGRect frame = _detailView.frame;
    frame.origin.y += margin;
    frame.size.height -= margin;
    _detailView.frame = frame;
    
    [_headersearchView setHidden:!flag];
}

- (void)checkTitleOfAdvCancelBtn {
    
    NSString *_imageName = (_advCancelBtn.tag) ? @"btn_cancel.png" : @"btn_adv.png";
    [_advCancelBtn setImage:[UIImage imageNamed:_imageName] 
                   forState:UIControlStateNormal];
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

#pragma mark Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    NSLog(@"Count:%d",[self.arrayVolumes count]);
    return [self.arrayVolumes count];
    
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
        SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
        NSInteger numStoriesInSection = [[sectionInfo.objectVolume arrayIssues] count];
        
        return sectionInfo.open ? numStoriesInSection : 0;  
    
     
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *cellIdentifier = @"QuoteCellIdentifier";
    IssueCell *cell = (IssueCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[IssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;        
        
        if(_selectedIndexPath == indexPath) {
            [cell setSelected:YES];
        }
    }
    if (indexPath.section == 0) {
        cell.quotation = Nil;
        cell.titleLabel.text = @"View articles not yet assigned to an issue";
    }
    else {
        VolumeListInfo *objVolume = (VolumeListInfo *)[[self.sectionInfoArray objectAtIndex:indexPath.section] objectVolume];
        cell.quotation = [objVolume.arrayIssues objectAtIndex:indexPath.row];
        
        if(isIpad) {
            UIView *_backView = [[UIView alloc] initWithFrame:cell.contentView.frame];
            _backView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
            cell.selectedBackgroundView = _backView;
        } 
    }
      
    return cell;
}
 

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
    
       
        SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
        if (!sectionInfo.headerView) {
            if (section == 0) {
                float hight;
                if (isIpad) {
                    hight = HEADER_HEIGHT+20;
                }
                else {
                    hight = HEADER_HEIGHT;
                }
                sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tblView.bounds.size.width, hight) title:@"Online First Articles" date:@"" section:section delegate:self]; 
            }
            else {
                IssuesInfo *objFirstIssue = [sectionInfo.objectVolume.arrayIssues objectAtIndex:0];
                NSString *startDate = [NSString stringWithFormat:@"%@-%@-01",objFirstIssue.year,objFirstIssue.month];
                IssuesInfo *objLastIssue = [sectionInfo.objectVolume.arrayIssues lastObject];
                NSString *endDate = [NSString stringWithFormat:@"%@-%@-01",objLastIssue.year,objLastIssue.month];
                NSString *issueDate = [NSString stringWithFormat:@"(%@ - %@)",[self getHeaderDateFormate:endDate],[self getHeaderDateFormate:startDate]];
                NSString *volumeInfo =[NSString stringWithFormat:@"Volume %@ - %d Issues",sectionInfo.objectVolume.startId ,[sectionInfo.objectVolume.arrayIssues count]] ;
                float hight;
                if (isIpad) {
                    hight = HEADER_HEIGHT+20;
                }
                else {
                    hight = HEADER_HEIGHT;
                }
                sectionInfo.headerView = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tblView.bounds.size.width, hight) title:volumeInfo date:issueDate section:section delegate:self];
            }
            
            
        }
    return  sectionInfo.headerView;

}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    float height;
    if (indexPath.section == 0) {
        if (isIpad) {
            height = 65;
        }
        else {
          height = 45;  
        }
        
    }
    else {
        SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
        height =  [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    }
    return height;
	
    // Alternatively, return rowHeight.
}


- (void)tableView:(UITableView*)tableView 
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if (selectedIndexPath.row == indexPath.row && 
        selectedIndexPath.section == indexPath.section && isIpad)         
        return;
    
    if (indexPath.section == 0) {
      
        NSString *xibName = (isIpad) ? @"OnlineArticleListViewController_ipad" : @"OnlineArticleListViewController";
        
        OnlineArticleListViewController *objOnlineView = [[OnlineArticleListViewController alloc]initWithNibName:xibName bundle:Nil] ;

        ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
        FacetsQuery *     facetsQuery      = [[FacetsQuery alloc] init];
        NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
        constraintsQuery.journalArray = arrJournals;
        constraintsQuery.openaccess = NO;
        constraintsQuery.onlineFirst = YES;
        objOnlineView.constraintsQuery = constraintsQuery;
        objOnlineView.facetsQuery = facetsQuery;
        objOnlineView.searchKey =[NSString stringWithFormat:@"issn:%@",[Global shared].volumeXMLResponse.JournalElectronicISSN];  //@"issn:1573-4803 
        objOnlineView.termsType = MostRecentType;
       [[Global shared] setOnlineArticleListViewController:objOnlineView];  
        
        if(isIpad) {
            
            objOnlineView.shouldShowInDetailArea = YES;
            UINavigationController *_detailNavController = [[UINavigationController alloc]initWithRootViewController:objOnlineView];
            [_detailNavController setNavigationBarHidden:YES];
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _detailNavController, nil];
            
        } else {
            
            [self.navigationController pushViewController:objOnlineView animated:YES];
        }
    }
    else {
        
        
        NSString *_xibName = (isIpad) ? @"IssueDetailViewController_ipad" : @"IssueDetailViewController";
        
        VolumeListInfo *objVolume = [self.arrayVolumes objectAtIndex:indexPath.section];
        IssuesInfo *objFirstIssue = [objVolume.arrayIssues objectAtIndex:indexPath.row];
        NSString *strDate = [NSString stringWithFormat:@"%@-%@-01",objFirstIssue.year,objFirstIssue.month];
        strDate =  [self getIssueDateFormate:strDate];
        NSString *strIssueDetail = [NSString stringWithFormat:@"Volume %@, Issue %@, %@, pp %@-%@",objVolume.startId,objFirstIssue.startId,strDate,objFirstIssue.startPage,objFirstIssue.endPage];
        
        IssueDetailViewController *objIssuedetail = [[IssueDetailViewController alloc] initWithNibName:_xibName bundle:nil];
        objIssuedetail.strIssueDetail  = strIssueDetail;
        objIssuedetail.strIssueNumber  = objFirstIssue.startId; 
        objIssuedetail.strVolumeNumber = objVolume.startId;
        objIssuedetail.strIssnPrint    = [NSString stringWithFormat:@"ISSN: %@ (Print) %@ (Online)",[Global shared].volumeXMLResponse.JournalElectronicISSN,[Global shared].volumeXMLResponse.JournalPrintISSN];
        //
        ConstraintsQuery* constraintsQuery = [[ConstraintsQuery alloc] init];
        FacetsQuery *     facetsQuery      = [[FacetsQuery alloc] init];
        NSArray *arrJournals = [NSArray arrayWithObject:kJournalName];
        constraintsQuery.journalArray = arrJournals;
        constraintsQuery.openaccess = NO;
        objIssuedetail.constraintsQuery = constraintsQuery;
        objIssuedetail.facetsQuery = facetsQuery;
        objIssuedetail.searchKey =[NSString stringWithFormat:@"issn:%@ volume:%@ issue:%@",[Global shared].volumeXMLResponse.JournalElectronicISSN,objVolume.startId,objFirstIssue.startId];  //@"issn:1573-4803 volume:24 issue:3";
        objIssuedetail.termsType = SequenceType;
        
        if(isIpad) {
            
            objIssuedetail.shouldShowInDetailArea = YES;
            UINavigationController *_detailNavController = [[UINavigationController alloc]initWithRootViewController:objIssuedetail];
            [_detailNavController setNavigationBarHidden:YES];
            self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _detailNavController, nil];
            
        } else {
            
            [self.navigationController pushViewController:objIssuedetail animated:YES];
        }
        
        [[Global shared] setIssueDetailViewController:objIssuedetail];  
    }
    
    if(isIphone)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndexPath = indexPath;
}


#pragma mark Section header delegate

- (void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.objectVolume.arrayIssues count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];

    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.objectVolume.arrayIssues count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [tblView beginUpdates];
    [tblView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [tblView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tblView endUpdates];
    self.openSectionIndex = sectionOpened;
     
}


- (void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [tblView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [tblView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

@end
