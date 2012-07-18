//
//  ArticalListViewController.h
//  SpringerLink
//
//  Created by Kiwitech on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolDecleration.h"
#import "SLXMLResponse.h"

typedef enum {
    
    LatestArticalListType = 0,
    SearchResultArticalListType,
    HomeLatestArticalListType,
    IssueListArticleType
} ArticalListType;

@interface ArticalListViewController : UIViewController {
    
    IBOutlet UITableView    *_tableView;
    NSMutableArray          *_tableViewDataSource;
    NSMutableArray          *_pdfBtnArray;
  
    UINavigationController  *_navController;
    NSInteger               _totalCount;
    short                   _selectedindex;
    BOOL                    _shouldLargeCell;
    ArticalListType         _articalListViewType;
    CGFloat                 _tableHeight;
    
     __unsafe_unretained id <ArticalListViewDelegate> _callbackDelegate;
}

@property (nonatomic, assign) CGFloat                 tableHeight;
@property (nonatomic, assign) ArticalListType         articalListViewType;
@property (nonatomic, strong) NSMutableArray          *tableViewDataSource;
@property (nonatomic, strong) UINavigationController  *navController;
@property (nonatomic, assign) NSInteger               totalCount;
@property (nonatomic, retain) UITableView             *tableView;

@property (nonatomic, assign) id <ArticalListViewDelegate> callbackDelegate;

@property (nonatomic, assign) BOOL shouldLargeCell;
@property (nonatomic, assign) short selectedindex;

//saving article to database
//in PDFTable the status is 1 : downloading is started
- (void)saveArticletoDB:(Article *)article;
- (NSString *)pdfURL:(NSString*)doi; 
- (void)reloadTableData;
- (void)selectTableIndex:(short)index;

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
