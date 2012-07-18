//
//  SLSortListViewController.h
//  SpringerLink
//
//  Created by kiwitech kiwitech on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLSortListViewControllerDelegate <NSObject>
@optional
- (void)performSortingAccordingToIndex:(short)index;
@end

@interface SLSortListViewController : UIViewController 
<UITableViewDelegate,UITableViewDataSource> {
    NSArray *_sortItems;
    NSArray *_itemDetails;
    IBOutlet UITableView *_tableView;
    
    __unsafe_unretained id <SLSortListViewControllerDelegate> _delegate;
}
@property (nonatomic, assign) id <SLSortListViewControllerDelegate> delegate;
@property (nonatomic, assign) short selectedIndex;

@end
