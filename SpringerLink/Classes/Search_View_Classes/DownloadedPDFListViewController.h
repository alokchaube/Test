//
//  DownloadedPDFListViewController.h
//  SpringerLink
//
//  Created by Prakash Raj on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultViewController;
@interface DownloadedPDFListViewController : UIViewController 
<UITableViewDataSource,UITableViewDelegate> {
    
@private
    IBOutlet UIButton     *_editBtn;
    IBOutlet UIButton     *_PDFTab;
    IBOutlet UIButton     *_videoTab;
    IBOutlet UITableView  *_tableView;
    
    NSMutableArray    *_listOfPDFsArr; //array of PDFs
    NSMutableArray    *_listOfVideosArr; //array of videos
    NSInteger         _selectedRow; 
    NSString          *_pdfFileName;
    short             _selectedindex;
}

@property (nonatomic, copy) NSString     *pdfFileName;
@property (nonatomic, assign) BOOL       isSearchResultInRight;
@property (nonatomic, retain)id rightViewController;;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)homeBtnClicked:(id)sender;
- (IBAction)editBtnClicked:(id)sender;
- (IBAction)pdfVideoTabClicked:(id)sender;
- (void)updateBtnTitles;
@end
