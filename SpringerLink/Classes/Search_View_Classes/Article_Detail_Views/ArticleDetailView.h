//
//  ArticleDetailView.h
//  SpringerLink
//
//  Created by prakash raj on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
/* *****************************************************************************************************
 
 This is view  (subclass of UIView) which provide a view and showing the deatail of article.
 ************************************************************************************************** */

#import <UIKit/UIKit.h>
#import "SLServerDataFetcher.h"
#import "SLArticleDataXMLParser.h"
#import "DownloadManager.h"
#import "ProtocolDecleration.h"

@class Article;
@class LoaderView;
@class SLServerXMLResponse;
@interface ArticleDetailView : UIView <UIWebViewDelegate,SLServerDataFetcherDelegate,SLArticleDataXMLParserDelegate,DownloadManagerDelegate> {
   
    UIWebView            *_webView;
    LoaderView           *_loader;
    NSMutableString      *_displayStr;
    SLServerDataFetcher  *_slServerDataFetcher;
    SLServerXMLResponse  *_currentResponse;
    Article              *_currentArticle;
    NSArray              *_referencesArray;
    short                _issueId;
    
    __unsafe_unretained id <ArticleDetailViewDelegate> _delegate;
}

@property (nonatomic, assign) id <ArticleDetailViewDelegate> delegate;
@property (nonatomic, strong) UIWebView *webView;

- (void)stopLoading;                       
- (void)showArticle:(Article *)article;   
- (void)setStatus:(NSInteger)st;          
- (void)uploadCssNumber:(short)cssNum;     
- (short)searchText:(NSString *)searchText;
- (void)clearInnerSearch;                
- (void)makeSelectionAtText:(short)index 
       andUnselectPrevIndex:(short)prevIndex;
@end
