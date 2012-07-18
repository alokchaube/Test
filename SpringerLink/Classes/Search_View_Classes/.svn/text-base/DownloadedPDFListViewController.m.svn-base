//
//  DownloadedPDFListViewController.m
//  SpringerLink
//
//  Created by Prakash Raj on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "DownloadedPDFListViewController.h"
#import "UILabelExtended.h"
#import "Global.h"
#import "DBManager.h"
#import "DBArticle.h"
#import "PDFDownloadInfo.h"
#import "Utility.h"
#import "DownloadPdfTableViewCell.h"
#import "PDFViewerViewController.h"
#import "SpringerLinkAppDelegate.h"

@interface DownloadedPDFListViewController ()
//private methods -
- (NSMutableString *)getPathForPDFFile:(NSString *)filename;
- (void)deleteArticleAtIndex:(NSInteger)index;
- (void)checkEnablityOfEditBtn;

@end


@implementation DownloadedPDFListViewController
@synthesize pdfFileName;
@synthesize isSearchResultInRight = _isSearchResultInRight;
@synthesize rightViewController = _rightViewController;

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
    
    [super viewWillAppear:YES];
    [Global shared].badgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:[Global shared].badgeNumber forKey:@"badgeNumber"];
    [[Global shared].imgViewBadge setHidden:YES];
}

