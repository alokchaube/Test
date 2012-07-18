//
//  PDFReaderScroller.m
//  SRPS
//
//  Created by Subhash on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PDFReaderScroller.h"
#import "PDFController.h"
//#import "Icosahedron_AppDelegate.h"

@implementation PDFReaderScroller


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.scrollEnabled = YES;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.userInteractionEnabled = YES;
		self.autoresizesSubviews = NO;
		self.bounces = NO;
		self.delaysContentTouches = NO;
		self.delegate = self; 
		self.backgroundColor = [UIColor whiteColor];
		self.maximumZoomScale = 10.0;
		self.minimumZoomScale = 0.5;
		
		
		PDFController *pdfController = [PDFController sharedController];
		
		pdfView = [[TilingView alloc] initWithPDFPage:pdfController.pdfPage size:CGSizeMake(self.frame.size.width-self.frame.size.width*0.22,self.frame.size.height-self.frame.size.height*0.22) widthCallerDelegate:self];
		
		[pdfView setOpaque:NO];
		[self addSubview:pdfView];
		
		[self setScrollerZoomScal];
	}
    return self;
}

- (void)showLoader
{
	if([pdfDelegate respondsToSelector:@selector(showLoader)])
		[pdfDelegate showLoader];
}
- (void)hideLoader
{
	if([pdfDelegate respondsToSelector:@selector(hideLoader)])
		[pdfDelegate hideLoader];
												
}
- (void)removeLoaderViewfromSuperView
{
	
}



- (void)setScrollerZoomScal
{
	self.minimumZoomScale = self.frame.size.height/pdfView.frame.size.height;
	self.zoomScale = self.frame.size.height/pdfView.frame.size.height;
	[self setContentSize:CGSizeMake(pdfView.frame.size.width, pdfView.frame.size.height)];
}
- (void)checkForOrientation
{
//	Icosahedron_AppDelegate *appDelegate = (Icosahedron_AppDelegate*)[[UIApplication sharedApplication]delegate];
//	if (appDelegate.navViewController.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || appDelegate.navViewController.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self setZoomForLandscape];
//	}
}

