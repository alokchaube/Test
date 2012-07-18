//
//  ArticleDetailView.m
//  SpringerLink
//
//  Created by prakash raj on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArticleDetailView.h"
#import "SLXMLResponse.h"
#import "ProtocolDecleration.h"

#import "Utility.h"
#import "ApplicationConfiguration.h"

#import "DetectNetworkConnection.h"
#import "SLArticleDataXMLParser.h"
#import "SLServerXMLResponse.h"

//db
#import "DBManager.h"
#import "PDFDownloadInfo.h"
#import "DBArticle.h"
#import "DBReferences.h"

#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kAuthorsShortLength 30
#define kAuthorsShortLength_ipad 50
#define kArrowImageName @"btn_arrow@2x.png"
#define kArticleFolderName @"Articles-Html"


@interface ArticleDetailView ()

- (void)loadWebViewData;
- (void)creatCompleteHTMLStr;
- (NSString *)javascriptShowHideMethodString;
- (NSString *)javascriptToChangeCoverimageAndCSS;
- (NSString *)htmlTableString;
- (void)addString:(NSString *)str 
      andCSSClass:(NSString *)cssClass;
- (NSString *)titleForStatus:(NSInteger)st;
- (void)creatHTMLFile;
- (void)saveReferenceToDB:(References *)ref;
- (void)resultWithDoi:(NSString *)doi;
- (void)getImageFromServer;
@end


@implementation ArticleDetailView
@synthesize delegate = _delegate;
@synthesize webView = _webView;

short currentCss;                //current css file number 1,2,3.
short currentStatus;             //current status speciely for download Button.
BOOL _isLoadFirst;               //yes/No - loading first time/Not.
BOOL _shouldRefPickFromDB;       //(YES) if references are added to DB

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        [_webView setDelegate:self];
        [self addSubview:_webView];
    }
    return self;
}

- (void)dealloc {
    _webView = nil;
    _loader = nil;
}

#pragma mark - public methods
//method to restrict hit service for ref.
- (void)stopLoading {
    if(_slServerDataFetcher != nil)
        [_slServerDataFetcher stopFetching];

}
/*
 * method to show article.
 * @param : article - specify atricle which is to be shown.
 */
- (void)showArticle:(Article *)article {
    _isLoadFirst = YES;
    currentCss = 1;
    currentStatus = [[DBManager sharedDBManager] statusForArticalDoi:_currentArticle.doi];
    _currentArticle = article;
    _shouldRefPickFromDB = [[DBManager sharedDBManager]isDoi:_currentArticle.doi existInTable:@"ReferenceTable"];
    
    if(_shouldRefPickFromDB) {
        
        _referencesArray = [[DBManager sharedDBManager]referencesWithArtDoi:_currentArticle.doi];
        [self loadWebViewData];
    } else {
        
        [self resultWithDoi:_currentArticle.doi];
    }
}

/*
 * method to set status of Download.
 * which will change the title and animation on download button
 * @param : st - status to be set.
 */
- (void)setStatus:(NSInteger)st {
    
    if(currentStatus == st)
        return;
    
    NSString *preTitle = [self titleForStatus:currentStatus];
    NSString *postTitle = [self titleForStatus:st];
    
    NSString* requestString = [_displayStr stringByReplacingOccurrencesOfString:preTitle 
                                                            withString:postTitle];
    if(st == PDFNotDownloaded  || st == 0) {
        
        requestString = [requestString stringByReplacingOccurrencesOfString:@"btn_download_blank.png" withString:@"btn_download.png"];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"onLoad=\"init()\"" withString:@"onLoad=\"stop()\""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"class=\"normal-button-opaque\"" withString:@"class=\"normal-button\""];
        
    } else  if(st == PDFHasDownloaded) {
        
        requestString = [requestString stringByReplacingOccurrencesOfString:@"btn_download_blank.png" withString:@"btn_readarticle.png"];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"onLoad=\"init()\"" withString:@"onLoad=\"stop()\""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"class=\"normal-button-opaque\"" withString:@"class=\"normal-button\""];
    } else {
        
        requestString = [requestString stringByReplacingOccurrencesOfString:@"btn_download.png" withString:@"btn_download_blank.png"];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"onLoad=\"stop()\"" withString:@"onLoad=\"init()\""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"class=\"normal-button\"" withString:@"class=\"normal-button-opaque\""];
    }
    
    _displayStr = [requestString mutableCopy];
    [self creatHTMLFile];//overwride html
    [_webView reload];
    currentStatus = st;
}

