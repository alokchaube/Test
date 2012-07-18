//
//  DBManager.h
//  SpringerLink
//
//  Created by Prakash Raj on 15/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "PDFDownloadInfo.h"

@class DBArticle;
@class DBReferences;

@interface DBManager : NSObject {
    
     NSString *databasePath;
}

//---initial methods-------
+ (DBManager *)sharedDBManager;              
- (void)createDatabase:(NSString *)DBName; 


//methods for article table
- (DBArticle *)articleWithDoi:(NSString *)doi;
- (void)saveArticle:(DBArticle *)article;
- (void)updateArticleOfDoi:(NSString *)doi 
               withArticle:(DBArticle *)article;
- (void)deleteArticle:(DBArticle *)article;



//methods for PDF table
- (PDFDownloadInfo *)PDFWithDoi:(NSString *)doi;
- (PDFDownloadStatus)statusForArticalDoi:(NSString*)doi; 
- (void)savePDF:(PDFDownloadInfo *)pdf;
- (void)updatePDFOfDoi:(NSString *)doi 
               withPDF:(PDFDownloadInfo *)pdf;
- (void)deletePDF:(PDFDownloadInfo *)pdf;
- (void)deleteNotDownloadedPDFFromPdfTable;
- (void)changeStatusOfPdfWithDoi:(NSString *)doi 
               withStatus:(NSInteger)st;
- (NSArray *)allDownloadedPdfs;
- (int)totalDownloadedPdfs;
- (NSArray *)doiForNotDownloadedPdf;
- (void)changeReadStatusOfPdfWithDoi:(NSString *)doi 
                          withStatus:(NSInteger)st;


//method for references table
- (void)saveReference:(DBReferences *)reference;
- (NSArray *)referencesWithArtDoi:(NSString *)artDoi;

//common.....
- (BOOL)isDoi:(NSString *)doi 
 existInTable:(NSString *)tableNm;

@end
