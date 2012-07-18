//
//  SearchResultController.h
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMetadataXMLParser.h"
#import "ASIHTTPRequest.h"
#import "SLService.h"
#import "DownloadManager.h"
#import "ArticalListViewController.h"
#import "LatestArticleListViewController.h"
#import "SLSortListViewController.h"
/*
 *  This is a view controller class in which show the title, authors name, of articles in a tableview also button in tableview cell for download PDF.
 */

@class LoaderView;
@class SLXMLResponse;
@class SLService;
@class SLPickerViewController;
@class SpringerLinkAppDelegate;
@interface SearchResultViewController : UIViewController <UIActionSheetDelegate,UITextViewDelegate,UISearchBarDelegate,UIPopoverControllerDelegate,DownloadManagerDelegate,ArticalListViewDelegate,PickerViewControllerDelegate,SLSortListViewControllerDelegate,ASIHTTPRequestDelegate,SLMetadataXMLParserDelegate> {
    
@private
    LoaderView          *_loader;
    ASIHTTPRequest      *_httpRequest;
    SLService           *_objSLService;
    MetadataInfoResult  *_result;
    
    IBOutlet UIView       *searchHeaderView;
    IBOutlet UISearchBar  *_searchBar;
    IBOutlet UIButton     *_advCancelBtn;
    IBOutlet UIView       *_headersearchView; //view object open on click of glass search btn.
    IBOutlet UIView       *detailView;
    IBOutlet UIView       *headerView;
    IBOutlet UILabel      *_countLabel;
    IBOutlet UILabel      *_resultLabel;
    IBOutlet UILabel      *_resultItemLabel;
    IBOutlet UIView       *topHeaderView;
    IBOutlet UIButton     *_topSearchBtn;
    IBOutlet UIButton     *_homeBtn;
    IBOutlet UIButton     *_sortByButton;
    IBOutlet UIImageView  *_imgViewTopbar;
    IBOutlet UIImageView  *_sortByBackImageView;
    IBOutlet UILabel      *_sortByLabel;
    IBOutlet UILabel      *_lblHeader;

    DownloadManager                 *dwnldManager;   
    ArticalListViewController       *_articalListViewController;
    SLPickerViewController          *_slpickerViewController;
    SLSortListViewController        *_slSortListViewController;
    UIPopoverController             *_sortPopOverController;
    SpringerLinkAppDelegate         *_appDelegate;
   
    NSArray *sortingItems;
    int    _startNumber;
    int     btnIndex;
    BOOL    isSearchViewVisible;
    float   preY;
    BOOL    isTableScrolled;
    
@public
    TermsType              _termsType;
    NSString              *_searchKey;
    SLXMLResponse         *_response;
    FacetsQuery           *_facetsQuery; 
    ConstraintsQuery      *_constraintsQuery;
    short                 currentSortBy;
    BOOL                  isBasicSearch;
    BOOL                  _shouldShowInDetailArea;
}
@property (nonatomic, strong) ArticalListViewController *articalListViewController;
@property (nonatomic, strong) SLXMLResponse             *response;
@property (nonatomic, strong) FacetsQuery               *facetsQuery;
@property (nonatomic, strong) ConstraintsQuery          *constraintsQuery;
@property (nonatomic, copy)   NSString                  *searchKey;

@property (nonatomic, assign) TermsType termsType;
@property (nonatomic, assign) short     currentSortBy;
@property (nonatomic, assign) BOOL      isBasicSearch;
@property (nonatomic, assign) BOOL      shouldShowInDetailArea;
@property (nonatomic, assign) BOOL      dontHitService;

@property (nonatomic, strong) NSArray    *dataSourceArray;//
@property (nonatomic, assign) NSInteger  totalCount;
@property (nonatomic, copy) SearchResultViewController *rightViewController;

- (IBAction)backClicked:(id)sender;
- (IBAction)homeClicked:(id)sender;
- (IBAction)topSearchClicked:(id)sender;
- (IBAction)sortByButtonClicked:(id)sender;
- (IBAction)advCancelBtnClicked:(id)sender;

- (void)resetControlsFraming;
- (void)reSearchWithQueryStr:(NSString *)str;
- (void)performAdv_Search; 

@end
