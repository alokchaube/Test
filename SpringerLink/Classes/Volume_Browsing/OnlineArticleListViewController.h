//
//  OnlineArticleListViewController.h
//  SpringerLink
//
//  Created by RAVI DAS on 28/06/12.
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
#import "ArticleDetailPageViewController.h"

@class ArticalListViewController;
@class LoaderView;

@interface OnlineArticleListViewController : UIViewController <UISearchBarDelegate,SLMetadataXMLParserDelegate, ArticalListViewDelegate>
{
    LoaderView          *_loader;
    ASIHTTPRequest      *_httpRequest;
    SLService           *_objSLService;
    MetadataInfoResult  *_result;
    int                 _startNumber;
    DownloadManager       *dwnldManager;
    int btnIndex;
    ArticalListViewController       *_articalListViewController;
    
    __weak IBOutlet UIImageView *imgViewTopbar;
    
    
@private
    IBOutlet UISearchBar  *_searchBar;
    IBOutlet UIButton     *_advCancelBtn;
    IBOutlet UIView       *_headersearchView; //view object open on click of glass search btn.
    IBOutlet UIView       *detailView;
    IBOutlet UIButton     *_topSearchBtn;
    IBOutlet UILabel      *_lblArtcleCount;
    IBOutlet UILabel      *_lblInThisArticle;
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UIView *_tableleftHeaderView;
    
@public
    TermsType              _termsType;
    NSString              *_searchKey;
    SLXMLResponse         *_response;
    FacetsQuery           *_facetsQuery;
    ConstraintsQuery      *_constraintsQuery;
    short                 currentSortBy;
    BOOL                  isBasicSearch;
    BOOL _shouldShowInDetailArea;
    IBOutlet UIView       *_topHeaderView;
   
}
@property (nonatomic,strong) ArticalListViewController       *articalListViewController;

//
@property (nonatomic, strong) SLXMLResponse     *response;
@property (nonatomic, strong) FacetsQuery       *facetsQuery;
@property (nonatomic, strong) ConstraintsQuery  *constraintsQuery;
@property (nonatomic, copy)   NSString          *searchKey;
@property (nonatomic, assign) TermsType termsType;
@property (nonatomic, assign)short currentSortBy;
 @property (nonatomic, assign) BOOL shouldShowInDetailArea;

- (IBAction)btnBackClicked:(id)sender; 
- (IBAction)btnHomeClicked:(id)sender; 
- (IBAction)topSearchClicked:(id)sender;

- (IBAction)advCancelBtnClicked:(id)sender;
@end
