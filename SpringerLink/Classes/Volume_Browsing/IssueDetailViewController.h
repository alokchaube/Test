//
//  IssueDetailViewController.h
//  SpringerLink
//
//  Created by Alok on 08/05/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MetadataInfoResult.h"
#import "SLService.h"
#import "SLXMLResponse.h"
#import "DownloadManager.h"
#import "ServerRequestHandler.h"
#import "SLMetadataXMLParser.h"
#import "ProtocolDecleration.h"

@class LoaderView;
@class ArticalListViewController;
@class SpringerLinkAppDelegate;
@interface IssueDetailViewController : UIViewController <UISearchBarDelegate,SLMetadataXMLParserDelegate, ArticalListViewDelegate>
{
    IBOutlet UIImageView *_thumbnailImgView;
    NSString* _strIssueDetail;
    NSString* _strVolumeNumber;
    NSString* _strIssueNumber;
    NSString *_strIssnPrint;
    
    LoaderView          *_loader;
    ASIHTTPRequest      *_httpRequest;
    SLService           *_objSLService;
    MetadataInfoResult  *_result;
    int                 _startNumber;
    DownloadManager       *dwnldManager;
    int btnIndex;
    ArticalListViewController       *_articalListViewController;
    
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UIView *_tableleftHeaderView;

     IBOutlet UILabel *lblIssueDetail;
     IBOutlet UIImageView *imgViewTopbar;
    
@private
    
    IBOutlet UIButton     *_topSearchBtn;
    IBOutlet UIView       *_headersearchView;
    IBOutlet UISearchBar  *_searchBar; 
    IBOutlet UIButton     *_advCancelBtn;
    
    IBOutlet UIView       *_detailView;
   
     IBOutlet UILabel *_lblIssnNumber;
     IBOutlet UILabel *_lblInThisArticle;
     IBOutlet UILabel *_lblArtcleCount;
    
     IBOutlet UIActivityIndicatorView *_activityIndicator;
    
    BOOL _shouldShowInDetailArea;//added ---raj
    IBOutlet UIView       *_topHeaderView;
     SpringerLinkAppDelegate         *_appDelegate;

@public
    TermsType              _termsType;
    NSString              *_searchKey;
    SLXMLResponse         *_response;
    FacetsQuery           *_facetsQuery;
    ConstraintsQuery      *_constraintsQuery;
    short                 currentSortBy;
    BOOL                  isBasicSearch;
}
@property (nonatomic, strong) ArticalListViewController *articalListViewController;
@property (nonatomic, strong) NSString* strVolumeNumber;
@property (nonatomic, strong) NSString* strIssueNumber;
@property (nonatomic, strong) NSString *strIssueDetail;
@property (nonatomic, strong) NSString *strIssnPrint;
//
@property (nonatomic, strong) SLXMLResponse     *response;
@property (nonatomic, strong) FacetsQuery       *facetsQuery;
@property (nonatomic, strong) ConstraintsQuery  *constraintsQuery;

@property ( nonatomic ,copy)  NSString          *searchKey;
@property (nonatomic, assign) TermsType termsType;
@property (nonatomic, assign) BOOL shouldShowInDetailArea;

@property (nonatomic, assign) BOOL       dontHitService;
@property (nonatomic, strong) NSArray    *dataSourceArray;//
@property (nonatomic, assign) short      totalCount;

- (IBAction)btnBackClicked:(id)sender; 
- (IBAction)btnHomeClicked:(id)sender; 
- (IBAction)topSearchClicked:(id)sender;

- (IBAction)advCancelBtnClicked:(id)sender;
@end



   

