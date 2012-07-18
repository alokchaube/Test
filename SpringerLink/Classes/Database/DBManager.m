//
//  DBManager.m
//  SpringerLink
//
//  Created by Prakash Raj on 15/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "DBArticle.h"
#import "PDFDownloadInfo.h"

#import "DBReferences.h"


@interface DBManager ()
- (BOOL)executeQuery:(NSString *)query;
@end


@implementation DBManager

static DBManager *_sharedDBManager=nil;
sqlite3 *myDatabase;

//method to alloc this class...raj
+ (DBManager *)sharedDBManager
{
    @synchronized(self) {
        if(_sharedDBManager == nil) 
            _sharedDBManager = [[DBManager alloc]init];
    }
    return _sharedDBManager;
}

- (void)createDatabase:(NSString *)DBName {
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:DBName];
    
	NSFileManager *filemgr = [NSFileManager defaultManager];
	if ([filemgr fileExistsAtPath:databasePath])
        return;
   	//Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
	// Copy the database from the package to the users filesystem
    
    if(![filemgr copyItemAtPath:databasePathFromApp 
                         toPath:databasePath error:nil]) {
        NSLog(@"Error to create database");return;
    }
    
    NSLog(@"database successfully created !");
}

//common...
- (BOOL)isDoi:(NSString *)doi 
 existInTable:(NSString *)tableNm {
    
    BOOL flg = NO;
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT count(*) from %@  where art_Doi = '%@'",tableNm,doi];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(myDatabase, [sql UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
            if(sqlite3_step(statement) == SQLITE_ROW) {
                flg = (BOOL)sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return flg;
}

#pragma mark - article table

- (DBArticle *)articleWithDoi:(NSString *)doi {
    
    DBArticle *article = [[DBArticle alloc] init];
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from ArticleTable WHERE art_Doi='%@'",doi];
        sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
            char *value = NULL;
            short indexNumber = 0;
    
			if(sqlite3_step(statement) == SQLITE_ROW) { 
                
                indexNumber = 0;
                
                article.ID = sqlite3_column_int(statement,indexNumber++);
                
                article.title = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.type = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.journalNo = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.authors = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.date = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.doi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.artIssueId = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                article.refId = sqlite3_column_int(statement,indexNumber++);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    
    return article;
}

- (void)saveArticle:(DBArticle *)article {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into ArticleTable (art_Title,art_Type,art_Journal_No,Art_Authors,art_Date,art_Doi,art_IssueId,art_Ref_Id) values('%@','%@','%@','%@','%@','%@','%@',%i);",
                           article.title,article.type,article.journalNo,
                           article.authors,article.date,article.doi,
                           article.artIssueId,article.refId];
    if([self executeQuery:query_srt])
        NSLog(@"Inserted...");
    
}
- (void)updateArticleOfDoi:(NSString *)doi 
               withArticle:(DBArticle *)article {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE ArticleTable SET art_Title='%@',art_Type='%@',art_Journal_No='%@',Art_Authors='%@',art_Date='%@',art_Doi='%@',art_IssueId='%@',art_Ref_Id=%i WHERE art_Doi='%@';",
                           article.title,article.type,article.journalNo,
                           article.authors,article.date,article.doi,article.artIssueId,article.refId,doi];
    if([self executeQuery:query_srt])
        NSLog(@"updated...");
}

- (void)deleteArticle:(DBArticle *)article {
    NSString *query_srt = [[NSString alloc] initWithFormat:@"DELETE FROM ArticleTable WHERE art_Doi = '%@';",article.doi];
    if([self executeQuery:query_srt])
        NSLog(@"Deleted...");
}

#pragma mark - PDF table

- (PDFDownloadInfo *)PDFWithDoi:(NSString *)doi {
    
    PDFDownloadInfo *pdf = [[PDFDownloadInfo alloc] init];
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from PDFTable WHERE art_Doi='%@'",doi];
        sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
            char *value = NULL;
            short indexNumber = 0;
            
			if(sqlite3_step(statement) == SQLITE_ROW) { 
                
                indexNumber = 0;

                pdf.doi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil:                 [NSString stringWithUTF8String:value]; 
				pdf.pdfId = sqlite3_column_int(statement, indexNumber++);
				pdf.isPDFFileRead = sqlite3_column_int(statement, indexNumber++);
				pdf.downloadStatus = sqlite3_column_int(statement, indexNumber++);
                
                if(pdf.downloadStatus == 0) {
                    pdf.downloadStatus = PDFNotDownloaded;
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return pdf;
}
- (void)savePDF:(PDFDownloadInfo *)pdf {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into PDFTable (art_Doi,pdf_ReadStatus,pdf_Status) values('%@','%i',%i);",pdf.doi,pdf.isPDFFileRead,pdf.downloadStatus];
    if([self executeQuery:query_srt])
        NSLog(@"Inserted...");
    
}
- (void)updatePDFOfDoi:(NSString *)doi 
               withPDF:(PDFDownloadInfo *)pdf {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE PDFTable SET art_Doi='%@',pdf_Name='%@',pdf_Status=%i WHERE art_Doi = '%@';",pdf.doi,pdf.isPDFFileRead,pdf.downloadStatus,doi];
    if([self executeQuery:query_srt])
        NSLog(@"Updated...");
    
}
- (void)deletePDF:(PDFDownloadInfo *)pdf {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"DELETE FROM PDFTable WHERE art_Doi = '%@';",pdf.doi];
    if([self executeQuery:query_srt])
        NSLog(@"Deleted...");
}

- (void)deleteNotDownloadedPDFFromPdfTable {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"DELETE FROM PDFTable WHERE pdf_Status =%d OR pdf_Status =%d;",PDFIsDownloading,PDFNotDownloaded];
    if([self executeQuery:query_srt])
        NSLog(@"Deleted...");
}

