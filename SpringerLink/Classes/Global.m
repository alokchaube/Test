//
//  Global.m
//  SpringerLink
//
//  Created by Prakash Raj  on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "Global.h"
#import "XMLDictionary.h"
#import "Utility.h"
#import "ApplicationConfiguration.h"

#import "SearchResultViewController.h"
#import "SearchViewController.h"
#import "ArticleDetailPageViewController.h"
#import "IssueDetailViewController.h"
#import "DBManager.h"
#import "DetectNetworkConnection.h"
#import "ArticalListViewController.h"
#import "LatestArticleListViewController.h"
#import "OnlineArticleListViewController.h"


@implementation Global

@synthesize searchResultViewController;
@synthesize articleDetailPageViewController;
@synthesize searchViewController;
@synthesize issueDetailViewController;
@synthesize latestArticleListViewController;
@synthesize onlineArticleListViewController;
@synthesize volumeXMLResponse;
@synthesize badgeNumber;
@synthesize lblBadge;
@synthesize imgViewBadge;
@synthesize btnPdfView;

static Global *_sharedGlobal = nil;
static DownloadManager *downloadManager = nil;

NSMutableArray *listOfDoi;

//method to return an object of this class.
+ (Global *)shared {
    
    @synchronized(self) {
        
        if(_sharedGlobal == nil) {
            
             _sharedGlobal = [[Global alloc]init];
            downloadManager = [[DownloadManager alloc] init];
            [downloadManager setDelegate:_sharedGlobal];
            
            listOfDoi = [[NSMutableArray alloc] init];
        }  
    }
    return _sharedGlobal;
}
 
// method for reload table 
- (void)refereshTableDataWithStatus:(PDFDownloadStatus)status {
    
    if(listOfDoi== nil || listOfDoi.count <= 0)
        return;
    [searchResultViewController.articalListViewController reloadTableData];
    [searchViewController.articalListViewController reloadTableData];
    [issueDetailViewController.articalListViewController reloadTableData];
    [latestArticleListViewController.articalListViewController reloadTableData];
    [onlineArticleListViewController.articalListViewController reloadTableData];
    //change done ---raj
    if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
        [articleDetailPageViewController setCurrentStatus:status];  
    }
}


- (NSString *)pdfURL:(NSString*)doi {
    
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",kPDFURL, doi];
    return urlStr;
}

