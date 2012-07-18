//
//  PDFReaderScroller.h
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
 
 This class is used to scroll the PDF.
 
*/

#import <UIKit/UIKit.h>
#import "TilingView.h"
@protocol PDFPageTurnDelegate <NSObject>
@optional
- (void)pageTurnPrev;
- (void)pageTurnNext;
- (void)pageTurnBelow;
- (void)showLoader;
- (void)hideLoader;
@end

@interface PDFReaderScroller : UIScrollView<UIScrollViewDelegate> {
	float touchStartX;
	float touchEndX;
	CGPoint scrollStart;
	CGPoint scrollEnd;
	TilingView *pdfView;
	BOOL doubleTabIsUsed;
	id<PDFPageTurnDelegate> pdfDelegate;
	CGPoint doubleTabScale;
	NSTimer *touchTimer;
	
	NSTimer *loaderHideTimer;
}
- (void)setScrollerZoomScal;
- (void)setPDFDelegate:(id)newDelegate;
- (void)changePdfScrollerOrientationToLandscape;
- (void)changePdfScrollerOrientationToPortait;
- (void)resetPdfZooming;
- (void)showLoader;
- (void)hideLoader;
- (void)setZoomForLandscape;
@end
