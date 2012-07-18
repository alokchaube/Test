//
//  PDFHomeView.h
//  PW_iPad
//
//  Created by Subhash Chand on 1/25/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

/*
    
    This class is used to display the PDF.
 
*/

#import <UIKit/UIKit.h>
#import "PDFReaderScroller.h"
#import "PdfLoader.h"
//#import "Data.h"

#define PDF_SCROLLER_X_OFFSET 0.0
#define PDF_SCROLLER_Y_OFFSET 0.0
#define PDF_SCROLLER_WIDTH self.frame.size.width
#define PDF_SCROLLER_HEIGHT self.frame.size.height-10

@interface PDFHomeView : UIView {
	PDFReaderScroller *_mainPDFScrollView;
	PDFReaderScroller *_tempPDFScrollView;
	BOOL               _isPageAnimated;
	
    UILabel           *_viewHeading;
	PdfLoader         *_pdfLoader;
}

- (void)loadFirstPdfView;
- (void)showLoader;
- (void)hideLoader;
- (BOOL)loadPdfForFileName:(NSString *)articalObject;
- (void)changePdfOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)pageTurnBelow;
@end
