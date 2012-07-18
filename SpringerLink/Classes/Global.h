//
//  Global.h
//  SpringerLink
//
//  Created by Prakash Raj  on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

/* *****************************************************************************************************
 
 This is Global class (subclass of NSObject) which handle pdf download   
 ************************************************************************************************** */

#import <Foundation/Foundation.h>
#import "DownloadManager.h"
#import "NSString+Additions.h"
#import "PDFDownloadInfo.h"

@class ArticleDetailPageViewController;
@class SearchResultViewController;
@class SearchViewController;
@class SLVolumeXMLResponse;
@class IssueDetailViewController;
@class LatestArticleListViewController;
@class OnlineArticleListViewController;
@interface Global : NSObject <DownloadManagerDelegate> {
     
}

@property (nonatomic, retain) UILabel      *lblBadge;
@property (nonatomic, retain) UIImageView  *imgViewBadge;
@property (nonatomic, retain) UIButton     *btnPdfView;
@property (nonatomic, assign) int          badgeNumber;

@property (nonatomic, retain) SearchResultViewController      *searchResultViewController;
@property (nonatomic, retain) ArticleDetailPageViewController *articleDetailPageViewController;
@property (nonatomic, retain) SearchViewController            *searchViewController;
@property (nonatomic, retain) IssueDetailViewController       *issueDetailViewController;
@property (nonatomic, retain) LatestArticleListViewController *latestArticleListViewController;
@property (nonatomic, retain) OnlineArticleListViewController *onlineArticleListViewController;
@property (nonatomic, retain) SLVolumeXMLResponse             *volumeXMLResponse;

+ (Global *)shared;
- (void)refereshTableDataWithStatus:(PDFDownloadStatus)status;

@end
