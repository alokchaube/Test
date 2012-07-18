//
//  SLServerXMLResponse.m
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import "SLServerXMLResponse.h"

@implementation SLServerXMLResponse
@synthesize publisherInfo;
@synthesize journalInfo;
@synthesize volumeInfo;
@synthesize issueInfo;
@synthesize articleInfo;
@synthesize referencesList;
@end

#pragma mark- Implementation PublicInfo.
@implementation PublisherInfo 

@synthesize publisherName;
@synthesize publisherLocation;
@synthesize publisherURL;

@end

#pragma mark- Implementation JournalInfo.
@implementation JournalInfo

@synthesize journalID;
@synthesize journalPrintISSN;
@synthesize journalElectronicISSN;
@synthesize journalTitle;
@synthesize journalSubTitle;
@synthesize journalAbbreviatedTitle;
@synthesize journalSubjects;

@end

#pragma mark- Implementation VolumeInfo.
@implementation VolumeInfo

@synthesize volumeIDStart;
@synthesize volumeIDEnd;
@synthesize volumeIssueCount;

@end

#pragma mark- Implementation IssueInfo.
@implementation IssueInfo
@synthesize issueIDStart;
@synthesize issueIDEnd;
@synthesize issueArticleCount;
@synthesize onlineDate;
@synthesize printDate;
@synthesize coverDate;
@synthesize pricelistYear;
@synthesize copyrightHolderName;
@synthesize copyrightYear;

@end

#pragma mark- Implementation ArticleInfo.
@implementation ArticleInfo
@synthesize articleID;
@synthesize articleSequenceNumber;
@synthesize articleFirstPage;
@synthesize articleLastPage;

@synthesize registrationDate;
@synthesize receivedDate;
@synthesize accepteddate;
@synthesize onlineDate;

@synthesize copyrightHolderName;
@synthesize copyrightYear;

@synthesize authorsArray;
@synthesize phone,fax,email;
@synthesize orgDivision,orgName,city,postcode,country;
@synthesize abstract;

@end


#pragma mark- Implementation Author.
@implementation Author
@synthesize givenName,familyName;
@end



#pragma mark- Implementation References.
@implementation References

@synthesize citiationNo;
@synthesize year;
@synthesize volumeID;
@synthesize firstPage;

@synthesize journalTitle;
@synthesize doi;
@synthesize coi;
@synthesize authorsStr;

@end
