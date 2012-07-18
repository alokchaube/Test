//
//  SLMetadataXMLParser.m
//  SpringerLink
//
//  Created by Alok on 11/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "SLMetadataXMLParser.h"


@implementation SLMetadataXMLParser
@synthesize delegate = _delegate;

/*
 * Method for getting data.
 */
- (void)parseXMLData:(NSData *)data; {
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    
    if (![parser parse]) {
        NSLog(@"Error ocured while parsing: %@", [parser parserError]);
        
    }
}

- (NSDateFormatter*)dateFormatter {
    if (dateFormatter != nil) {
        return dateFormatter;
    }
    
    dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return dateFormatter;
}   

/*
 * Delegate for NSXMLParser XML node start event
 *  @param: elementName -> XML starting tag name
 *  @param: namespaceURI -> XML namespace URI of starting tag Ex: namespaceURI == http://xml.apple.com/cvslog,
 
 *  @param: qName -> XML qualifiedName of starting tag
 *  @param: attributeDict -> XML all attributes of starting tag
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{

    if(isHTMLContent) {
        [currentStringValue appendFormat:@"<%@>",elementName];

    }else {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:20];
    }
    
    if ([elementName isEqualToString:@"result"]) {
        MetadataInfoResult *objResult = [MetadataInfoResult new];
        metadataResponse.currentResult =objResult;
    }
    
    if ([elementName isEqualToString:@"response"]) {
        metadataResponse = [SLXMLResponse new];
    }
    if ([elementName isEqualToString:@"pam:message"]) {
        currentArticle = [Article new] ;
    }
    if ([elementName isEqualToString:@"facet"]) {
        currentFacet = [Facet new] ;
        currentFacet.name = [attributeDict valueForKey:@"name"];
    }
    if ([elementName isEqualToString:@"facet-value"]) {
        NSString* countStr = [attributeDict valueForKey:@"count"];
        if (countStr) {
            currentFacetValueCount = [NSNumber numberWithInt:[countStr intValue]];
        }
    }
    
    if ([elementName isEqualToString:@"xhtml:body"]) {
        isHTMLContent = YES;
    }
}


/*
 * Delegate for NSXMLParser XML node end event
 *  @param: elementName -> XML ending tag name
 *  @param: namespaceURI -> XML namespace URI of ending tag Ex: namespaceURI == http://xml.apple.com/cvslog,
 
 *  @param: qName -> XML qualifiedName of ending tag
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    NSString *tempString = [currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tempString)
        currentStringValue = [[NSMutableString alloc] initWithString:tempString];
    
    if ([elementName isEqualToString:@"query"]) {
        metadataResponse.query = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"total"]) {
        metadataResponse.currentResult.total = [currentStringValue intValue];
    }
    
    if ([elementName isEqualToString:@"start"]) {
        metadataResponse.currentResult.start = [currentStringValue intValue];
    }
    
    if ([elementName isEqualToString:@"pageLength"]) {
        metadataResponse.currentResult.pageLenth = [currentStringValue intValue];
    }
    
    if ([elementName isEqualToString:@"pam:message"]) {
        [metadataResponse.records addObject:currentArticle];
        currentArticle = nil;
    }
    
    if ([elementName isEqualToString:@"dc:identifier"]) {
        currentArticle.identifier = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"dc:title"]) {
        currentArticle.title = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"dc:creator"]) {
        if (currentStringValue) {
            [currentArticle.creators addObject:currentStringValue];
        }
    }
    
    if ([elementName isEqualToString:@"prism:publicationName"]) {
        currentArticle.publicationName = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"printIsbn"]) {
        currentArticle.isbn = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"prism:issn"]) {
        currentArticle.issn = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"journalId"]) {
        currentArticle.journalId = currentStringValue;
    }  
    
    if ([elementName isEqualToString:@"prism:doi"]) {
        currentArticle.doi = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"dc:publisher"]) {
        currentArticle.publisher = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"prism:publicationDate"]) {
        
        if (currentStringValue) {
            currentArticle.publicationDate = [[self dateFormatter] dateFromString:currentStringValue];
        }
    }
    
    if ([elementName isEqualToString:@"prism:url"]) {
        currentArticle.url = currentStringValue;
    }
    if ([elementName isEqualToString:@"prism:copyright"]) {
        currentArticle.copyright = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"prism:volume"]) {
        currentArticle.volume = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"prism:number"]) {
        currentArticle.number = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"prism:startingPage"]) {
        currentArticle.startingPage = currentStringValue;
    }
    
    if ([elementName isEqualToString:@"xhtml:body"]) {
        
        if (currentStringValue != nil) {
            [currentArticle.htmlBody appendString:currentStringValue];
        }        isHTMLContent = NO;
    }
    
    if ([elementName isEqualToString:@"facet"]) {
        
        [metadataResponse.facets addObject:currentFacet];
        currentFacet = nil;
    }
    
    if ([elementName isEqualToString:@"facet-value"]) {
        if (currentStringValue != nil && currentFacetValueCount != nil) {
            [currentFacet.facetCountByName setValue:currentFacetValueCount forKey:currentStringValue];
        }
        currentFacetValueCount = nil;
    }

    if(isHTMLContent) {
        [currentStringValue appendFormat:@"</%@>",elementName];
    }else {
        currentStringValue = nil;	
    }
}


/*
 * Delegate for NSXMLParser XML value event
 * @param: string-> XML node string value Ex:<name>XYZ</name> then return XYZ
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[currentStringValue appendString:string];
}

/*
 * Delegate for NSXMLParser end event
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_delegate returnMetadataResponse:metadataResponse] ;
}

@end
