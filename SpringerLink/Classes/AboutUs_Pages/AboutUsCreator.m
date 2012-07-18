//
//  AboutUsCreator.m
//  SpringerLink
//
//  Created by Prakash on 25/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "AboutUsCreator.h"
#import "Utility.h"
#import "ApplicationConfiguration.h"


#define kArrowImageName @"btn_arrow@2x.png"
#define kVolumeStart 1

#define kCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface AboutUsCreator ()
//private methods-
- (void)copyCSSAndImages;
- (void)copyFileFrom:(NSString *)fromLoc to:(NSString *)toLoc;
- (NSString *)htmlStr;
- (NSString *)bodyStr;
- (NSString *)publishedAndPoweredString;
- (NSString *)restBottomString;

- (NSString *)htmlStringForMasterPage; //only for ipad...
@end


@implementation AboutUsCreator

static AboutUsCreator *_sharedAboutUsCreator=nil;

#pragma mark - public methods
//method to return an object of this class.
+ (AboutUsCreator *)shared
{
    @synchronized(self) {
        if(_sharedAboutUsCreator == nil) 
            _sharedAboutUsCreator = [[AboutUsCreator alloc]init];
    }
    return _sharedAboutUsCreator;
}

/*
 creat a copy of HTML file for about us page to display content of about us.
 the html is saved in folder About inside cache directory with name about.html
 */
- (void)createAboutUsPage {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //creat folder About inside cache dir if not exist.
    if(![filemgr fileExistsAtPath:[kCacheDir stringByAppendingFormat:@"/About"]]) {
        
        if([filemgr createDirectoryAtPath:[kCacheDir stringByAppendingFormat:@"/About"] withIntermediateDirectories:YES attributes:nil error:nil])
            
            NSLog(@"dir created");
    }
    
    [_sharedAboutUsCreator copyCSSAndImages]; //copy CSS
    
    if(isIpad) {
        
        //Creat/Update about.html file (if the file exists then removed and newly created).
        NSString *_htmlPath_Master = [kCacheDir stringByAppendingFormat:@"/About/about_ipad_master.html"];
        NSString *_htmlPath_Detail = [kCacheDir stringByAppendingFormat:@"/About/about_ipad_detail.html"];
        NSError *error;
        
        if([filemgr fileExistsAtPath:_htmlPath_Master]) {
            [filemgr removeItemAtPath:_htmlPath_Master error:&error];
        }
        if([filemgr fileExistsAtPath:_htmlPath_Detail]) {
            [filemgr removeItemAtPath:_htmlPath_Detail error:&error];
        }
        
        //---creating about_ipad_master.html file-----
        if(![filemgr createFileAtPath:_htmlPath_Master contents:[[_sharedAboutUsCreator htmlStringForMasterPage] dataUsingEncoding:NSUTF8StringEncoding] 
                           attributes:nil]) {
            NSLog(@"Error to create html");
        }
        //---creating about_ipad_detail.html file-----
        if(![filemgr createFileAtPath:_htmlPath_Detail contents:[[_sharedAboutUsCreator htmlStr] dataUsingEncoding:NSUTF8StringEncoding] 
                           attributes:nil]) {
            NSLog(@"Error to create html");
        } 
    } else {
        //--Creat/Update about.html file (if the file exists then removed and newly created).
        NSString *htmlPath = [kCacheDir stringByAppendingFormat:@"/About/about.html"];
        NSError *error;
        
        if([filemgr fileExistsAtPath:htmlPath]) {
            [filemgr removeItemAtPath:htmlPath error:&error];
        }
        
        //---creating about.html file-----
        if(![filemgr createFileAtPath:htmlPath 
                             contents:[[_sharedAboutUsCreator htmlStr] dataUsingEncoding:NSUTF8StringEncoding] 
                           attributes:nil]) {
            NSLog(@"Error to create html");
        } 
    }
    
    
}

#pragma mark - private methods

//copy CSS file to cache directory.
- (void)copyCSSAndImages {
    
    NSString *_cssfileName = (isIpad) ?  @"about_ipad.css" : @"about.css";
    
    
    NSString *cssSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_cssfileName];
    
    NSString *cssDestPath = [kCacheDir stringByAppendingString:[NSString stringWithFormat:@"/About/%@",_cssfileName]];
    
    [_sharedAboutUsCreator copyFileFrom:cssSourcePath to:cssDestPath];
    
//    NSString *imgSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kArrowImageName];
//    
//    NSString *imgDestPath = [kCacheDir stringByAppendingString:[NSString stringWithFormat:@"/About/%@",kArrowImageName]];
//    
//    [_sharedAboutUsCreator copyFileFrom:imgSourcePath to:imgDestPath];
}

- (void)copyFileFrom:(NSString *)fromLoc to:(NSString *)toLoc {
    
    NSError *error;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if(![filemgr fileExistsAtPath:toLoc]) {
        
        if([filemgr copyItemAtPath:fromLoc 
                            toPath:toLoc
                             error:&error]) {
            NSLog(@"copied");
        }
    }
}

