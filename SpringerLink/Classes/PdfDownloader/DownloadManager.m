//
//  DownloadManager.m
//  downloadTest
//
//  Created by kiwitech  on 16/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadManager.h"
#import "SpringerLinkAppDelegate.h"
#import "DBManager.h"


@interface DownloadManager ()
- (void)startDownload;
- (void)finishDownload;
@end

@implementation DownloadManager

@synthesize delegate;
@synthesize pdfBtnArray;

int currentIndex;
Download *downloader;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)DownloadTheseItems:(NSMutableArray *)list
{
    currentIndex=0;
    items = list;
   
    //[items retain];
    if (!isFirstDownlod) {
        isFirstDownlod = YES;
        NSLog(@"download called---------");
      [self startDownload];  
    }
    
}

- (void)downloadThisItem:(NSDictionary *)itm;
{
    NSMutableArray *obj = [SpringerLinkAppDelegate getURLQueueArray];
    [obj enqueue:itm];
    [self DownloadTheseItems:obj];
}

- (void)forceQuitDownload
{
    [downloader cancelDownloading];
}

#pragma mark- private methods

- (void)startDownload
{
    itemDic=[items dequeue]; 
//    if([[database sharedDatabase] statusOfFile:[[itemDic objectForKey:@"path"]lastPathComponent]]==2)
//    {
//        UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"" 
//                                                     message:@"Already downloaded" 
//                                                    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alrt show];
//        
//        
//        [self finishDownload]; return;
//    }
    
    long long int offset=0;
    
    downloader=[[Download alloc] init];
    downloader.delegate=self;
    [downloader startDownloadFromURL:[itemDic objectForKey:@"url"]
                          withOffset:offset 
                          saveAtPath:[itemDic objectForKey:@"path"]];
    
}

- (void)finishDownload {
    
    if ([items count]>0) {
        
        [self startDownload];
        isFirstDownlod = YES;
        
    } else {
        
        isFirstDownlod = NO;
    }
    UIButton *pdfbtn = [pdfBtnArray objectAtIndex:0];
    pdfbtn.enabled =YES; 
    [pdfBtnArray removeObjectAtIndex:0];
    
    if(delegate && [delegate respondsToSelector:@selector(downloadingCompleteWthError:)])
        [delegate downloadingCompleteWthError:NO];
} 



#pragma mark- Download delegate

- (void)persentageOfDownloading:(float)val
{
    if([delegate respondsToSelector:@selector(persentageDownload:ofArtNumber:)])
        [delegate persentageDownload:val ofArtNumber:currentIndex];
}

- (void)ArticleIsDownloaded
{
    [self finishDownload];
}

- (void)closeDueToError
{
    if([delegate respondsToSelector:@selector(downloadingCompleteWthError:)])
        [delegate downloadingCompleteWthError:YES];
}
@end
