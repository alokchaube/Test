//
//  SpringerLinkAppDelegate.m
//  SpringerLink
//
//  Created by Kiwitech on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpringerLinkAppDelegate.h"
#import "SearchViewController.h"
#import "Utility.h"
#import "Constant.h"
#import "DBManager.h"
#import "ApplicationConfiguration.h"
#import "SLXMLResponse.h"
#import "Global.h"
#import "DownloadedPDFListViewController.h"
#import "ArticleDetailPageViewController.h"


NSMutableArray *queue = nil;
@implementation SpringerLinkAppDelegate

@synthesize window         = _window;
@synthesize navController  = _navController;
@synthesize splitViewController = _splitViewController;
@synthesize arrayKeywords  = _arrayKeywords;
@synthesize isResponseGet  = _isResponseGet;

@synthesize articleDetailViewController = _articleDetailViewController;
@synthesize articleDetailNavController = _articleDetailNavController;
@synthesize articleListNavController = _articleListNavController;
@synthesize articalListViewController = _articalListViewController;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
    
    _isResponseGet = YES;
    queue  = [[NSMutableArray alloc] init];
    [[DBManager sharedDBManager] createDatabase:@"Springer.sqlite"];
    
    
     isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

     self.window   = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    if (isIpad) {

         _searchVC = [[SearchViewController alloc] initWithNibName:@"homeViewController_ipad" bundle:nil];  //SearchViewController Object
        UINavigationController *masterNavigation = [[UINavigationController alloc] initWithRootViewController:_searchVC]; //Navigation Controller Object
        [masterNavigation setNavigationBarHidden:YES];
        
        ArticleDetailPageViewController *secondVC = [[ArticleDetailPageViewController alloc] initWithNibName:@"ArticleDetailPageViewController" bundle:nil];
        secondVC.view.frame = CGRectMake(0, 0, 704, 768);
        _articleDetailNavController = [[UINavigationController alloc] initWithRootViewController:secondVC]; //Navigation Controller Object
        [_articleDetailNavController setNavigationBarHidden:YES];

        _splitViewController = [[UISplitViewController alloc] init];

        _splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigation,_articleDetailNavController, nil];
        _splitViewController.delegate = secondVC;
        
        //--change---
        self.articleDetailViewController = secondVC;
        [self.window setRootViewController:(UIViewController*)_splitViewController];
        
        
    } else {
        
        _searchVC = [[SearchViewController alloc] init];  //SearchViewController Object
        self.navController = [[UINavigationController alloc] initWithRootViewController:_searchVC]; //Navigation Controller Object
        [[self navController] setNavigationBarHidden:YES];
        [self.window addSubview:[[self navController] view]];
        
    }
    
    [self.window makeKeyAndVisible];  
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isIphone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);   
    }
    else{
        return UIInterfaceOrientationIsLandscape(interfaceOrientation); 
    }
}




+ (NSMutableArray*)getURLQueueArray {
    
    return queue;
}

/*
 * This method used for fetching keywords for advance search page 
 * it start searching content for a particular query 
 * @param: qStr-> query for which content is to be find
*/

- (void)startSearchingWithQuery:(NSString *)qStr {
    
    qStr = [qStr stringByReplacingOccurrencesOfString:@" "  withString:@"%20"];
    qStr = [qStr stringByReplacingOccurrencesOfString:@"\""  withString:@"%22"];
    NSURL *url = [NSURL URLWithString:qStr];
    
    //allocate and call a Http request  
    _httpRequest = [ASIHTTPRequest requestWithURL:url];
    [_httpRequest setDelegate:self];
    [_httpRequest startAsynchronous];
}

#pragma mark- ASIHTTPRequest delegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    
   
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    SLMetadataXMLParser *metadataParser=[[SLMetadataXMLParser alloc] init]; //SLMetadataXMLParser object.
    [metadataParser setDelegate:self];
    [metadataParser parseXMLData:[request responseData]];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    showAlert(NetworkErrorMessage);
}

#pragma mark- SLMetadataReader Delegate

/**
 * delegate method for the metadata.
 * @param: metadataResponse-> object of SLXMLResponse class which contain the metadata of articles
 */
- (void)returnMetadataResponse:(SLXMLResponse*)metadataResponse {
    
    Facet *response = [metadataResponse.facets objectAtIndex:1];
    self.arrayKeywords = [response.facetCountByName allKeys];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // If response  get for previous request then hit new request else wait for previous request response 
    if (_isResponseGet){ 
      [_searchVC hitRequestForLatestArticles];  
     _isResponseGet = NO;  
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end

