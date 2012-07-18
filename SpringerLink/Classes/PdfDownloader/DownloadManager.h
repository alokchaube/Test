//
//  DownloadManager.h
//  downloadTest
//
//  Created by kiwitech  on 16/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Download.h"
#import "NSMutableArray+QueueAdditions.h"

@protocol DownloadManagerDelegate <NSObject>

@required
@optional
 //------Returns the %ge of download of particular article--
- (void)persentageDownload:(float)val 
               ofArtNumber:(int)k;               

//------fire when downloading is finished or an error occured--
- (void)downloadingCompleteWthError:(BOOL)yesNoErr;
@end

@interface DownloadManager : NSObject <DownloadDelegate> {
    NSMutableArray *items;
    NSDictionary *itemDic;
    BOOL isFirstDownlod;
    NSMutableArray *pdfBtnArray;
}
@property (nonatomic,retain)NSMutableArray *pdfBtnArray;
@property (nonatomic, retain) id <DownloadManagerDelegate> delegate;
         //for list of articles........Raj
- (void)downloadThisItem:(NSDictionary *)itm;         //for single article..........Raj
- (void)forceQuitDownload;   
- (void)DownloadTheseItems:(NSMutableArray *)list;//forcely quit downloading....Raj

@end
