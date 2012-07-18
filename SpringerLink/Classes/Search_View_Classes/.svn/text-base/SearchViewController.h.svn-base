//
//  SearchViewController.h
//  SpringerLink
//
//  Created by Prakash Raj on 10/04/12.
//  Copyright (c) 2012 KiwiTech. All rights reserved.
//

/*  ***************************************************************************************************
        This is view controller (subclass of UIViewController) which provide a controller and handles 
        the functionality of search (basic/advance).
    *************************************************************************************************** */

#import <UIKit/UIKit.h>
#import "SLMetadataXMLParser.h"
#import "ASIHTTPRequest.h"
#import "SLService.h"
#import "SLVolumeXMLParser.h"
#import "SpringerLinkAppDelegate.h"
#import "ProtocolDecleration.h"

@class SLMetadataReader;
@class LoaderView;
@class ArticalListViewController;
@class ArticleDetailPageViewController;

@interface SearchViewController : UIViewController <UISearchBarDelegate,SLMetadataXMLParserDelegate,SLVolumeXMLResponseDelegate, ArticalListViewDelegate>{
    
    IBOutlet UIScrollView     *_scrollView;
    IBOutlet UILabel          *_lblLatestArticles;
    IBOutlet UIImageView      *_imgViewTopbar;
    IBOutlet UIImageView      *_thumbnailImgView;
    IBOutlet UIView           *_headersearchView;
    IBOutlet UISearchBar      *_searchBar; 
    IBOutlet UIButton         *_aboutUsBtn;
    IBOutlet UIButton         *_topSearchBtn;
    IBOutlet UIButton         *_advCancelBtn;
    IBOutlet UIButton         *_btnBrowseByVolume;
    
    IBOutlet UILabel          *_lblVolume;
    IBOutlet UILabel          *_lblVolumeDate;
    IBOutlet UILabel          *_lblArticleNumber;
    IBOutlet UILabel          *_lblIssueNumber;
    IBOutlet UILabel          *_lblVolumeNumber;
    IBOutlet UILabel          *_lblChiefeditors;
    IBOutlet UILabel          *_lblArticle;
    IBOutlet UILabel          *_lblIssue;
    IBOutlet UILabel          *_lblJournalName;
    
    LoaderView                *_loader;
    ASIHTTPRequest            *_httpRequest;
    SLService                 *_objSLService;
    NSMutableArray            *_articleArray;
    SLXMLResponse             *_response;
    SLVolumeXMLResponse       *_objVolumeXMLResponse;
    SpringerLinkAppDelegate   *_appDelegate;
    ArticalListViewController *_articalListViewController; 
    
    float tableheight;
    BOOL isVolumeParsing;
}

@property (nonatomic, strong) ArticalListViewController  *articalListViewController;

- (IBAction)aboutUsClicked:(id)sender;
- (IBAction)btnBrowseByVolumeClicked:(id)sender;
- (IBAction)topSearchClicked:(id)sender;
- (IBAction)advCancelBtnClicked:(id)sender;

- (void)hitRequestForLatestArticles;

@end
