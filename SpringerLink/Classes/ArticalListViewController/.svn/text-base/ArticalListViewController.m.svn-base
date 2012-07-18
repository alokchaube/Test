//
//  ArticalListViewController.m
//  SpringerLink
//
//  Created by Kiwitech on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArticalListViewController.h"
#import "SearchResultsCell.h"
#import "SLXMLResponse.h"
#import "UILabelExtended.h"
#import "PDFDownloadInfo.h"
#import "DBManager.h"
#import "Utility.h"
#import "SearchResultViewController.h"
#import "ArticleDetailPageViewController.h"
#import "Global.h"
#import "PDFViewerViewController.h"
#import "ServerRequestHandler.h"
#import "DBArticle.h"
#import "ApplicationConfiguration.h"
#import "LatestArticleListViewController.h"
#import "SpringerLinkAppDelegate.h"
#import "SearchResultCellIpad.h"
#import "DownloadedPDFListViewController.h"

#define koffset 3     

@implementation ArticalListViewController
@synthesize articalListViewType  = _articalListViewType;
@synthesize tableViewDataSource  = _tableViewDataSource;
@synthesize tableHeight          = _tableHeight;
@synthesize callbackDelegate     = _callbackDelegate;
@synthesize navController        = _navController;
@synthesize totalCount           = _totalCount;
@synthesize tableView            = _tableView;

@synthesize shouldLargeCell = _shouldLargeCell;

@synthesize selectedindex = _selectedindex;


BOOL isShowMoreFromArticleDetail; //taken to identify whether next clicked or show more.

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

