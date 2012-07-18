//
//  PDFController.m
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PDFController.h"
#import "Utility.h"

@implementation PDFController
@synthesize pdfPage;
@synthesize totalPages;
@synthesize currentPage,thumbPdfName;


static PDFController * _sharedPdfController;

#pragma mark -
#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
        if (_sharedPdfController == nil) {
			// assignment and return on first allocation
            _sharedPdfController = [super allocWithZone:zone];	
			
            return _sharedPdfController;
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;	
}



+ (PDFController *)sharedController {
	@synchronized(self) {
        if (_sharedPdfController == nil) {
           _sharedPdfController = [[self alloc] init];
        }
    }
    return _sharedPdfController;
}




#pragma mark -
#pragma mark PDF Methods

- (NSString*)getPdfUrlForMagazineId:(NSString *)articalId withPdfFileName:(NSString*)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSMutableString *documentsDirectory = [[NSMutableString alloc]initWithString:[paths objectAtIndex:0]];
	documentsDirectory = (NSMutableString*)[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",articalId,fileName]];
	if(![fileManager fileExistsAtPath:documentsDirectory])
		return nil;

	return documentsDirectory;
}

- (BOOL)loadPdf:(NSString *)articalObject {
	
	NSString *documnetUrl = [GetCachesDirPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"pdf/%@",articalObject]];
	if(documnetUrl == nil)
		return FALSE;
	
	NSMutableString *pdfUrl = [[NSMutableString alloc]initWithString:documnetUrl];
	CFURLRef pdfURL = CFURLCreateWithFileSystemPath(NULL, (__bridge CFStringRef)pdfUrl, kCFURLPOSIXPathStyle, FALSE);	
	
	pdfBook = CGPDFDocumentCreateWithURL(pdfURL);
	CFRelease(pdfURL);
	
	
	totalPages = CGPDFDocumentGetNumberOfPages(pdfBook);
	if (totalPages == 0) {
		return FALSE;
	}
	currentPage = 1;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
		
	return TRUE;
}



- (bool)pageTurnNext {
	if (currentPage >=  totalPages)
		return NO;
	
	currentPage = currentPage + 1;
	
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
	
	return YES;
}

- (bool)pageTurnPrev {
	if (currentPage == 1)
		return NO;
	
	currentPage = currentPage - 1;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);
	
	
	return YES;
}


- (void)pageTurnTo:(int)aPage {
	
	currentPage = aPage;
	pdfPage = CGPDFDocumentGetPage (pdfBook, currentPage);	
}
@end