- (void)setZoomForLandscape
{
	self.minimumZoomScale = 2.742;
	self.zoomScale = 2.742;
	[self setContentOffset:CGPointMake(550.0, 0.0)];

    [self setContentSize:CGSizeMake(self.contentSize.width-550.0, pdfView.frame.size.height)];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	[super touchesBegan:touches withEvent:event];
		
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {  
	
	CGRect zoomRect;  
	
	zoomRect.size.height = [self frame].size.height / scale;  
	zoomRect.size.width  = [self frame].size.width  / scale;  
	
		// choose an origin so as to get the right center.  
		zoomRect.origin.x    = center.x - (zoomRect.size.width  / 1.0);  
		zoomRect.origin.y    = center.y - (zoomRect.size.height / 1.0);  
	
	
	return zoomRect;  
}  
- (void)setContaintOffset
{
	
    
    [self setContentOffset:CGPointMake(0.0, self.contentOffset.y)];

	
} 

- (void)handleDoubleTap
{
	if(self.zoomScale>self.minimumZoomScale)
	{
		[self setZoomScale:self.minimumZoomScale animated:YES];
		[self performSelector:@selector(setContaintOffset) withObject:nil afterDelay:0.0];
	}
	else {
		float newScale = [self zoomScale] * 2.0;  
		CGRect zoomRect  = [self zoomRectForScale:newScale withCenter:doubleTabScale];  
		[self zoomToRect:zoomRect animated:YES]; 
				
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	
	if(tapCount<= 1)
	{
        CGPoint currentPoint = [touch locationInView:self];
		touchEndX = currentPoint.y;
		if (self.zoomScale <= self.minimumZoomScale) {
            
			if (touchEndX+10.0 < touchStartX) {
				
				if([pdfDelegate respondsToSelector:@selector(pageTurnNext)])
					[pdfDelegate pageTurnNext];
				return;
			}
			else if (touchEndX > touchStartX+10.0) {
				if(self.contentOffset.x>0.0)return;
				if([pdfDelegate respondsToSelector:@selector(pageTurnPrev)])
					[pdfDelegate pageTurnPrev];
				return;
			}
		}
		/*
		CGPoint currentPoint = [touch locationInView:self];
		touchEndX = currentPoint.x;
		if (self.zoomScale <= self.minimumZoomScale) {
            
			if (touchEndX+10.0 < touchStartX) {
				
				if([pdfDelegate respondsToSelector:@selector(pageTurnNext)])
					[pdfDelegate pageTurnNext];
				return;
			}
			else if (touchEndX > touchStartX+10.0) {
				if(self.contentOffset.x>0.0)return;
				if([pdfDelegate respondsToSelector:@selector(pageTurnPrev)])
					[pdfDelegate pageTurnPrev];
				return;
			}
		}
		*/
	}
	
	
	if ([touch tapCount] == 1) {
		
		
		
	} else if([touch tapCount] == 2) {
		
		doubleTabScale = [touch locationInView:self];
		
		[self handleDoubleTap];
		
	}
	
	
	
	
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

	if ([[event allTouches] count] > 1) return;
	
	UITouch *touch = [touches anyObject];
	
	CGPoint currentPoint = [touch locationInView:self];
	touchEndX = currentPoint.x;
	
	if (self.zoomScale <= self.minimumZoomScale) {
		if (touchEndX < touchStartX) {
			if(self.contentOffset.x+self.frame.size.width<self.contentSize.width) return;
			
			if([pdfDelegate respondsToSelector:@selector(pageTurnNext)])
				[pdfDelegate pageTurnNext];
		}
		else if (touchEndX > touchStartX) {
			if(self.contentOffset.x>0.0)return;
			if([pdfDelegate respondsToSelector:@selector(pageTurnPrev)])
				[pdfDelegate pageTurnPrev];
		}
	}
	
	
	
	[super touchesCancelled:touches withEvent:event];
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
	
	if ([[event allTouches] count] > 1) return NO;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
	touchStartX = currentPoint.y;
	
	
	return [super touchesShouldBegin:touches withEvent:event inContentView:view];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return the first subview of the scroll view
    return pdfView;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	scrollStart = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	
}

- (void)scrollViewDidEndZooming:(UIScrollView *)zoomedScrollView withView:(UIView *)view atScale:(float)scale
{
	[pdfView setNeedsDisplay];
	[self setNeedsDisplay];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	scrollEnd = scrollView.contentOffset;
	
	if (self.zoomScale <= self.minimumZoomScale) return;
	
	
	if (scrollStart.x == scrollEnd.x && abs(ceil(scrollStart.y - scrollEnd.y)) < 10) {
		if (touchEndX < touchStartX) {
			if([pdfDelegate respondsToSelector:@selector(pageTurnNext)])
				[pdfDelegate pageTurnNext];
		}
		else if (touchEndX > touchStartX) {
			if([pdfDelegate respondsToSelector:@selector(pageTurnPrev)])
				[pdfDelegate pageTurnPrev];
		}
	}
}


- (void)setPDFDelegate:(id)newDelegate {
	pdfDelegate = newDelegate;
	
}
- (void)resetPdfZooming
{
	self.zoomScale = 1.0;
	self.minimumZoomScale = self.frame.size.height/pdfView.frame.size.height;
	self.zoomScale = self.frame.size.height/pdfView.frame.size.height;
	[self setContentOffset:CGPointMake(0.0, self.contentOffset.y)];

	
}

- (void)changePdfScrollerOrientationToLandscape
{
	self.zoomScale = 1.0;
	self.minimumZoomScale = 1.742;
	self.zoomScale = 1.742;
	[self setContentOffset:CGPointMake(0.0, self.contentOffset.y)];

	self.pagingEnabled = NO;
	
}

- (void)changePdfScrollerOrientationToPortait
{
	[self resetPdfZooming];
	self.pagingEnabled = NO;
	
	
}

@end