- (void)viewDidLoad
{
    _selectedindex = -1;
    isShowMoreFromArticleDetail = NO;
    
    _tableHeight = 0.0f;
    _pdfBtnArray = [[NSMutableArray alloc] init];
    
    if(_articalListViewType == HomeLatestArticalListType) {
        _tableView.scrollEnabled = NO;
        
    }else if(_articalListViewType == IssueListArticleType || _articalListViewType == SearchResultArticalListType) {
        _tableView.scrollEnabled = YES;
    }
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_articalListViewType == HomeLatestArticalListType || _articalListViewType == IssueListArticleType || _articalListViewType == SearchResultArticalListType) {
        
        if(_totalCount > [_tableViewDataSource count])    
            return [_tableViewDataSource count] + 1;
        else
            return [_tableViewDataSource count];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Calculating height of tableview according to message length
    float height;
    
    
    if (indexPath.row == [_tableViewDataSource count]) {
        
        height = 44;
        _tableHeight += height;
        return height;
    }
    
    Article* record = [_tableViewDataSource objectAtIndex:indexPath.row];
    NSString *title = record.title;
    
    CGSize size;
    short offSet;
    
    if (self.shouldLargeCell) {
        
        CGSize  textSize = { 600.0, 10000.0 };
        size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:18] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        offSet = 74;
    }
    else {
        CGSize  textSize = { 300.0, 10000.0 };
        
        if (isIphone) {
            size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];  
        }
        else{
            size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap]; 
        }
        offSet = 70;
    }
    
    size.height += offSet;
    height = size.height < 65 ? 65 : size.height;
    _tableHeight += height;
    
    return height;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isIphone) {
        
        NSString *cellIdentifier = [NSString stringWithFormat:@"SearchResultsViewCell%d%d",indexPath.row,indexPath.section];
        SearchResultsCell *cell = (SearchResultsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        cell = [[SearchResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;        
        
        if (indexPath.row == [_tableViewDataSource count]) {
            
            UILabel *lblShowMore;
            lblShowMore = [[UILabel alloc] initWithFrame:CGRectMake(110, 16, 100, 13)];
            lblShowMore.backgroundColor = [UIColor clearColor];
            lblShowMore.textColor  = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
            lblShowMore.text = @"Show more...";
            
            [lblShowMore setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
            
            
            
            lblShowMore.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            lblShowMore.tag = 1000;
            [cell addSubview:lblShowMore];
            
            //
            cell.articlelabel.text = @"";
            cell.titleLabel.text   = @"";
            cell.authorsLabel.text = @"";
            [cell.titleLabel setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.btnPdfDownload setImage:nil forState:UIControlStateNormal];
            
        } else {
            
            Article* record = [_tableViewDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = @"";
            cell.articlelabel.text = @"";
            cell.titleLabel.text = record.title;
            
            //
            if (_articalListViewType == IssueListArticleType) {
                //[cell.articlelabel setFrame:CGRectMake(cell.articlelabel.frame.origin.x, cell.articlelabel.frame.origin.y, 0, 0)]; 
            }
            
            [cell.articlelabel setHeightOfLabel];
            // cell.titleLabel.delegate =self;
            //
            NSString *title = record.title;
            [cell.titleLabel setFrame:CGRectMake(12, 14, 300, 10)];
            CGSize  textSize = { cell.titleLabel.frame.size.width, 10000.0 };
            // set dynamic height for titleLabel.
            CGSize size;
            
                size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];  
           
            
            float height = size.height < 27 ? 27 : size.height+10;
            //[cell.titleLabel setFrame:CGRectMake(12, 14, 300, height)];
            [cell.titleLabel setFrame:CGRectMake(12, cell.articlelabel.frame.origin.y+cell.articlelabel.frame.size.height, 300, height)];
            // set dynamic width for authorLabel.
            
            NSString *autherStr = [[record allAuthors] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            cell.authorsLabel.text = autherStr;
            cell.dateLabel.text    = [NSString stringWithFormat:@" (%@)",
                                      [record composeVolumeNumberPage]];
            
            [cell.authorsLabel setWidthOfLabelWithMaxWidth:170];    
            CGRect frame = cell.authorsLabel.frame;//cell.authorsLabel.frame;
            frame.origin.y = cell.titleLabel.frame.origin.y+cell.titleLabel.frame.size.height+koffset;
            cell.authorsLabel.frame = frame;
            
            frame = cell.dateLabel.frame;//cell.authorsLabel.frame;
            frame.origin.y = cell.authorsLabel.frame.origin.y;
            frame.origin.x = cell.authorsLabel.frame.origin.x + cell.authorsLabel.frame.size.width;
            cell.dateLabel.frame = frame;
            
            [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height+koffset, cell.btnPdfDownload.frame.size.width, cell.btnPdfDownload.frame.size.height)];
            [cell.btnPdfDownload setTag:indexPath.row+666];
            [cell.btnPdfDownload addTarget:self action:@selector(btnDownloadpdfClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *pdfbtnTitle = @" Download PDF";
            
            cell.authorsLabel.text = autherStr;
            cell.dateLabel.text    = [NSString stringWithFormat:@" (%@)",[record composeVolumeNumberPage]];
            ///
            PDFDownloadStatus status = [[[DBManager sharedDBManager]PDFWithDoi:record.doi] downloadStatus];
            
            BOOL shouldEnable = YES;
            
            [cell.btnPdfDownload setTitleColor:[UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cell.btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
            [cell.btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateHighlighted];
            
            if(status == PDFNotDownloaded) {
                
                shouldEnable = YES;
                pdfbtnTitle  = @" Download PDF";
                
                [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height+koffset+2, 106, 25)];
                
                
            } else if(status == PDFIsDownloading) {
                
                shouldEnable = NO;
                
               
                    [cell.btnPdfDownload setFrame:CGRectMake(cell.spinner.frame.origin.x + cell.spinner.frame.size.width + 10, cell.authorsLabel.frame.origin.y + cell.authorsLabel.frame.size.height + koffset + 2, 146, 25)];
               
                
                [cell.btnPdfDownload setTitleColor:convertIntoRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
                
                cell.spinner.frame = CGRectMake(12, (cell.btnPdfDownload.frame.origin.y + ((cell.btnPdfDownload.frame.size.height - 20)/ 2)) , 20, 20);
                
               
                    [cell.btnPdfDownload setFrame:CGRectMake(cell.spinner.frame.origin.x + cell.spinner.frame.size.width + 10, cell.authorsLabel.frame.origin.y + cell.authorsLabel.frame.size.height + koffset + 2, 146, 25)];
               
                
                [cell.btnPdfDownload setImage:[UIImage imageNamed:@"btn_arrow_grey.png"] forState:UIControlStateNormal];
                [cell.btnPdfDownload setImage:[UIImage imageNamed:@"btn_arrow_grey.png"] forState:UIControlStateHighlighted];
                
                pdfbtnTitle  = @" Download in Progress";
                
            } else if(status == PDFHasDownloaded) {
                
                shouldEnable = YES;
                
                    [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height+koffset+2, 115, 25)];
               
                
                pdfbtnTitle = @" Read this Article";
                
                
            } else {
                
                shouldEnable = YES;
                
                    [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height + koffset+2, 106, 25)];
                
                
                pdfbtnTitle  = @" Download PDF";
            }
            
            [cell.btnPdfDownload setTitle:pdfbtnTitle forState:UIControlStateNormal];
            [cell.btnPdfDownload setUserInteractionEnabled:shouldEnable];
            
            (!shouldEnable)?[cell.spinner startAnimating]:[cell.spinner stopAnimating];
        }
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == _selectedindex &&isIpad) {
            cell.contentView.backgroundColor =  convertIntoRGB(245, 244, 243, 1.0); 
        }
        else {
            cell.contentView.backgroundColor =  [UIColor whiteColor];
        }
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = convertIntoRGB(243, 243, 243, 1.0);
        cell.selectedBackgroundView = selectedView;
        
        return cell;
    }
    
    else {
        
        NSString *cellIdentifier = [NSString stringWithFormat:@"SearchResultsViewCell%d%d",indexPath.row,indexPath.section];
        SearchResultCellIpad *cell = (SearchResultCellIpad *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        cell = [[SearchResultCellIpad alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;        
        
        if (indexPath.row == [_tableViewDataSource count]) {
            
            UILabel *lblShowMore;
            lblShowMore = [[UILabel alloc] initWithFrame:CGRectMake(110, 16, 100, 18)];
            lblShowMore.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            lblShowMore.backgroundColor = [UIColor clearColor];
            lblShowMore.textColor  = [UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0];
            lblShowMore.text = @"Show more...";
            
            if(_shouldLargeCell) {
                lblShowMore.frame = CGRectMake(250, 10, 100, 20);
                [lblShowMore setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
            } else {
                [lblShowMore setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
            }
            // [lblShowMore setTextAlignment:UITextAlignmentCenter];
            
            
            lblShowMore.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            lblShowMore.tag = 1000;
            [cell.contentView addSubview:lblShowMore];
            
            //
            cell.articlelabel.text = @"";
            cell.titleLabel.text   = @"";
            cell.authorsLabel.text = @"";
            [cell.titleLabel setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.btnPdfDownload setImage:nil forState:UIControlStateNormal];
            
        } else {
            
            Article* record = [_tableViewDataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = @"";
            cell.articlelabel.text = @"";
            cell.titleLabel.text = record.title;
            
            //
            if (_articalListViewType == IssueListArticleType) {
                //[cell.articlelabel setFrame:CGRectMake(cell.articlelabel.frame.origin.x, cell.articlelabel.frame.origin.y, 0, 0)]; 
            }
            
            [cell.articlelabel setHeightOfLabel];
            
            // set dynamic width for authorLabel.
            
            NSString *autherStr = [[record allAuthors] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            cell.authorsLabel.text = autherStr;
            cell.dateLabel.text    = [NSString stringWithFormat:@" (%@)",
                                      [record composeVolumeNumberPage]];
            
            
            // cell.titleLabel.delegate =self;
            //
            NSString *title = record.title;
            
            // set dynamic height for titleLabel.
            CGSize size;
            
            
            if (self.shouldLargeCell) {
                
                [cell.titleLabel setFrame:CGRectMake(12, 18, 600, 10)];
                [cell.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
                [cell.authorsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
                [cell.authorsLabel setFrame:CGRectMake(11, 36, 500, 15)];
                [cell.authorsLabel setWidthOfLabelWithMaxWidth:500];
                
                CGSize  textSize = { cell.titleLabel.frame.size.width, 10000.0 };
                size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:18] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
                
            } else {
                
                [cell.titleLabel setFrame:CGRectMake(12, 14, 300, 10)];
                [cell.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
                [cell.authorsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
                [cell.authorsLabel setFrame:CGRectMake(11, 36, 305, 15)];
                [cell.authorsLabel setWidthOfLabelWithMaxWidth:170]; 
                
                CGSize  textSize = { cell.titleLabel.frame.size.width, 10000.0 };
                size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
            }
            
            float height = size.height < 27 ? 27 : size.height+10;
            //[cell.titleLabel setFrame:CGRectMake(12, 14, 300, height)];
            [cell.titleLabel setFrame:CGRectMake(12, cell.articlelabel.frame.origin.y+cell.articlelabel.frame.size.height, 300, height)];
            
            CGRect frame = cell.authorsLabel.frame;//cell.authorsLabel.frame;
            frame.origin.y = cell.titleLabel.frame.origin.y+cell.titleLabel.frame.size.height+koffset;
            cell.authorsLabel.frame = frame;
            
            frame = cell.dateLabel.frame;//cell.authorsLabel.frame;
            frame.origin.y = cell.authorsLabel.frame.origin.y;
            frame.origin.x = cell.authorsLabel.frame.origin.x + cell.authorsLabel.frame.size.width;
            cell.dateLabel.frame = frame;
            
            [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height+koffset, cell.btnPdfDownload.frame.size.width, cell.btnPdfDownload.frame.size.height)];
            [cell.btnPdfDownload setTag:indexPath.row+666];
            [cell.btnPdfDownload addTarget:self action:@selector(btnDownloadpdfClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *pdfbtnTitle = @" Download PDF";
            
            cell.authorsLabel.text = autherStr;
            cell.dateLabel.text    = [NSString stringWithFormat:@" (%@)",[record composeVolumeNumberPage]];
            ///
            PDFDownloadStatus status = [[[DBManager sharedDBManager]PDFWithDoi:record.doi] downloadStatus];
            
            BOOL shouldEnable = YES;
            
            [cell.btnPdfDownload setTitleColor:[UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cell.btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
            [cell.btnPdfDownload setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateHighlighted];
            
            if(status == PDFNotDownloaded) {
                
                shouldEnable = YES;
                pdfbtnTitle  = @" Download PDF";
                [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height + koffset+2, 120, 25)];
                
            } else if(status == PDFIsDownloading) {
                
                shouldEnable = NO;
                
               
                [cell.btnPdfDownload setFrame:CGRectMake(cell.spinner.frame.origin.x + cell.spinner.frame.size.width + 10, cell.authorsLabel.frame.origin.y + cell.authorsLabel.frame.size.height + koffset + 2, 192, 25)];
                
                [cell.btnPdfDownload setTitleColor:convertIntoRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
                
                cell.spinner.frame = CGRectMake(12, (cell.btnPdfDownload.frame.origin.y + ((cell.btnPdfDownload.frame.size.height - 20)/ 2)) , 20, 20);
                
              [cell.btnPdfDownload setFrame:CGRectMake(cell.spinner.frame.origin.x + cell.spinner.frame.size.width + 10, cell.authorsLabel.frame.origin.y + cell.authorsLabel.frame.size.height + koffset + 2, 165, 25)];
               
                [cell.btnPdfDownload setImage:[UIImage imageNamed:@"btn_arrow_grey.png"] forState:UIControlStateNormal];
                [cell.btnPdfDownload setImage:[UIImage imageNamed:@"btn_arrow_grey.png"] forState:UIControlStateHighlighted];
                
                pdfbtnTitle  = @" Download in Progress";
                
            } else if(status == PDFHasDownloaded) {
                
                shouldEnable = YES;
                
                    [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height+koffset+2, 130, 25)];
                
                pdfbtnTitle = @" Read this Article";
                
                
            } else {
                
                shouldEnable = YES;
                pdfbtnTitle  = @" Download PDF";
                [cell.btnPdfDownload setFrame:CGRectMake(cell.btnPdfDownload.frame.origin.x, cell.authorsLabel.frame.origin.y+cell.authorsLabel.frame.size.height + koffset+2, 120, 25)];
            }
            
            [cell.btnPdfDownload setTitle:pdfbtnTitle forState:UIControlStateNormal];
            [cell.btnPdfDownload setUserInteractionEnabled:shouldEnable];
            
            (!shouldEnable)?[cell.spinner startAnimating]:[cell.spinner stopAnimating];
        }
        
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == _selectedindex &&isIpad) {
            cell.contentView.backgroundColor =  convertIntoRGB(245, 244, 243, 1.0); 
        }
        else{
            cell.contentView.backgroundColor =  [UIColor whiteColor];
        }
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = convertIntoRGB(245, 244, 243, 1.0);
        cell.selectedBackgroundView = selectedView;
        
        return cell;
    }
}


#pragma mark - UITableViewDatasource
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpringerLinkAppDelegate *appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([self.callbackDelegate respondsToSelector:@selector(onSelectingTableViewCell:withTableViewDataSourceArray:)]&& _selectedindex != indexPath.row) {
        [self.callbackDelegate onSelectingTableViewCell:indexPath withTableViewDataSourceArray:_tableViewDataSource];
    }
    
    
    if (indexPath.row == [_tableViewDataSource count]) {
        
        if(_articalListViewType == HomeLatestArticalListType) {
            
            NSString *xibFileName = isIphone ? @"LatestArticleListViewController" : @"LatestArticleViewcontroller_ipad";
            
            LatestArticleListViewController *nextViewController = [[LatestArticleListViewController alloc] initWithNibName:xibFileName bundle:nil];
            nextViewController.termsType = MostRecentType;
            nextViewController.currentSortBy = SortByDate;
            
            [[Global shared] setLatestArticleListViewController:nextViewController];
            [self.navController pushViewController:nextViewController animated:YES];
        }
        
    }  else if(isIphone) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ArticleDetailPageViewController *nextViewController = [[ArticleDetailPageViewController alloc] initWithNibName:@"ArticleDetailPageViewController_iphone" bundle:nil];
        nextViewController.currentArticle = [_tableViewDataSource objectAtIndex:indexPath.row];
        [self.navController pushViewController:nextViewController animated:YES];
        [[Global shared] setArticleDetailPageViewController:nextViewController];
        
    } else if (isIpad) {
        
        if(appDelegate.articleDetailViewController.articlesList != _tableViewDataSource)
            appDelegate.articleDetailViewController.articlesList = _tableViewDataSource;
        
        appDelegate.articleDetailViewController.callerDelegate = self;
        appDelegate.articleDetailViewController.shouldNextDesableOnLast = 
        (_articalListViewType == HomeLatestArticalListType);
        appDelegate.articleDetailViewController.totalCount = _totalCount;
        [appDelegate.articleDetailViewController showArticleAtIndex:indexPath.row];
        _selectedindex = indexPath.row;
        [[Global shared] setArticleDetailPageViewController:appDelegate.articleDetailViewController];
        [tableView reloadData];
        //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView 
heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if([self.callbackDelegate respondsToSelector:@selector(onScrollTableView:)]) {
        [self.callbackDelegate onScrollTableView:scrollView];
    }
}

#pragma mark -
- (void)btnDownloadpdfClicked:(UIButton *)sender {
    
    Article* article = [_tableViewDataSource objectAtIndex:sender.tag-666];
    int status = [[[DBManager sharedDBManager]PDFWithDoi:article.doi] downloadStatus];
        
    if (status == PDFHasDownloaded) {
        
        if(isIpad) {
             SpringerLinkAppDelegate *appDelegate = (SpringerLinkAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            NSString *xibName = (isIphone) ? @"DownloadedPDFListViewController" : @"DownloadListViewController_ipad";
            DownloadedPDFListViewController *objDownloadList = [[DownloadedPDFListViewController alloc] initWithNibName:xibName bundle:nil];
            objDownloadList.pdfFileName = article.doi;
            
            if(_articalListViewType == SearchResultArticalListType || 
               _articalListViewType == IssueListArticleType) {
                objDownloadList.isSearchResultInRight = self.shouldLargeCell;
                objDownloadList.rightViewController = _callbackDelegate;
            }
            
             UINavigationController *navController = [[appDelegate.splitViewController viewControllers]objectAtIndex:0];
            [navController pushViewController:objDownloadList animated:YES];
            
        } else {
            
            PDFViewerViewController* viewController = nil;
            viewController = [[PDFViewerViewController alloc] initWithNibName:@"PDFViewerViewController_iPhone" bundle:nil];
            viewController.pdfFileName = article.doi;
            [self.navController pushViewController:viewController animated:YES];  
        }
        
    } else {
        
        [_pdfBtnArray addObject:sender];
        [self saveArticletoDB:article];
        
        RequestHandler *objRequest = [[RequestHandler alloc] init];
        objRequest.delegate        = [Global shared];//self;
        objRequest.selector        = @selector(onRecievingPdfServerResponse:objectInfoDictionary:);
        objRequest.serverURL       = [self pdfURL:article.doi];
        objRequest.isHeader        = YES;
        objRequest.doi             = article.doi;
        
        ServerRequestHandler *objServer = [ServerRequestHandler sharedRequestHandler];
        
        [objServer addRequest:objRequest];
        [objServer.doiArray addObject:article.doi];
        [objServer startRequets];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-666 inSection:0];
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates]; 
    }
}

#pragma mark- public methods
//saving article to database
//In PDFTable the status is 1 : downloading is started
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
            dbArticle = nil;
        }
        
    } else {
        
        [[DBManager sharedDBManager]changeStatusOfPdfWithDoi:article.doi withStatus:PDFIsDownloading];
    }
     [[Global shared] refereshTableDataWithStatus:PDFIsDownloading];
    
}

- (void)reloadTableData {
    
    _tableHeight = 0;
    [_tableView reloadData];
}

- (NSString *)pdfURL:(NSString*)doi {
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@", kPDFURL,doi];
    return urlStr;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - public methods
- (void)selectTableIndex:(short)index {
    
    //only for next at last element
    if(isShowMoreFromArticleDetail) {
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:_indexPath];
        isShowMoreFromArticleDetail = NO;
    }
}
#pragma mark - callerDelegate method

- (void)setSelectedIndexOfTable:(short)index {
    
    if(index == [_tableViewDataSource count]) {
        isShowMoreFromArticleDetail = YES;
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:_indexPath];
        
    } else {
        
        _selectedindex = index;
        [_tableView reloadData];
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tableView scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

@end
