//
//  SLVolumeXMLParser.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "SLVolumeXMLResponse.h"

@protocol SLVolumeXMLResponseDelegate
-(void)returnVolumeMetadataResponse:(SLVolumeXMLResponse*)metadataResponse;
@end

/**
 * This is the XML parsing class in which parse the XML data using NSXMLParser.
 * This class contain a protocol SLVolumeXMLResponseDelegate in which one delegate method returnVolumeMetadataResponse, in which pass the object of SLVolumeXMLResponse as a parameter.
 */

@interface SLVolumeXMLParser : NSObject<NSXMLParserDelegate> {
    
    NSMutableString*          currentStringValue;
    SLVolumeXMLResponse*      metadataResponse;
    IssuesInfo*                objIssues;
    VolumeListInfo*                objVolume;
    
}
@property (strong, nonatomic) id <SLVolumeXMLResponseDelegate>	delegate;
/*
 * Method for start the parsing of xml data passed by owner class.   
 */
- (void)parseXMLData:(NSData *)data;
@end
