//
//  SearchResultController.m
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "SearchResultController.h"
#import "DetectNetworkConnection.h"
#import "SearchResultsCell.h"
#import "SLXMLResponse.h"
#import "LoaderView.h"
#import "Constant.h"
#import "Utility.h"
#import "SLService.h"


@implementation SearchResultController

@synthesize  searchTable;
@synthesize  searchKey;
@synthesize response;
@synthesize  facetsQuery;
@synthesize  constraintsQuery;
@synthesize termsType;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil 
                           bundle:nibBundleOrNil];
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
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES]; //Hides back button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    _objSLService = [SLService new];
    _records=[[NSMutableArray alloc] init];
    _loader = [[LoaderView alloc] initWithFrame:[[self view]bounds]];        
    //[self startSearchingWithQuery:self.searchKey];
    // Check the device weather iPad or iphone
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() ) {
        
        _loader = [[LoaderView alloc] initWithFrame:[[self view]bounds]];  //creat loader view object for iPad 
    }
    else{
        _loader = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];  //creat loader view object for iPhone
        
    }
    
    
    [self loadMoreResults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _loader    = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark- public methods
/**
 * method for start serching.
 * @param: qStr-> pass the query string.
 */

- (void)startSearchingWithQuery:(NSString *)qStr {
    
//    NSString *str = [NSString stringWithFormat:kSearch_URL_Str,qStr,1];
//    str = [str stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
//    str = [str stringByReplacingOccurrencesOfString:@"\""  withString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:qStr];
    NSLog(@"url :%@",url);
    
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];
}

- (void)loadMoreResults{
    
    _result = self.response.currentResult;
    
    if (_result.start==0||_result==nil) 
        _startNumber = 1;
    else
        _startNumber = _result.pageLenth+1;
    NSString *querry = [_objSLService search:self.searchKey 
                                 startNumber:_startNumber 
                             numberOfResults:kPageLimit 
                                 facetsQuery:self.facetsQuery 
                            constraintsQuery:self.constraintsQuery 
                                   termsType:self.termsType];
    NSLog(@"%@",querry);
    
    [self startSearchingWithQuery:querry];
}

#pragma mark- Button Actions
- (void)goBack
{
    if([_loader superview] != nil)
        [_loader removeFromSuperview];
    [_httpRequest clearDelegatesAndCancel];
    self.navigationItem.leftBarButtonItem = nil;
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark- ASIHTTPRequest delegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    
    [[self view] addSubview:_loader];
    [_loader showLoader];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSLog(@"finished");
    SLMetadataXMLParser *metadataParser=[[SLMetadataXMLParser alloc] init]; //SLMetadataXMLParser object.
    [metadataParser setDelegate:self];
    [metadataParser parseXMLData:[request responseData]];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"failed");
    showAlert(NetworkErrorMessage);
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
    self.response=metadataResponse;
    if ([_records count]>0) {
        [_records addObjectsFromArray:self.response.records];  
    }
    
    else{
        [_records setArray:self.response.records];   
    }
    
    if ([_records count]==0) {
        
        /// show alert if no record found
        UIAlertView * objAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" 
                                                                message:@"no matching article found." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [objAlertView show];
        
    }
    [self.searchTable reloadData];
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark Implement UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    
    NSInteger recordsCount = [_records count];
    MetadataInfoResult *objResult=self.response.currentResult;
    if (self.response != nil && objResult.total > 10 && objResult.total > recordsCount) {
        recordsCount++;
    }
    return recordsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"SearchResultsViewCell";
    SearchResultsCell *cell = (SearchResultsCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SearchResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;        
    }
    
    if (indexPath.row == [_records count]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Show More";
        cell.titleLabel.text = nil;
        cell.authorsLabel.text = nil;
        cell.publicationNameLabel.text = nil;
        cell.volumeNumberPageLabel.text = nil;        
    }
    
    else {
        
        Article* record = [_records objectAtIndex:indexPath.row];
        cell.textLabel.text = nil;
        cell.titleLabel.text = record.title;
        cell.authorsLabel.text = [record authors];
        cell.publicationNameLabel.text = record.publicationName == nil ? @"" : record.publicationName;
        cell.volumeNumberPageLabel.text = [record composeVolumeNumberPage];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0f;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_records count]) {
        
        [self loadMoreResults]; 
    }
    
}


@end