- (NSMutableString *)getdocumentPath:(NSString *)directoryName {
    
    NSFileManager *filemgr =[NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                            NSUserDomainMask, YES);
    NSMutableString *docsDir = [dirPaths objectAtIndex:0];
    docsDir = (NSMutableString*)[docsDir stringByAppendingPathComponent:directoryName];
    
    
    if (![filemgr fileExistsAtPath:docsDir]) {
        
        if ([filemgr createDirectoryAtPath:docsDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO) {
            NSLog(@"directory is not created");
        }
    }
    
    return docsDir;
}

- (NSMutableString *)getPathForPdf:(NSString *)filename {
    
    NSMutableString *pdfFilePath = [self getdocumentPath:@"pdf"];
	pdfFilePath=(NSMutableString*)[pdfFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",filename]];
    return pdfFilePath;
}

- (NSString *)getFullPdfPath:(NSString *)doi {
    
    NSString *fileName = [doi stringByReplacingOccurrencesOfString:@"/" withString:@"-"];//[[self pdfURL:doi] lastPathComponent];
    NSString *fullPath = [self getPathForPdf:fileName];
    return fullPath;
}

- (void)refreshDownloadButton{
    
    if ([[DBManager sharedDBManager] totalDownloadedPdfs] >= 1) {
        
        [btnPdfView setEnabled:([[DBManager sharedDBManager] totalDownloadedPdfs] >= 1)];
        
    } else {
        
        [btnPdfView setEnabled:NO];
    }
}


// selector....
- (void)onRecievingPdfServerResponse:(NSDictionary*)responseDic 
                objectInfoDictionary:(NSDictionary*)objInfoDic {
    
    NSLog(@"%@",responseDic);
    
    if([[responseDic objectForKey:@"Error"] isEqualToString:@"NO"]) {
        
        [listOfDoi addObject:[responseDic objectForKey:@"doi"]];
        NSDictionary *objDic = [NSDictionary dictionaryWithXMLData:[responseDic objectForKey:@"response"]];
        NSLog(@"%@",[objDic description]);
        NSDictionary *tempDic = [objDic objectForKey:@"pdf"];
        
        NSString *fullPath = [self getFullPdfPath:[responseDic objectForKey:@"doi"]];
        NSString *fileName = [fullPath lastPathComponent];
        NSLog(@"Full Path:%@",fullPath);
        NSLog(@"File name:%@",fileName);
        
        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
                            fullPath,@"path",
                            [NSURL URLWithString:[tempDic objectForKey:@"url"]],@"url",nil];
        NSLog(@"URL Response Time:%@",[NSDate date]);
        
                
        if(![DetectNetworkConnection isNetworkConnectionActive]) {
            
            //fail...
            NSLog(@"Failed..");
            listOfDoi = [responseDic objectForKey:@"doi"];
            
            for(NSString *doi in listOfDoi) {
                
                [[DBManager sharedDBManager] changeStatusOfPdfWithDoi:doi 
                                                           withStatus:PDFNotDownloaded];
            }
            
            [self refereshTableDataWithStatus:PDFNotDownloaded];

//            if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
//                [articleDetailPageViewController setCurrentStatus:PDFNotDownloaded];  
//            }
            
            showAlert(NetworkErrorMessage);
            return;
        }
        else {
            [downloadManager downloadThisItem:dict];
        }
        [[DBManager sharedDBManager] changeStatusOfPdfWithDoi:[responseDic objectForKey:@"doi"] 
                                                   withStatus:PDFIsDownloading];
        [self refereshTableDataWithStatus:PDFIsDownloading];

        /*
        //change done ---raj
        if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
            [articleDetailPageViewController setCurrentStatus:PDFIsDownloading];  
        }
         */
        
    } else {
        
        //fail...
        NSLog(@"Failed..");
        listOfDoi = [responseDic objectForKey:@"doi"];
        
        for(NSString *doi in listOfDoi) {
            
            [[DBManager sharedDBManager] changeStatusOfPdfWithDoi:doi 
                                                       withStatus:PDFNotDownloaded];
        }
        
        [self refereshTableDataWithStatus:PDFNotDownloaded];

//        if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
//          [articleDetailPageViewController setCurrentStatus:PDFNotDownloaded];  
//        }
        
        showAlert(NetworkErrorMessage);
    }
}

#pragma mark - DownloadManagerDelegate

- (void)downloadingCompleteWthError:(BOOL)yesNoErr {

    int status = (yesNoErr) ? PDFNotDownloaded : PDFHasDownloaded;
    [[DBManager sharedDBManager] changeStatusOfPdfWithDoi:[listOfDoi objectAtIndex:0] 
                                               withStatus:status];
    
    [[Global shared].imgViewBadge setHidden:yesNoErr];
    NSLog(@"badgeNumber %d",badgeNumber);
    (status == PDFHasDownloaded) ?  badgeNumber++ :badgeNumber;
     NSLog(@"badgeNumber %d",badgeNumber);
    
    [[NSUserDefaults standardUserDefaults] setInteger:[Global shared].badgeNumber forKey:@"badgeNumber"];
    [lblBadge setText:[NSString stringWithFormat:@"%d",badgeNumber]];
    
    
    [self refereshTableDataWithStatus:status];

//    if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
//        [articleDetailPageViewController setCurrentStatus:status];  
//    }
    
    [self refreshDownloadButton];
    if (yesNoErr) {
        for(NSString *doi in listOfDoi) {
            
            [[DBManager sharedDBManager] changeStatusOfPdfWithDoi:doi 
                                                       withStatus:PDFNotDownloaded];
        }
        
        [self refereshTableDataWithStatus:PDFNotDownloaded];

//        if ([articleDetailPageViewController.currentArticle.doi isEqualToString:[listOfDoi objectAtIndex:0]]) {
//            [articleDetailPageViewController setCurrentStatus:PDFNotDownloaded];  
//        }
        showAlert(NetworkErrorMessage);
    }
    [listOfDoi removeObjectAtIndex:0];
    
}


@end
