
//
//  VolumeListViewController.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionHeaderView.h"

@class IssueCell;

@interface VolumeListViewController : UIViewController <UISearchBarDelegate,SectionHeaderViewDelegate>
{
   IBOutlet UITableView *tblView;
   IBOutlet UILabel* _lblVolumeDate;
   IBOutlet UIImageView *imgViewTopbar;
   NSIndexPath          *selectedIndexPath;
    
@private
    
    IBOutlet UIButton     *_topSearchBtn;
    IBOutlet UIView       *_headersearchView;
    IBOutlet UISearchBar  *_searchBar; 
    IBOutlet UIButton     *_advCancelBtn;
    IBOutlet UIView       *_detailView;

}

@property (nonatomic, strong) NSMutableArray* arrayVolumes;
@property (nonatomic, weak) IBOutlet IssueCell *quoteCell;


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnHomeClicked:(id)sender;
- (IBAction)topSearchClicked:(id)sender;

- (IBAction)advCancelBtnClicked:(id)sender;

@end

