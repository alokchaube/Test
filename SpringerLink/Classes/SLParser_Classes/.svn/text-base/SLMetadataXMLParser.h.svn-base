//
//  SLMetadataXMLParser.h
//  SpringerLink
//
//  Created by Alok on 11/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "SLXMLResponse.h"

@protocol SLMetadataXMLParserDelegate
-(void)returnMetadataResponse:(SLXMLResponse*)metadataResponse;
@end

/**
 * This is the XML parsing class in which parse the XML data using NSXMLParser.
 * This class contain a protocol SLMetadataXMLParserDelegate in which one delegate method returnMetadataResponse, in which pass the object of SLXMLResponse as a parameter.
 */

@interface SLMetadataXMLParser : NSObject<NSXMLParserDelegate> {
    
    NSMutableString*    currentStringValue;
    Article*            currentArticle;
    Facet*              currentFacet;
    
    NSNumber*           currentFacetValueCount;
    SLXMLResponse*      metadataResponse;
    NSDateFormatter*    dateFormatter;
    BOOL                isHTMLContent;
    
}
@property (strong, nonatomic) id <SLMetadataXMLParserDelegate>	delegate;
/*
 * Method for start the parsing of xml data passed by owner class.   
 */
- (void)parseXMLData:(NSData *)data;
@end
