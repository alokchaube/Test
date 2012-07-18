//
//  Download.h
//  SpringerLink
//
//  Created by kiwitech  on 16/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DownloadDelegate <NSObject>

@optional
- (void)persentageOfDownloading:(float)val;
- (void)ArticleIsDownloaded;
- (void)closeDueToError;
@end

@interface Download : NSObject
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,strong) id <DownloadDelegate> delegate;

- (void)startDownloadFromURL:(NSURL *)fileURL 
                  withOffset:(int)offset 
                  saveAtPath:(NSString *)path;
- (void)cancelDownloading;


@end
