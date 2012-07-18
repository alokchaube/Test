//
//  SLSortListViewController.m
//  SpringerLink
//
//  Created by kiwitech kiwitech on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLSortListViewController.h"
#import "SLSortListTableCell.h"
#import "UILabelExtended.h"

@interface SLSortListViewController ()
@end

@implementation SLSortListViewController
@synthesize delegate = _delegate;
@synthesize selectedIndex = _selectedIndex;

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
    _sortItems = [[NSArray alloc] initWithObjects:@"Relevance",@"Date",nil];
    _itemDetails = [[NSArray alloc] initWithObjects:@"",@" (most recent first)", nil];
   // _sortItems = [[NSArray alloc] initWithObjects:@"relevance",@"author",@"date",@"title", nil];
    _selectedIndex = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - public methods

- (void)setSelectedIndex:(short)index {
    _selectedIndex = index;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
 
    return [_sortItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.row,indexPath.section];
    SLSortListTableCell *cell = (SLSortListTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == Nil) {
        cell = [[SLSortListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    
    cell.titleLabel.text = [_sortItems objectAtIndex:indexPath.row];
    cell.detailLabel.text = [_itemDetails objectAtIndex:indexPath.row];
    
    [cell.titleLabel setWidthOfLabelWithMaxWidth:160];
    CGRect frame = cell.detailLabel.frame;
    frame.origin.x = cell.titleLabel.frame.origin.x + cell.titleLabel.frame.size.width;
    cell.detailLabel.frame = frame;
    
    cell.accessoryType = (_selectedIndex == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate && [_delegate respondsToSelector:@selector(performSortingAccordingToIndex:)])
        [_delegate performSortingAccordingToIndex:indexPath.row];
}

@end
