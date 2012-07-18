//
//  SLVolumeXMLParser.m
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import "SLVolumeXMLParser.h"


@implementation SLVolumeXMLParser
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
    
    currentStringValue = [[NSMutableString alloc] initWithCapacity:20];
    if ([elementName isEqualToString:@"meta:Info"]) {
        return;
    }
    if ([elementName isEqualToString:@"PublisherInfo"]) {
       metadataResponse = [SLVolumeXMLResponse new]; 
    }
//    if ([elementName isEqualToString:@"meta:Volumes"]) {
//        
//    }
    
    if ([elementName isEqualToString:@"meta:Volume"]) {
        objVolume = [VolumeListInfo new];
        objVolume.year = [attributeDict valueForKey:@"year"];
        objVolume.startId = [attributeDict valueForKey:@"startId"];
        objVolume.endId = [attributeDict valueForKey:@"endId"];
    }
    if ([elementName isEqualToString:@"meta:Issue"]) {
        objIssues = [IssuesInfo new];
        objIssues.startId     =[attributeDict valueForKey:@"startId"];
        objIssues.endId       =[attributeDict valueForKey:@"endId"];
        objIssues.startPage   =[attributeDict valueForKey:@"startPage"];
        objIssues.endPage     =[attributeDict valueForKey:@"endPage"];
        //objVolume.currentIssue =objResult;
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
    
    if ([elementName isEqualToString:@"PublisherName"]) {
        if (currentStringValue != nil) {
            metadataResponse.publisherName = currentStringValue;
        }
    }
    
    if ([elementName isEqualToString:@"JournalID"]) {
        if (currentStringValue != nil) {
            metadataResponse.JournalID = currentStringValue;
        }
    }
    if ([elementName isEqualToString:@"JournalTitle"]) {
        if (currentStringValue != nil) {
            metadataResponse.journalName = currentStringValue;
        }
    }
    if ([elementName isEqualToString:@"Editor-in-Chief"]) {
        if (currentStringValue != nil) {
            metadataResponse.Editor_in_Chief = currentStringValue;
        }
    }
    if ([elementName isEqualToString:@"JournalPrintISSN"]) {
        if (currentStringValue != nil) {
            metadataResponse.JournalPrintISSN = currentStringValue;
        }
    }
    if ([elementName isEqualToString:@"JournalElectronicISSN"]) {
        if (currentStringValue != nil) {
            metadataResponse.JournalElectronicISSN = currentStringValue;
        }
    }
    if ([elementName isEqualToString:@"Year"]) {
        if (currentStringValue != nil) {
            [objIssues.year appendString:currentStringValue];
        }
    }
    if ([elementName isEqualToString:@"Month"]) {
        if (currentStringValue != nil) {
            [objIssues.month appendString:currentStringValue];
        }
    }
    
    if ([elementName isEqualToString:@"meta:Issue"]) {
        [objVolume.arrayIssues addObject:objIssues];
        objIssues = nil;
    }
    if ([elementName isEqualToString:@"meta:Volume"]) {
        [metadataResponse.records addObject:objVolume];
        objVolume = nil;
    }

    currentStringValue = nil;	
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
    [_delegate returnVolumeMetadataResponse:metadataResponse] ;
}

@end

