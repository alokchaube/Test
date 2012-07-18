//
//  SLServerXMLResponse.h
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PublisherInfo;
@class JournalInfo;
@class VolumeInfo;
@class IssueInfo;
@class ArticleInfo;

@interface SLServerXMLResponse : NSObject {
@public
    PublisherInfo *publisherInfo;
    JournalInfo   *journalInfo;
    VolumeInfo    *volumeInfo;
    IssueInfo     *issueInfo;
    ArticleInfo   *articleInfo;
    NSArray       *referencesList;
}

@property (nonatomic, retain) PublisherInfo *publisherInfo;
@property (nonatomic, retain) JournalInfo   *journalInfo;
@property (nonatomic, retain) VolumeInfo    *volumeInfo;
@property (nonatomic, retain) IssueInfo     *issueInfo;
@property (nonatomic, retain) ArticleInfo   *articleInfo;
@property (nonatomic, retain) NSArray       *referencesList;

@end


#pragma mark- Interface PublicInfo.
@interface PublisherInfo : NSObject {
@public
    NSString *publisherName;
    NSString *publisherLocation;
    NSString *publisherURL;
}

@property (nonatomic, copy) NSString *publisherName;
@property (nonatomic, copy) NSString *publisherLocation;
@property (nonatomic, copy) NSString *publisherURL;
@end


#pragma mark- Interface JournalInfo.
@interface JournalInfo : NSObject {
@public
    NSString  *journalID;
    NSString  *journalPrintISSN;
    NSString  *journalElectronicISSN;
    NSString  *journalTitle;
    NSString  *journalSubTitle;
    NSString  *journalAbbreviatedTitle;
    NSArray   *journalSubjects;
    
}

@property (nonatomic, copy)  NSString  *journalID;
@property (nonatomic, copy)  NSString  *journalPrintISSN;
@property (nonatomic, copy)  NSString  *journalElectronicISSN;
@property (nonatomic, copy)  NSString  *journalTitle;
@property (nonatomic, copy)  NSString  *journalSubTitle;
@property (nonatomic, copy)  NSString  *journalAbbreviatedTitle;
@property (nonatomic, retain) NSArray  *journalSubjects;
@end


#pragma mark- Interface VolumeInfo.
@interface VolumeInfo : NSObject {
@public
    short volumeIDStart;
    short volumeIDEnd;
    short volumeIssueCount;
}

@property (nonatomic, assign)  short volumeIDStart;
@property (nonatomic, assign)  short volumeIDEnd;
@property (nonatomic, assign)  short volumeIssueCount;
@end


#pragma mark- Interface IssueInfo.
@interface IssueInfo : NSObject {
@public
    short issueIDStart;
    short issueIDEnd;
    short issueArticleCount;
    NSDate    *onlineDate;
    NSDate    *printDate;
    NSDate    *coverDate;
    short pricelistYear;
    NSString  *copyrightHolderName;
    short copyrightYear;
    
}
@property (nonatomic, assign) short  issueIDStart;
@property (nonatomic, assign) short  issueIDEnd;
@property (nonatomic, assign) short  issueArticleCount;
@property (nonatomic, retain) NSDate     *onlineDate;
@property (nonatomic, retain) NSDate     *printDate;
@property (nonatomic, retain) NSDate     *coverDate;
@property (nonatomic, assign) short  pricelistYear;
@property (nonatomic, copy)   NSString   *copyrightHolderName;
@property (nonatomic, assign) short  copyrightYear;

@end

#pragma mark- Interface ArticleInfo.
@class Author;
@interface ArticleInfo : NSObject {
    @public
    short  articleID;
    //ArticleDOI
    short  articleSequenceNumber;
    //ArticleTitle
    short  articleFirstPage;
    short  articleLastPage;
    
    NSDate     *registrationDate;
    NSDate     *receivedDate;
    NSDate     *accepteddate;
    NSDate     *onlineDate;
    
    NSString   *copyrightHolderName;
    short  copyrightYear;
    
    NSArray    *authorsArray;
    
    NSString  *phone;
    NSString  *fax;
    NSString  *email;
    
    NSString  *orgDivision;
    NSString  *orgName;
    NSString  *city;
    NSString  *postcode;
    NSString  *country;
    
    NSString  *abstract;
}

@property (nonatomic ,assign) short  articleID;
@property (nonatomic ,assign) short  articleSequenceNumber;
@property (nonatomic ,assign) short  articleFirstPage;
@property (nonatomic ,assign) short  articleLastPage;

@property (nonatomic ,retain) NSDate     *registrationDate;
@property (nonatomic ,retain) NSDate     *receivedDate;
@property (nonatomic ,retain) NSDate     *accepteddate;
@property (nonatomic ,retain) NSDate     *onlineDate;

@property (nonatomic ,copy)   NSString   *copyrightHolderName;
@property (nonatomic ,assign) short  copyrightYear;

@property (nonatomic ,retain) NSArray    *authorsArray;

@property (nonatomic ,copy)   NSString   *phone;
@property (nonatomic ,copy)   NSString   *fax;
@property (nonatomic ,copy)   NSString   *email;

@property (nonatomic ,copy)   NSString   *orgDivision;
@property (nonatomic ,copy)   NSString   *orgName;
@property (nonatomic ,copy)   NSString   *city;
@property (nonatomic ,copy)   NSString   *postcode;
@property (nonatomic ,copy)   NSString   *country;

@property (nonatomic ,copy)   NSString   *abstract;
 
@end

#pragma mark- Interface Author
@interface Author : NSObject {
@public
    NSString *givenName;
    NSString *familyName;
}
@property (nonatomic ,copy ) NSString *givenName;
@property (nonatomic ,copy ) NSString *familyName;
@end



#pragma mark- Interface References
@interface References : NSObject 

@property (nonatomic, assign) short citiationNo;
@property (nonatomic, assign) short year;
@property (nonatomic, assign) short volumeID;
@property (nonatomic, assign) short firstPage;

@property (nonatomic,copy) NSString *journalTitle;
@property (nonatomic,copy) NSString *doi;
@property (nonatomic,copy) NSString *coi;
@property (nonatomic,copy) NSString *authorsStr;

@end