//creat html string to write an html file.
- (NSString *)htmlStr {
    
    NSMutableString *_htmlStr = [[NSMutableString alloc] initWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\
                                 <html xmlns=\"http://www.w3.org/1999/xhtml\">"];
    
  //NSString *_arrowImageTag = [NSString stringWithFormat:@"<img src='%@'/>",kArrowImageName];
        NSString *_arrowImageTag = [NSString stringWithFormat:@"<img src='%@' height = '6px' width = '7px'/>",[GetResourcePath() stringByAppendingPathComponent:kArrowImageName]];
   
    NSString *_cssfileName = (isIpad) ?  @"about_ipad.css" : @"about.css";
    //creating head string
    NSString *_headStr = [NSString stringWithFormat:@"<head>\
                          <meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />\
                          <link href=\"%@\" type=\"text/css\" rel=\"styleSheet\"/>\
                          <title>Springer</title>\
                          <script type=\"text/javascript\">\
                          function changeText(){\
                          document.getElementById(\"changePara\").innerHTML = \"<p>%@ <a href='#expendLink_open' onClick='javascript:changeText1()'>%@ Hide.</a></p>\";\
                          }\
                          function changeText1(){\
                          document.getElementById(\"changePara\").innerHTML = \"<p>%@ <a href='#expendLink_open' onClick='javascript:changeText()'>%@ Show all.</a></p>\";\
                          }\
                          </script>\
                          </head>",
                          _cssfileName,kFullDescriptiveText,_arrowImageTag,kCollapsedDescriptiveText,_arrowImageTag];
    
    [_htmlStr appendString:_headStr]; //add head string to html.
    [_htmlStr appendString:[self bodyStr]]; //add body string to html.
    return _htmlStr;
}

//return body string of HTML.
- (NSString *)bodyStr {
    
    NSString *_arrowImagePath = [GetResourcePath() stringByAppendingPathComponent:kArrowImageName];
    NSMutableString *_bodyStr = [NSMutableString stringWithFormat:@"<body>\
                                 <p class = \"journalTitle\"> %@</p>\
                                 <div id = 'changePara'><p>%@<a href='#expendLink_open' onClick='javascript:changeText()'> <img src='%@' height = '6px' width = '7px'/> Show all.</a></p></div></body>",kJournalName,kCollapsedDescriptiveText,_arrowImagePath];  
    
    
    NSString *_societyStr = [NSString stringWithFormat:@"<p class = \"journalTitle\">%@ </p>\
                             <p>%@</p>",kSocietyName,kSocietyDescriptiveText];
    
    NSString *_springerText = [NSString stringWithFormat:@"<p class = \"journalTitle\">%@ </p>\
                               <p>%@</p><hr/>",kHeaderSpringerText,kSpringerText];
    
    [_bodyStr appendString:[self publishedAndPoweredString]];
    [_bodyStr appendString:_societyStr];
    [_bodyStr appendString:_springerText];
    
    if(isIpad)
        return _bodyStr;
    
    [_bodyStr appendString:[self restBottomString]];
    
    return _bodyStr;
}

//returning the html format of powered/Published logo section
- (NSString *)publishedAndPoweredString {
    
    NSString *_publishedImagePath = [GetResourcePath() 
                                     stringByAppendingPathComponent:kPublishedImageName];
    
    NSString *_poweredImagePath = [GetResourcePath() 
                                   stringByAppendingPathComponent:kPoweredImageName];
    
    NSString *_poweredSecStr = [NSString stringWithFormat:@" <table class=\"table_format\">\
                                <tr><td align=\"left\" class = \"imageHeader\">Published by</td>\
                                <td align=\"left\" class = \"imageHeader\">Powered by</td>\
                                </tr>\
                                <tr></tr>\
                                <tr>\
                                <td align=\"left\"><img src=\"%@\" width=\"147\" border=\"0\"  /></td>\
                                <td align=\"right\"><img src=\"%@\" width=\"147\" border=\"0\"  /></td>\
                                </tr>\
                                </table>",_publishedImagePath,_poweredImagePath];
    return _poweredSecStr;
}

- (NSString *)htmlStringForMasterPage {
    
    NSMutableString *_htmlStr = [[NSMutableString alloc] initWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\
                                 <html xmlns=\"http://www.w3.org/1999/xhtml\">"];
    
    NSString *_cssfileName = @"about_ipad.css";
    //creating head string
    NSString *_headStr = [NSString stringWithFormat:@"<head>\
                          <meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\" />\
                          <link href=\"%@\" type=\"text/css\" rel=\"styleSheet\"/>\
                          <title>Springer</title>\
                          <body>%@</body></html>",_cssfileName,[self restBottomString]];
    
    [_htmlStr appendString:_headStr];
     return _htmlStr;                     
}

//returns the html format of bottom down text.
- (NSString *)restBottomString {
    
    NSMutableDictionary * metadataDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"volumeMetadata"];
    
    NSString *_dateStr = [metadataDic objectForKey:@"volumeDate"];
    NSArray *words = [_dateStr componentsSeparatedByString:@"-"];
    
    short volumeCount = [[metadataDic objectForKey:@"totalVolume"] intValue];
    NSString *_coverageStr = [NSString stringWithFormat:@"Volume %i /%@ - Volume %i /%@",
                              kVolumeStart,[words objectAtIndex:0],
                              kVolumeStart+volumeCount-1,[words objectAtIndex:0]];
    
    NSString *_strISSN = [NSString stringWithFormat:@"%@ (Print) %@ (Online)",
                          [metadataDic objectForKey:@"journalPrintISSN"],
                          [metadataDic objectForKey:@"journalElectronicISSN"]];
    
    NSString *_publisherStr = [NSString stringWithFormat:[metadataDic objectForKey:@"publisherName"]];
    
    NSString *_restStr = [NSString stringWithFormat:@"\
                          <p><b>Journal Title </b><br/>%@</p><hr/>\
                          <p><b>Coverage</b><br/>%@</p> <hr/>\
                          <p><b>ISSN</b><br/>%@</p><hr/>\
                          <p><b>Publisher </b><br/>%@</p> <hr/>\
                          <p><b>Society Webpage</b><br/><A HREF=\"http://%@\">%@</A></p><hr/>\
                          </body></html>",kJournalName,_coverageStr,_strISSN,_publisherStr,
                          kAboutLink,kAboutLink];
    return _restStr;
}

@end
