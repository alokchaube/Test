//
//  PDFHomeView.m
//  PW_iPad
//
//  Created by Subhash Chand on 1/25/11.
//  Copyright 2011 Kiwitech. All rights reserved.
//

#import "PDFHomeView.h"
#import "PDFController.h"

@implementation PDFHomeView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setBackgroundColor:[UIColor redColor]];
		
	}
    return self;
}


- (BOOL)loadPdfForFileName:(NSString *)articalObject
{
    PDFController *pdfController = [PDFController sharedController];
	if([pdfController loadPdf:articalObject] == FALSE)
        return FALSE;
    	
	_viewHeading = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-100.0,0,68.0,36)];
	_viewHeading.text = @"";
	_viewHeading.backgroundColor = [UIColor clearColor];
	_viewHeading.textAlignment = UITextAlignmentCenter;
	_viewHeading.font = [UIFont systemFontOfSize:20];
	_viewHeading.textColor = [UIColor colorWithRed:0.146 green:0.254 blue:0.326 alpha:1.0];

	[self addSubview:_viewHeading];
	
	[_viewHeading setText:[NSString stringWithFormat:@"%i/%i",pdfController.currentPage,pdfController.totalPages]];
	
	
	[self loadFirstPdfView];
	
	_pdfLoader = [[PdfLoader alloc]initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	[self addSubview:_pdfLoader];
	_pdfLoader.hidden = YES;
    return  TRUE;
}

- (void)changePdfOrientation:(UIInterfaceOrientation)interfaceOrientation{
	
    _mainPDFScrollView.frame = CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT);
	[self pageTurnBelow];
	if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		_viewHeading.frame = CGRectMake(self.frame.size.width-130,-30,60.0,36);
	}
	else {
		_viewHeading.frame = CGRectMake(self.frame.size.width-130,-30,60.0,36);
	}
}

- (void)showLoader
{
	_pdfLoader.hidden = NO;
	[self bringSubviewToFront:_pdfLoader];
}

- (void)hideLoader
{
	_pdfLoader.hidden = YES;
}
- (void)loadFirstPdfView
{
	_mainPDFScrollView = [[PDFReaderScroller alloc]initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	[_mainPDFScrollView setPDFDelegate:self];
	[self addSubview:_mainPDFScrollView];
}


- (void)pdfAnimationDidStop {
	
	[_mainPDFScrollView removeFromSuperview];
//	[_mainPDFScrollView release];
	_mainPDFScrollView = _tempPDFScrollView;
	[_mainPDFScrollView setPDFDelegate:self];
	_tempPDFScrollView = nil;
	_isPageAnimated = NO;
	
	PDFController *pdfController = [PDFController sharedController];
	[_viewHeading setText:[NSString stringWithFormat:@"%i/%i",pdfController.currentPage,pdfController.totalPages]];
	
}

- (IBAction)backBtnClicked
{
	[self removeFromSuperview];
}
	

- (void)pageTurnNext {
	if(_isPageAnimated==YES)
		return;
    
	
	PDFController *pdfCtrlr = [PDFController sharedController];
	if (![pdfCtrlr pageTurnNext]) return;
	
	float translate = 0.0;
    
    _tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, PDF_SCROLLER_HEIGHT, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
    translate = PDF_SCROLLER_HEIGHT;
    
    
    [_tempPDFScrollView setContentOffset:CGPointMake(_tempPDFScrollView.contentOffset.x, 0.0)];
	_isPageAnimated = YES;
    
	[self addSubview:_tempPDFScrollView];
	
	[UIView beginAnimations:@"next page" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
	
    
    _tempPDFScrollView.center = CGPointMake(_tempPDFScrollView.center.x , _tempPDFScrollView.center.y- translate);
    _mainPDFScrollView.center = CGPointMake(_mainPDFScrollView.center.x , _mainPDFScrollView.center.y- translate);
 	[UIView commitAnimations];    
	
}


- (void)pageTurnPrev {    
    if(_isPageAnimated==YES)
        return;
    
    //PDFController *pdfCtrlr = [PDFController sharedController];
    
    PDFController *pdfCtrlr = [PDFController sharedController];
	if (![pdfCtrlr pageTurnPrev]) return;
	
    
    float translate = 0.0;
    
    
    _tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(PDF_SCROLLER_X_OFFSET, -PDF_SCROLLER_HEIGHT+20 , PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
    translate = PDF_SCROLLER_HEIGHT;
    
    [_tempPDFScrollView setContentOffset:CGPointMake(_tempPDFScrollView.contentOffset.x, _tempPDFScrollView.contentSize.height-_tempPDFScrollView.frame.size.height)];
    
    _isPageAnimated = YES;
    [self addSubview:_tempPDFScrollView];
    
    [UIView beginAnimations:@"next page" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
    
    
    _tempPDFScrollView.center = CGPointMake(_tempPDFScrollView.center.x , _tempPDFScrollView.center.y+ translate);
    _mainPDFScrollView.center = CGPointMake(_mainPDFScrollView.center.x , _mainPDFScrollView.center.y+translate);
    
    [UIView commitAnimations];
    
    
}

- (void)pageTurnBelow {
	if(_isPageAnimated)
		return;

		_tempPDFScrollView = [[PDFReaderScroller alloc] initWithFrame:CGRectMake(0.0, PDF_SCROLLER_Y_OFFSET, PDF_SCROLLER_WIDTH, PDF_SCROLLER_HEIGHT)];
	
	
	[_tempPDFScrollView setContentOffset:CGPointMake(_tempPDFScrollView.contentSize.width-_tempPDFScrollView.frame.size.width, _tempPDFScrollView.contentOffset.y)];
	
	_tempPDFScrollView.alpha = 0.0;
	_isPageAnimated = YES;
	[self addSubview:_tempPDFScrollView];
	_tempPDFScrollView.tag = 111;
	[UIView beginAnimations:@"next page" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pdfAnimationDidStop)];
	
	_tempPDFScrollView.alpha = 1.0;
	_mainPDFScrollView.alpha = 0.0;
	[UIView commitAnimations];
}

@end
