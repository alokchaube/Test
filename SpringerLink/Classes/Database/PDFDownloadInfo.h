//
// PDFDownloadInfo.h
//  SpringerLink
//
//  Created by Prakash Raj on 15/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

/*
 * status - 1 : to start downloading.
            2 : downloading is in process.
            3 : downloaded.
 * name  -  name of the PDF in cache directory.
 */

#import <Foundation/Foundation.h>

typedef enum {
 
    PDFNotDownloaded = 1,
    PDFIsDownloading,
    PDFHasDownloaded,
    
} PDFDownloadStatus;
  
@interface PDFDownloadInfo : NSObject {
    
    NSString  *_name;
    NSString  *_doi;
    
    NSInteger _pdfId;
    PDFDownloadStatus _downloadStatus;
    BOOL      _isPDFFileRead;
}

@property (nonatomic, assign) NSInteger pdfId; 
@property (nonatomic, assign) BOOL      isPDFFileRead;
@property (nonatomic, assign) PDFDownloadStatus downloadStatus;

@property (nonatomic,copy)   NSString  *name;
@property (nonatomic,copy)   NSString  *doi;
@end