- (void)changeStatusOfPdfWithDoi:(NSString *)doi 
                      withStatus:(NSInteger)st {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE PDFTable SET pdf_Status=%i WHERE art_Doi = '%@';",st,doi];
    if([self executeQuery:query_srt])
        NSLog(@"Status changed...");
}

- (void)changeReadStatusOfPdfWithDoi:(NSString *)doi 
                      withStatus:(NSInteger)st {
    
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE PDFTable SET pdf_ReadStatus=%i WHERE art_Doi = '%@';",st,doi];
    if([self executeQuery:query_srt])
        NSLog(@"Read Status changed...");
}

- (NSArray *)allDownloadedPdfs {
    
    NSMutableArray *pdfsArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from PDFTable where pdf_Status = 3"];
        sqlite3_stmt *statement;
		
        if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
                 
            short indexNumber = 0;
            char *value = NULL;

			while(sqlite3_step(statement) == SQLITE_ROW) { 
              
                indexNumber = 0;
                PDFDownloadInfo *pdf = [[PDFDownloadInfo alloc] init];
                
                pdf.downloadStatus = sqlite3_column_int(statement, 3);

                pdf.doi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil:                 [NSString stringWithUTF8String:value]; 
				pdf.pdfId = sqlite3_column_int(statement, indexNumber++);
				pdf.isPDFFileRead = sqlite3_column_int(statement, indexNumber++);
                  
                if(pdf.downloadStatus == 0) {
                    pdf.downloadStatus = PDFNotDownloaded;
                }

                [pdfsArr addObject:pdf];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return pdfsArr;
}



- (int)totalDownloadedPdfs {
    
    int count = 0;
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from PDFTable where pdf_Status = 3"];
        sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
			while(sqlite3_step(statement) == SQLITE_ROW) { 

                char *pass4 = (char*)sqlite3_column_text(statement,3);
                if([[NSString stringWithUTF8String:pass4] intValue] != 3)
                    continue;
                count++; 
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return count;
}

- (NSArray *)doiForNotDownloadedPdf {
    
    NSMutableArray *doiArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select art_Doi from PDFTable where pdf_Status = %d OR pdf_Status = %d",PDFIsDownloading,PDFNotDownloaded];
        sqlite3_stmt *statement;
		
        if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {

            char *value = NULL;
            
			while(sqlite3_step(statement) == SQLITE_ROW) { 
                
                NSString *doi = (value = (char *)sqlite3_column_text(statement,0)) == NULL ? nil:                 [NSString stringWithUTF8String:value]; 
                if (doi) 
                    [doiArray addObject:doi];               
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return doiArray;
}


//common...
- (PDFDownloadStatus)statusForArticalDoi:(NSString*)doi {
    
    PDFDownloadStatus status = PDFNotDownloaded;
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT pdf_status from PDFTable  where art_Doi = '%@'",doi];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(myDatabase, [sql UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
            if(sqlite3_step(statement) == SQLITE_ROW) {
                status = sqlite3_column_int(statement, 0);
                
                if(status == 0)
                    status = PDFNotDownloaded;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return status;
}


- (void)saveReference:(DBReferences *)reference {
    
    NSString *doi = (reference.doi == nil) ? @"NO DOI" : reference.doi; 
    NSString *coi = (reference.coi == nil) ? @"NO DOI" : reference.coi;
    NSLog(@"%@",doi);
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into ReferenceTable (citiation_No,year,volume_Id,first_Page,journal_Title,doi,coi,authors,issue_Id,art_Doi) values(%i,%i,%i,%i,'%@','%@','%@','%@',%i,'%@');",reference.citiationNo,reference.year,reference.volumeID,reference.firstPage,reference.journalTitle,doi,coi,reference.authorsStr,reference.issueId,reference.artDoi];
    if([self executeQuery:query_srt])
        NSLog(@"Inserted...");
    
}

- (NSArray *)referencesWithArtDoi:(NSString *)artDoi {
    NSMutableArray *_referencesArray = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from ReferenceTable where art_Doi = '%@'",artDoi];
        sqlite3_stmt *statement;
		
        if(sqlite3_prepare_v2(myDatabase, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            
            char *value = NULL;
            short indexNumber = 0;
            
			while(sqlite3_step(statement) == SQLITE_ROW) { 
                
                indexNumber = 0;
                DBReferences *_reference = [[DBReferences alloc]init];
                _reference.citiationNo = sqlite3_column_int(statement, indexNumber++);
                _reference.year = sqlite3_column_int(statement, indexNumber++);
                _reference.volumeID = sqlite3_column_int(statement, indexNumber++);
                _reference.firstPage = sqlite3_column_int(statement, indexNumber++);
                
                _reference.journalTitle = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                _reference.doi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                _reference.coi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                _reference.authorsStr = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
                
                _reference.issueId = sqlite3_column_int(statement, indexNumber++);
                 _reference.artDoi = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
               
                
                [_referencesArray addObject:_reference];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
    return _referencesArray;
}

#pragma mark - private methods

- (BOOL)executeQuery:(NSString *)query {
    
    BOOL flg = NO;
    if(sqlite3_open([databasePath UTF8String],&myDatabase) == SQLITE_OK) {
        char *err1;
        if(sqlite3_exec(myDatabase,[query UTF8String],NULL,NULL,&err1) == SQLITE_OK)
            flg = YES;
		sqlite3_close(myDatabase);
    }
    return flg;
}
@end
