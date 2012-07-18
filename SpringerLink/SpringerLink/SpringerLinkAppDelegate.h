//
//  SpringerLinkAppDelegate.h
//  SpringerLink
//
//  Created by Kiwitech on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMetadataXMLParser.h"
#import "ASIHTTPRequest.h"
#import "SearchResultViewController.h"
#import "ArticleDetailPageViewController.h"


@class SLMetadataReader;
@class SearchViewController;
@class ArticleDetailPageViewController;
@class ArticalListViewController;
@interface SpringerLinkAppDelegate : UIResponder
<UIApplicationDelegate,SLMetadataXMLParserDelegate,UISplitViewControllerDelegate> {

@private
    ASIHTTPRequest         *_httpRequest;          //contain http request information
    UIWindow               *_window;               //contain window object information
    NSArray                *_arrayKeywords;        //contain array of keywords information
    UINavigationController *_navController;     //contain navigation controller object information
    BOOL                   _isResponseGet;
     SearchViewController   * _searchVC;
}

@property (nonatomic,assign)  BOOL isResponseGet;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *arrayKeywords;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (strong, nonatomic) ArticleDetailPageViewController *articleDetailViewController;
@property (strong, nonatomic) UINavigationController *articleDetailNavController;
@property (strong, nonatomic) UINavigationController *articleListNavController;
@property (strong, nonatomic) ArticalListViewController *articalListViewController;

+(id)getURLQueueArray;
@end