/* 
 * method to change CSS file (+/- font size).
 * @param : cssNum - specify CSS number.
 */
- (void)uploadCssNumber:(short)cssNum {
    
    NSString *cssName = (isIpad) ? @"ipad_style" : @"style";
    NSString *function = [NSString stringWithFormat:@"changeCSS('%@%i.css')",cssName,cssNum];
    [_webView stringByEvaluatingJavaScriptFromString:function];
}

/*
 * method to search text within article.
 * @param : searchText - text to search within article.
 */
- (short)searchText:(NSString *)searchText {
    // The JS File   
    NSString *filePath = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"]]; 
   
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",searchText];
    [_webView stringByEvaluatingJavaScriptFromString:startSearch];
    
    // Search Occurence Count
    // uiWebview_SearchResultCount - is a javascript var
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    NSLog(@"%@",result);
    return [result integerValue];
}

//method to clear search text within article.
- (void)clearInnerSearch {
     [_webView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

/* 
 * method to change selected text in search within texts. 
 * (jump to next/previous text within search within article).
 * @param : index - current index.
 * @param : prevIndex - previous index.
 */
- (void)makeSelectionAtText:(short)index
       andUnselectPrevIndex:(short)prevIndex {
    
    NSString *jsMethodName = [NSString stringWithFormat:@"changeColorOfCurrentHighlighetedSpan('uiWebviewHighlight_%i','uiWebviewHighlight_%i')",index,prevIndex];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodName];
    
    jsMethodName = [NSString stringWithFormat:@"document.getElementById('uiWebviewHighlight_%i').scrollIntoView()",index];
    [_webView stringByEvaluatingJavaScriptFromString:jsMethodName];
}

#pragma mark - private methods

//method to creat/load html file to webView.
- (void)loadWebViewData {
    
    currentCss = 1;
    currentStatus = [[DBManager sharedDBManager] statusForArticalDoi:_currentArticle.doi];
    
    _issueId = (_shouldRefPickFromDB) ? [[_referencesArray objectAtIndex:0]issueId] :
    _currentResponse.issueInfo.issueIDStart;
    
    //NSLog(@"see doi: %@",currentArticle.doi);
    [self creatCompleteHTMLStr]; //creat HTML string (_displayStr)
    [self creatHTMLFile]; //creat HTML file in cache dir
    
    NSURL *url = [NSURL URLWithString:[[kCacheDir stringByAppendingFormat:@"/%@/abc.html",kArticleFolderName]stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    if(!_shouldRefPickFromDB)
        [self performSelector:@selector(getImageFromServer)];
}

//method to creat complete html string.
- (void)creatCompleteHTMLStr {
    
    NSString *btnPath = nil, *functionName = nil, *buttonClass = nil;
    
    if(currentStatus == PDFNotDownloaded || currentStatus == 0) {
        
        btnPath = [GetResourcePath() 
                   stringByAppendingPathComponent:@"btn_download.png"];
        functionName = @"stop()";
        buttonClass = @"normal-button";
        
    } else if(currentStatus == PDFHasDownloaded) { 
        
        btnPath = [GetResourcePath() 
                   stringByAppendingPathComponent:@"btn_readarticle.png"];
        functionName = @"stop()";
        buttonClass = @"normal-button";
        
    } else {
        
        btnPath = [GetResourcePath() 
                   stringByAppendingPathComponent:@"btn_download_blank.png"];
        functionName = @"init()";
        buttonClass = @"normal-button-opaque";
    }
    
    NSString *loaderImagePath = [GetResourcePath() stringByAppendingPathComponent:@"loading.gif"];
    
    NSString *btnStyleStr = [NSString stringWithFormat:@"<style type=\"text/css\"> .ovalbutton { background: transparent url('%@') no-repeat top left;display: block;float: left; font: normal 10px Tahoma; line-height: 44px; height: 44px; width: 300px; padding-left: 0px; text-decoration: none;} .buttonwrapper { overflow: hidden; width: 300px; height: 44px;}</style>",btnPath];
    
    Article *record = _currentArticle;
    currentStatus = [[[DBManager sharedDBManager]PDFWithDoi:record.doi] downloadStatus];
    
    NSString *_arrowImageTag;
    NSString *_showAllFunctionStr;
    
    short shortTextLength = (isIpad) ? kAuthorsShortLength_ipad : kAuthorsShortLength;
    if((record.allAuthors.length > shortTextLength)) {
        
        _arrowImageTag = [NSString stringWithFormat:@"<img src='%@' height = '6px' width = '7px'/>",[GetResourcePath() stringByAppendingPathComponent:kArrowImageName]];
        
        NSRange r = NSMakeRange(0, shortTextLength);
        
        _showAllFunctionStr = [NSString stringWithFormat:@"function showAllAuthors(){\
                               document.getElementById(\"AuthorsPara\").innerHTML = \" %@.<a href='#expendLink_open' onClick='javascript:hideAllAuthors()'>%@Hide.</a>\";\
                               }\
                               function hideAllAuthors(){\
                               document.getElementById(\"AuthorsPara\").innerHTML = \"%@...<a href='#expendLink_open' onClick='javascript:showAllAuthors()'>%@View all.</a>\";\
                               }",record.allAuthors,_arrowImageTag,[record.allAuthors substringWithRange:r],_arrowImageTag];
    } else {
        
        _showAllFunctionStr = @"";
    }
    
    
    NSString* javaScript = [NSString stringWithFormat:@"<script type=\"text/javascript\"> \
                            var preOpenedDivId = \"\";\
                            var preOpenedBtnId = \"\";\
                            var ld=(document.all);\
                            var ns4=document.layers;\
                            var ns6=document.getElementById&&!document.all;\
                            var ie4=document.all;\
                            if (ns4)\
                            ld=document.loading;\
                            else if (ns6)\
                            ld=document.getElementById(\"loading\").style;\
                            else if (ie4)\
                            ld=document.all.loading.style;\
                            function init()\
                            {\
                            ld=document.getElementById(\"loading\").style;\
                            ld.visibility=\"show\";\
                            }\
                            \
                            function stop()\
                            {\
                            ld=document.getElementById(\"loading\").style;\
                            ld.visibility=\"hidden\";\
                            }\
                            %@\
                            %@\
                            %@\
                            </script>",
                            _showAllFunctionStr,
                            [self javascriptShowHideMethodString],
                            [self javascriptToChangeCoverimageAndCSS]];
    
    NSString* loaderBody = [NSString stringWithFormat:@"<div id=\"loading\"  style=\"position:absolute; width:100%; text-align:left;margin-left:1.3em;margin-top:0.9em;opacity:0.4;\"><img src=\"%@\" border=0></div>",loaderImagePath];
    
    NSString *_cssFileName = (isIpad) ? @"ipad_style" : @"style";
    
    _displayStr = [[NSMutableString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"de\"><head><title>title</title><link href=\"%@%i.css\" id=\"CSSID\" type=\"text/css\" rel=\"styleSheet\"/>%@</head>%@<body onLoad=\"%@\">",_cssFileName,currentCss,javaScript,btnStyleStr,functionName];
    //
    if (isIpad) {

        NSString *_journalImageTagStr;
        NSString *_imagePath = [NSString stringWithFormat:@"%@/%@/%@_%@_%i.jpg",kCacheDir,kArticleFolderName,kJournalID,_currentArticle.volume,_issueId];
        
        if(_shouldRefPickFromDB) {
            _journalImageTagStr = [NSString stringWithFormat:@"<img id = \"thumbImage\" class = \"thumb_image\" src='%@' />",_imagePath]; 
            
        } else {
            _journalImageTagStr = [NSString stringWithFormat:@"<img id = \"thumbImage\" class = \"thumb_image\" src='%@' />",[GetResourcePath() stringByAppendingPathComponent:@"cover_blank_ipad.png"]]; 
        }
        
        [_displayStr appendString:_journalImageTagStr];
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *mnthStr = [formatter stringFromDate:record.publicationDate];
    [formatter setDateFormat:@"yyyy"];
    NSString *yrStr = [formatter stringFromDate:record.publicationDate];
    NSString *tempStr;
    
    if (record.volume==nil || [record.volume isEqualToString:@""]) {
        
        tempStr = [NSString stringWithFormat:@"Published online %@ %@",mnthStr,yrStr]; 
    } else {
        tempStr = [NSString stringWithFormat:@"%@ %@, Volume %@, Issue %i, pp %@",
                   mnthStr,yrStr,record.volume,_issueId,
                   record.startingPage];  
    }
    
    
    [self addString:tempStr andCSSClass:@"vol"];
    [self addString:record.title andCSSClass:@"article-title"];
    
    int authershortLength = (isIpad) ? kAuthorsShortLength_ipad : kAuthorsShortLength;
    if(record.allAuthors.length > authershortLength + 10)
    {
        
        NSRange r = NSMakeRange(0, authershortLength);
        NSString *_sortAutors = [record.allAuthors substringWithRange:r];
        
        NSString *sortAuthorsStr = [NSString stringWithFormat:@"<p id = 'AuthorsPara' class = \"authors_para\"> %@...<a href='#expendLink_open' onClick='javascript:showAllAuthors()'>%@View all.</a></p>",_sortAutors,_arrowImageTag];
        
        [_displayStr appendString:sortAuthorsStr];
        
    } else {
        
        [self addString:record.allAuthors andCSSClass:@"authors_para"];
    }
    
    
    //adding button here..
    [_displayStr appendFormat:@"<div class=\"buttonwrapper\"><a class=\"ovalbutton\" href=\"downloadBtnClicked\"><span class=\"%@\">%@</span></a>%@</div>",buttonClass,[self titleForStatus:currentStatus],loaderBody];
    
    if([record.htmlBody length]) {
        [_displayStr appendFormat:@"<div class=\"abstract-text\">%@</div>",record.htmlBody];
    } else {
        [_displayStr appendFormat:@"<p class=\"div_gap\"></p>"];
    }
    
    [_displayStr appendString:[self htmlTableString]];
    
    if(isIphone){
           [_displayStr appendFormat:@"<br /><br />"];
    }
     
    [_displayStr appendFormat:@"</body></html>"];
}

//method to get string for javascript method to show/hide div.
- (NSString *)javascriptShowHideMethodString {
    
    NSString *_closeImagename = nil;
    NSString *_openImagename = nil;
    _closeImagename = (isIpad) ? @"bar_close_iPad.png" : @"bar_close.png";
    _openImagename = (isIpad) ? @"bar_open_iPad.png" : @"bar_open.png";
    
    
    return [NSString stringWithFormat:@"\
            function toggle_visibility(id,btnID) {\
            var e = document.getElementById(id);\
            if(e.style.display == 'block') {\
            e.style.display = 'none';\
            document.getElementById(btnID).style.backgroundImage=\"url('%@')\";\
            preOpenedDivId = \"\";\
            preOpenedBtnId = \"\";\
            } else {\
            if(document.getElementById(preOpenedDivId)){\
            document.getElementById(preOpenedDivId).style.display = 'none';\
            document.getElementById(preOpenedBtnId).style.backgroundImage=\"url('%@')\";\
            }\
            e.style.display = 'block';\
            document.getElementById(btnID).style.backgroundImage=\"url('%@')\";\
            preOpenedDivId = id;\
            preOpenedBtnId = btnID;\
            }\
            }",
            [GetResourcePath() stringByAppendingPathComponent:_closeImagename],
            [GetResourcePath() stringByAppendingPathComponent:_closeImagename],
            [GetResourcePath() stringByAppendingPathComponent:_openImagename]];
}

//method to get string for javascript method to change cover image and css file.
- (NSString *)javascriptToChangeCoverimageAndCSS {
    
    return @"function changeImage(imagePath) {\
    document.getElementById(\"thumbImage\").src = imagePath;\
    }\
    function changeCSS(cssFileName) {\
    var quoteElement = document.getElementById(\"CSSID\");\
    quoteElement.href = cssFileName;\
    }";
}

//method to get html string for table at buttom.
- (NSString *)htmlTableString {

    //rowNo,rowNo,imagepath,rowNo,rowNo,buttonTitle,rowNo,contentWithinRow,
    NSString *_butttonStrOn = @"\
    <button id=\"button%i\" name=\"button%i\" class = \"bottom_button\" style=\"background-image: url('%@');\" onclick=\"toggle_visibility('foo%i','button%i');\">\
    <p class = \"btn_title_on\">%@</p>\
    </button> \
    <div class = \"reference_div\" style=\"display:%@;\" id=\"foo%i\">\
    %@\
    </div>";
    
    //imagepath,buttonTitle.
   // NSString *_butttonStrOff = @"<button id=\"button\" name=\"button\" class =\"bottom_button\" style=\"background-image: url('%@');\" onclick=\"toggle_visibility('foo','button');\"><p class = \"btn_title_off\">%@</p></button>";
    
    
    NSString *_imagename = nil;
    _imagename = (isIpad) ? @"bar_close_iPad.png" : @"bar_close.png";
    
    //  NSString *_btnPathOn = [GetResourcePath() stringByAppendingPathComponent:_imagename];
   // NSString *_btnPathOff = [GetResourcePath() stringByAppendingPathComponent:@"bar_close_off.png"];
    _imagename = (isIpad) ? @"bar_open_iPad.png" : @"bar_open.png";
    NSString *_btnPathOpen = [GetResourcePath() stringByAppendingPathComponent:_imagename];
    
    int _rowNo = 1;
    NSMutableString *_tableString = [[NSMutableString alloc] init];
    
    /*
     //------within this article----
     NSString *_withinArticleRowStr = [NSString stringWithFormat:_butttonStrOn,_rowNo,_rowNo,_btnPathOn,_rowNo,_rowNo,@"Within this article",@"none",_rowNo,@"Within this article demo"];
     [_tableString appendString:_withinArticleRowStr];
     
     
     //----related------//off
     NSString *_relatedRowStr = [NSString stringWithFormat:_butttonStrOff,_btnPathOff,
     @"Related (0)"];
     [_tableString appendString:_relatedRowStr];
     
     //----supplementary Material------//off
     NSString *_supplementaryRowStr = [NSString stringWithFormat:_butttonStrOff,_btnPathOff,
     @"supplementary Material (0)"];
     [_tableString appendString:_supplementaryRowStr];
     */
    
    //----references------
    
//    if(!_shouldRefPickFromDB) {
//        _referencesArray = _currentResponse.referencesList;
//    } 
    
    NSString *_referenceRowStr;
    if([_referencesArray count]) {
        
        NSMutableString *_referenceText = [[NSMutableString alloc] init];
        NSString *_arrowImageTag = [NSString stringWithFormat:@"<img src='%@' height = '6px' width = '7px'/>",[GetResourcePath() stringByAppendingPathComponent:kArrowImageName]];
        short count = 0;
        
        if(_shouldRefPickFromDB) {
            
            count = 0;
            
            for(DBReferences *ref in _referencesArray) {
                //|| ![ref.doi isEqualToString:@"(null)"]
                if(ref.doi != NULL && ![ref.doi isEqualToString:@"NO DOI"]) {
                    NSLog(@"Doi:%@",ref.doi);
                    [_referenceText appendFormat:@"<p>%i.<div class = \"references_in_div\">%@ <a href='CrossRef-%i' >%@CrossRef</a></div></p>",ref.citiationNo,ref.authorsStr,count,_arrowImageTag];
                } else {
                    [_referenceText appendFormat:@"<p>%i.<div class = \"references_in_div\">%@</div></p>",ref.citiationNo,ref.authorsStr,count]; 
                }
                count ++;
            }
        } else {
            
            count = 0;
            for(References *ref in _referencesArray) {
                if(ref.doi != nil) {
                    [_referenceText appendFormat:@"<p>%i.<div class = \"references_in_div\">%@ <a href='CrossRef-%i' >%@CrossRef</a></div></p>",ref.citiationNo,ref.authorsStr,count,_arrowImageTag];
                } else {
                   [_referenceText appendFormat:@"<p>%i.<div class = \"references_in_div\">%@</div></p>",ref.citiationNo,ref.authorsStr,count]; 
                }
                [self saveReferenceToDB:ref];
                count ++;
            }
        }
    
        _rowNo++;
        _referenceRowStr = [NSString stringWithFormat:_butttonStrOn,_rowNo,_rowNo,_btnPathOpen,_rowNo,_rowNo,[NSString stringWithFormat:@"References (%i)",_referencesArray.count],@"block",_rowNo,_referenceText];
        //@"none",_btnPathOn
        
    } else {
        
        //--off--
        _referenceRowStr = @"";
       // _referenceRowStr = [NSString stringWithFormat:_butttonStrOff,_btnPathOff,@"References (0)"];
    }
    
    [_tableString appendString:_referenceRowStr];
    
    /*
     //------about article--------
     _rowNo++;
     NSString *_aboutArticleRowStr = [NSString stringWithFormat:_butttonStrOn,_rowNo,_rowNo,_btnPathOn,_rowNo,_rowNo,@"About this article",@"none",_rowNo,@"About this article demo"];
     [_tableString appendString:_aboutArticleRowStr];
     */
    
    return _tableString;
}

/*
 * method to add string to complete string with CSS class name.
 * @param : str - string within the tag <p>
 * @param : cssClass - Css class name
*/
- (void)addString:(NSString *)str 
      andCSSClass:(NSString *)cssClass {
    [_displayStr appendFormat:@"<p class=\"%@\"> %@</p>",cssClass,str];
}

/*
 * method to get title for status.
 * @param : st - pass status to get title.
*/
- (NSString *)titleForStatus:(NSInteger)st {
   
    if(st == 2)
        return @"Download in progress";
    if(st == 3)
        return @"Read this Article";
    return @"Download PDF";
}

//Method to create HTML file with  _displayStr.
- (void)creatHTMLFile {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *htmlPath = [kCacheDir stringByAppendingFormat:@"/%@/abc.html",kArticleFolderName];
    NSError *error;
    
    if([filemgr fileExistsAtPath:htmlPath]) {
        [filemgr removeItemAtPath:htmlPath error:&error];
    }
    
    if(![filemgr createFileAtPath:[kCacheDir stringByAppendingFormat:@"/%@/abc.html",kArticleFolderName] 
                         contents:[_displayStr dataUsingEncoding:NSUTF8StringEncoding] 
                       attributes:nil]) {
        NSLog(@"Error to create html");
    } 
}

/*
 * method to save reference to database.
 * @param : ref - reference to save.
*/
- (void)saveReferenceToDB:(References *)ref {
    
    DBReferences *_dbReference = [[DBReferences alloc] init];
    
    _dbReference.citiationNo = ref.citiationNo;
    _dbReference.year = ref.year;
    _dbReference.volumeID = ref.volumeID;
    _dbReference.firstPage = ref.firstPage;
    
    _dbReference.journalTitle = ref.journalTitle;
    _dbReference.doi = ref.doi;
    _dbReference.coi = ref.coi;
    _dbReference.authorsStr = ref.authorsStr;
    
    _dbReference.issueId = _currentResponse.issueInfo.issueIDStart;
    _dbReference.artDoi = _currentArticle.doi;
    
    [[DBManager sharedDBManager] saveReference:_dbReference];
}

//method to download image from searver
- (void)getImageFromServer {
    
    NSMutableString *_urlStr = [NSMutableString stringWithFormat:@"http://coverimages.cmgsites.com/journal/%@",kJournalID];
    if(_currentArticle.volume != nil && [_currentArticle.volume length]) {
        [_urlStr appendFormat:@"_%@",_currentArticle.volume];
    }
    
    if(_issueId) {
        [_urlStr appendFormat:@"_%i",_issueId];
    }
    
    [_urlStr appendFormat:@".jpg"];
    
    NSLog(@"%@",_urlStr);
    NSData *_imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlStr]];
    
    NSString *_imagePath = [NSString stringWithFormat:@"%@/%@/%@_%@_%i.jpg",kCacheDir,kArticleFolderName,kJournalID,_currentArticle.volume,_issueId];
    [_imageData writeToFile:_imagePath atomically:YES];
}

/*
 * method to find more information sof article.
 * @param : doi- we need to pass doi of article to get more information about that.
 */
- (void)resultWithDoi:(NSString *)doi
{
    if(![DetectNetworkConnection isNetworkConnectionActive]) {
        
        showAlert(NetworkErrorMessage); //do code for offline case...
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"http://api.springer.com/xmldata/app?q=doi:%@&api_Key=%@",doi,kAPIKey1];
    NSLog(@"%@",query);
    
    if(_slServerDataFetcher == nil)
        _slServerDataFetcher = [[SLServerDataFetcher alloc] init];
    [_slServerDataFetcher fetchDataWithQuery:query];
    [_slServerDataFetcher setDelegate:self];
    
     //add loader.......
    if([_delegate respondsToSelector:@selector(addLoader:)]){
        [_delegate addLoader:YES];
    }
   
}

#pragma mark - SLServerDataFetcher delegate

- (void)requestFailedWithError {
    //--------we can add code for offline mode here.....
}
- (void)requestFinishedWithData:(NSData *)data {
    SLArticleDataXMLParser *_xmlParser = [[SLArticleDataXMLParser alloc] init];
    _xmlParser.delegate = self;
    [_xmlParser parseData:data];
}

#pragma mark - SLArticleDataXMLParser delegate

- (void)didRecieveResponse:(SLServerXMLResponse *)SLResponse {
    _currentResponse = SLResponse;
    _referencesArray = _currentResponse.referencesList;
    [self loadWebViewData];
}


#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSArray *urlCoponents = [[request.URL absoluteString] componentsSeparatedByString:@"/"];
        NSLog(@"%@",[urlCoponents lastObject]);
        
        if ([[urlCoponents lastObject] isEqualToString:@"downloadBtnClicked"]) {
            
            //NSLog(@"downloadBtnClicked...");
            if([_delegate respondsToSelector:@selector(downloadBtnClicked)]){
                 [self.delegate downloadBtnClicked];
            }
           
        } else if([[urlCoponents lastObject] rangeOfString:@"CrossRef"].location 
                  != NSNotFound )  {
            
            short _refNumber = [[[urlCoponents lastObject] stringByReplacingOccurrencesOfString:@"CrossRef-" withString:@""] intValue];
            
            NSString *_thisDOI = [[_referencesArray objectAtIndex:_refNumber] doi];
            NSString *_linkUrl = [NSString stringWithFormat:@"http://dx.doi.org/%@",_thisDOI];
            NSLog(@"CrossRef clicked...%i %@",_refNumber,_linkUrl);
            
            if([_delegate respondsToSelector:@selector(openRefLink:)])
                [_delegate openRefLink:_linkUrl];
        }
        
        return NO;
    }
    return YES;
}


-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
    if (_isLoadFirst) {
        _isLoadFirst = NO;
        if([_delegate respondsToSelector:@selector(addLoader:)]){
            [_delegate addLoader:NO];
        }
    }
    
    if(! _shouldRefPickFromDB) {
        NSString *_imagePath = [NSString stringWithFormat:@"%@/%@/%@_%@_%i.jpg",kCacheDir,kArticleFolderName,kJournalID,_currentArticle.volume,_issueId];
        NSString *_eveStr = [NSString stringWithFormat:@"changeImage(\"%@\")",_imagePath];
        [_webView stringByEvaluatingJavaScriptFromString:_eveStr];
    }
}
@end
