//
//  PDFController.h
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 
 This class is used to handled the funtionality of PDF like count the pages,turn the pages, next and prev the pages.
 
*/


#import <Foundation/Foundation.h>

@interface PDFController : NSObject {
	CGPDFPageRef pdfPage;
	CGPDFDocumentRef pdfBook;
	
	int totalPages;
	int currentPage;
}

@property(nonatomic,retain)NSString *thumbPdfName;
@property CGPDFPageRef pdfPage;
@property int totalPages;
@property int currentPage;

+ (PDFController *)sharedController;
- (bool)pageTurnNext;
- (bool)pageTurnPrev;
- (void)pageTurnTo:(int)aPage;
- (BOOL)loadPdf:(NSString *)articalObject;
@end
