//
//  ArticleDetailPageViewController.h
//  SpringerLink
//
//  Created by prakash raj on 26/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

/* *****************************************************************************************************
 
 This is view controller (subclass of UIViewController) which provide a controller and showing the deatail of article.
 
 ************************************************************************************************** */

#import <UIKit/UIKit.h>

#import "DownloadManager.h"
#import "SplitDetailViewController.h"
#import "ThumbnailView.h"
#import "ArticleDetailView.h"

#import <MessageUI/MFMailComposeViewController.h>

@class Article;
@class LoaderView;
@class SLServerXMLResponse;

@interface ArticleDetailPageViewController : SplitDetailViewController 
<DownloadManagerDelegate,ArticleDetailViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIWebViewDelegate,UISearchBarDelegate,UISplitViewControllerDelegate> {
    
@private
    LoaderView           *_loader;
    __unsafe_unretained IBOutlet UIImageView *imgViewTopbar;
    
    IBOutlet UIView       *_headersearchView;
    IBOutlet UISearchBar  *_searchBar; 
    IBOutlet UIView       *_footerView;
    IBOutlet UIView       *_countView; //for iphone ....
    IBOutlet UILabel      *_countLabel; //for iphone .... 
    IBOutlet UIButton     *_topSearchBtn;
    IBOutlet UIButton     *_advCancelBtn;
    IBOutlet UIButton     *_fontIncreasebtn;
    IBOutlet UIButton     *_fontDecreasebtn;
    IBOutlet UIButton     *_nextbtn; //for only ipad...
    IBOutlet UIButton     *_prevbtn; //for only ipad...
    IBOutlet UIButton     *_searchWithinPrevBtn; //for iphone ....
    IBOutlet UIButton     *_searchWithinNextBtn; //for iphone ....
    IBOutlet UIButton     *_cancelDoneButton;
    IBOutlet UIView       *_withinArticleSearchview;
    IBOutlet UISearchBar  *_withinArticlesearchBar;
    
    ThumbnailView         *_thumbnailView;
    ArticleDetailView     *_articleDetailView;
    Article               *_currentArticle;
    BOOL                  _shouldNextDesableOnLast;//taken to detect home/other controller on master page
}

@property (nonatomic, retain) ThumbnailView *thumbnailView;
@property (nonatomic, retain) Article *currentArticle;
@property (nonatomic, assign) BOOL shouldNextDesableOnLast;
@property (nonatomic, assign) short totalCount;
@property (nonatomic, assign) short currentArticleNumber;

- (IBAction)backClicked:(id)sender;//iphone only.
- (IBAction)homeClicked:(id)sender;//iphone only.
- (IBAction)topSearchClicked:(id)sender;//iphone only.
- (IBAction)advCancelBtnClicked:(id)sender;//iphone only.

- (IBAction)changeFontClicked:(id)sender;
- (IBAction)searchWithinArticleClicked:(id)sender;
- (IBAction)shareClicked:(id)sender;

- (IBAction)nextPrevClicked:(id)sender;//ipad only..
- (IBAction)cancelDoneClicked:(id)sender;
- (IBAction)searchWithinNextPrevClicked:(id)sender;

- (void)showArticleAtIndex:(short)index; //ipad only...
- (void)setCurrentStatus:(NSInteger)st;
@end