- (void)viewDidLoad
{
     [super viewDidLoad];
    //NSLog(@"%@",[UIFont familyNames]);
    _listOfPDFsArr = [[[DBManager sharedDBManager] allDownloadedPdfs] mutableCopy];
    _listOfVideosArr = [[NSMutableArray alloc] init];
    _selectedRow = -1;
    [self updateBtnTitles];
    [self checkEnablityOfEditBtn];
   
    if(isIpad) {
        if (self.pdfFileName!=nil) {
        int pdfIndex;
            
        for (PDFDownloadInfo *pdf in _listOfPDFsArr) {
            if ([pdf.doi isEqualToString:self.pdfFileName]) {
               pdfIndex = [_listOfPDFsArr indexOfObject:pdf];  
            }  
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pdfIndex inSection:0];
        [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
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

#pragma mark - Buttons Actions

- (IBAction)backBtnClicked:(id)sender {
    
    if(_isSearchResultInRight && isIpad) {
        //set listing on right....
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController,(UIViewController *)self.rightViewController, nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)homeBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editBtnClicked:(id)sender {
    
    [self checkEnablityOfEditBtn];
    _selectedRow = -1;
    [_tableView reloadData];
    _tableView.editing = (BOOL)![sender tag];
    
    if([sender tag]) {
        
        [sender setTag:0];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
    } else {
        
        [sender setTag:1];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (IBAction)pdfVideoTabClicked:(id)sender {
    
    return;
    
    BOOL shouldPdfEnable = ([sender tag]);
   
    [_PDFTab setEnabled:shouldPdfEnable];
    [_videoTab setEnabled:!shouldPdfEnable];
    if (isIpad &&shouldPdfEnable) {
        [_PDFTab setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_videoTab setTitleColor:[UIColor colorWithRed:1/255.0 green:118/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal]; 
    }
}

#pragma mark - private methods

/*
 Returns the path of particular file.
 @param : filename - the name of file, for which we are looking path.
 */
- (NSMutableString *)getPathForPDFFile:(NSString *)filename {
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                            NSUserDomainMask, YES);
    NSMutableString *pdfFilePath = [dirPaths objectAtIndex:0];
    
	pdfFilePath=(NSMutableString*)[pdfFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pdf/%@.pdf",filename]];
    return pdfFilePath;
}

/*
 Method to delete particular article from database/Cache.
 @param : index - index which is to be deleted.
 */
- (void)deleteArticleAtIndex:(NSInteger)index {
    
    PDFDownloadInfo *pdf = [_listOfPDFsArr objectAtIndex:index];
    NSString *fileName = [pdf.doi stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *filePath = [self getPathForPDFFile:fileName];
    NSLog(@"%@",filePath);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if([manager fileExistsAtPath:filePath])
        if([manager removeItemAtPath:filePath error:nil]) {
            NSLog(@"removed successfully from cache");
        }
    
    [[DBManager sharedDBManager] deletePDF:pdf];
    [_listOfPDFsArr removeObjectAtIndex:index];
    [self checkEnablityOfEditBtn];
}

//updates _PDFTab/_videoTab titles.
- (void)updateBtnTitles {
    
    [_PDFTab setTitle:[NSString stringWithFormat:@"PDFs (%i)",[_listOfPDFsArr count]] 
             forState:UIControlStateNormal];
    [_videoTab setTitle:[NSString stringWithFormat:@"Videos (%i)",[_listOfVideosArr count]] 
               forState:UIControlStateNormal];
    
   [[Global shared].btnPdfView setEnabled:([[DBManager sharedDBManager] totalDownloadedPdfs] >=1)];
}

//method to check whether _editBtn should enable.
- (void)checkEnablityOfEditBtn {
    
    if(![_listOfPDFsArr count]) {
        
        [_editBtn setEnabled:NO];
        [_editBtn setAlpha:0.7];
        [_editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        
    } else {
        
         [_editBtn setAlpha:1];
         [_editBtn setEnabled:YES];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    
    return [_listOfPDFsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = nil;
    
    cellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    DownloadPdfTableViewCell *cell = (DownloadPdfTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSString *strXIB = (isIphone)?@"DownloadPdfTableViewCell":@"DownloadPdfTableViewCell_ipad";
        UIViewController* viewController = [[UIViewController alloc] initWithNibName:strXIB bundle:nil];
        cell = (DownloadPdfTableViewCell*)viewController.view;
        cell.reuseIdentifier = cellIdentifier;
        viewController = nil;
    }
    
    //CGRect frame;
    
    PDFDownloadInfo *pdf = [_listOfPDFsArr objectAtIndex:indexPath.row];
    DBArticle *article = [[DBManager sharedDBManager]articleWithDoi:pdf.doi];
   
    cell.articalTitleCategoryType.text = @"Article";
    [cell.articalTitleCategoryType setHeightOfLabel];
    CGRect titleFrame;
    titleFrame = cell.articalTitle.frame;
    titleFrame.origin.y = cell.articalTitleCategoryType.frame.size.height+cell.articalTitleCategoryType.frame.origin.y;
    cell.articalTitle.frame = titleFrame;

    if(pdf.isPDFFileRead) {
        if (isIphone) {
            [cell.articalTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:13]];
        }
        else {
            [cell.articalTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else {
        if (isIphone) {
             [cell.articalTitle setFont:[UIFont boldSystemFontOfSize:13]];
        }
        else {
             [cell.articalTitle setFont:[UIFont boldSystemFontOfSize:15]];
        }
       
        cell.contentView.backgroundColor = convertIntoRGB(245, 244, 243, 1.0);
    }
    
    if (_tableView.editing) {
        
        cell.articalTitle.textColor = convertIntoRGB(51, 51, 51, 1.0);
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
    } else {
        
        cell.articalTitle.textColor = convertIntoRGB(1, 118, 195, 1.0);
    }
    
    cell.articalTitle.text = article.title;
    
    
    cell.articalAuthorsName.text = article.authors;
    CGRect AutherFrame;
    AutherFrame = cell.articalAuthorsName.frame;
    
    
    cell.articalAuthorsName.frame = AutherFrame;
    [cell.articalAuthorsName setWidthOfLabelWithMaxWidth:200];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-mm-yyyy"];
    NSDate *dt = [formatter dateFromString:article.date];
    [formatter setDateFormat:@"(MMMM yyyy)"];
    
    cell.articalPublishedDate.text = [formatter stringFromDate:dt];
    
    AutherFrame = cell.articalAuthorsName.frame;;
    titleFrame = cell.articalTitle.frame;
    CGRect DateFrame = cell.articalPublishedDate.frame;  

    if (tableView.editing) {
        
        titleFrame.size.width = 280;
        cell.articalTitle.frame = titleFrame;
        [cell.articalTitle setHeightOfLabel];
        if (AutherFrame.size.width>190) {
            AutherFrame.size.width = 180;
            DateFrame.origin.x = cell.articalAuthorsName.frame.origin.x + cell.articalAuthorsName.frame.size.width -10;
        }
        AutherFrame.origin.y = cell.articalTitle.frame.size.height+cell.articalTitle.frame.origin.y;
    }
    else {
        [cell.articalAuthorsName setWidthOfLabelWithMaxWidth:200];
        titleFrame.size.width = 300;
        cell.articalTitle.frame = titleFrame;
        [cell.articalTitle setHeightOfLabel];
        AutherFrame.origin.y = cell.articalTitle.frame.size.height+cell.articalTitle.frame.origin.y;
       DateFrame.origin.x = cell.articalAuthorsName.frame.origin.x + cell.articalAuthorsName.frame.size.width + 1; 
        
    }
    cell.articalAuthorsName.frame = AutherFrame;
    DateFrame.origin.y = cell.articalAuthorsName.frame.origin.y;
    cell.articalPublishedDate.frame = DateFrame;
    
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = convertIntoRGB(243, 243, 243, 1.0);
    cell.selectedBackgroundView = selectedView;
    cell.shouldIndentWhileEditing = YES;
    if (indexPath.row == _selectedRow &&isIpad) {
        cell.contentView.backgroundColor =  convertIntoRGB(245, 244, 243, 1.0); 
    }
    else{
        cell.contentView.backgroundColor =  [UIColor whiteColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deleteArticleAtIndex:indexPath.row];
    [self updateBtnTitles];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFDownloadInfo *pdf = [_listOfPDFsArr objectAtIndex:indexPath.row];
    DBArticle *article = [[DBManager sharedDBManager]articleWithDoi:pdf.doi];
    NSLog(@"%@,%i",article.artIssueId,article.refId);
    
    NSString *title = article.title;
    CGSize size;    //
    CGSize  textSize = { 300.0, 10000.0 };
    
    if (isIphone) {
        size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];  
    }
    else{
        size = [title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap]; 
    }
    
    size.height += 62;
    return  size.height < 70 ? 70 : size.height;
}


- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isIpad && _selectedRow == indexPath.row) {
        return;
    }
   
    _selectedRow = indexPath.row;
    PDFDownloadInfo *pdf = [_listOfPDFsArr objectAtIndex:indexPath.row];
    pdf.isPDFFileRead = YES;
    [[DBManager sharedDBManager] changeReadStatusOfPdfWithDoi:pdf.doi 
                                               withStatus:YES];
    
    PDFViewerViewController* viewController = nil;
    
    if(isIpad) {
        //return;
        
        viewController = [[PDFViewerViewController alloc] initWithNibName:@"PDFViewerViewController_ipad" bundle:nil];
        viewController.pdfFileName = pdf.doi;
        UINavigationController *_detailNavController = [[UINavigationController alloc]initWithRootViewController:viewController];
        [_detailNavController setNavigationBarHidden:YES];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.navigationController, _detailNavController, nil];
    }else {
        viewController = [[PDFViewerViewController alloc] initWithNibName:@"PDFViewerViewController_iPhone" bundle:nil];
        viewController.pdfFileName = pdf.doi;
        [self.navigationController pushViewController:viewController animated:YES]; 
        
    }
    [tableView reloadData];
}

@end
