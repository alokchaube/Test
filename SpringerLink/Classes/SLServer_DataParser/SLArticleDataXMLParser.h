//
//  SLArticleDataXMLParser.h
//  SpringerLink
//
//  Created by Prakash Raj on 24/04/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolDecleration.h"


@class SLServerXMLResponse;
@class PublisherInfo;
@class JournalInfo;
@class VolumeInfo;
@class IssueInfo;
@class ArticleInfo;
@class Author;
@class References;

@interface SLArticleDataXMLParser : NSObject <NSXMLParserDelegate> {
    
@private
    NSXMLParser          *_xmlParser;
    NSMutableString      *_currentElementStr;
    
    SLServerXMLResponse  *_response;
    PublisherInfo        *_publisherInfo;
    JournalInfo          *_journalInfo;
    NSMutableArray       *_journalSubjects;
    VolumeInfo           *_volumeInfo;
    
    NSMutableString      *_dateString;
    IssueInfo            *_issueInfo;
    
    ArticleInfo          *_articleInfo;
    Author               *_author;
    NSMutableArray       *_authorsArray;
    
    References           *_refrences;
    NSMutableArray       *_referencesArray;
    
@public
    __unsafe_unretained id <SLArticleDataXMLParserDelegate>  _delegate;
}

@property (nonatomic, assign) id <SLArticleDataXMLParserDelegate> delegate;

- (void)parseData:(NSData *)data;

@end



/*
 
 <BibUnstructured>
 
 <Emphasis Type="SmallCaps">A. B. Middleton, L. B. Pfeil</Emphasis>
 , and 
 
 <Emphasis Type="SmallCaps">E. C. Rhodes</Emphasis>
 , 
 
 <Emphasis Type="Italic">J. Inst. Metals</Emphasis>
 
 
 <Emphasis Type="Bold">75</Emphasis>
 (1949) 595; discussion, 
 
 <Emphasis Type="Italic">ibid</Emphasis>
 , p. 1142.
 </BibUnstructured>
 

 */

/*
 
 <ArticleBackmatter>
 
 .......
 <Bibliography ID="Bib1">
 <Heading>References</Heading>
 
 <Citation ID="CR1">
 
 <CitationNumber>1.</CitationNumber>
 
 <BibArticle>
 <BibAuthorName>
 <Initials>H</Initials>
 <FamilyName>Sumiya</FamilyName>
 </BibAuthorName>
 <BibAuthorName>
 <Initials>S</Initials>
 <FamilyName>Uesaka</FamilyName>
 </BibAuthorName>
 <BibAuthorName>
 <Initials>S</Initials>
 <FamilyName>Satoh</FamilyName>
 </BibAuthorName>
 
 <Year>2000</Year>
 <NoArticleTitle />
 
 <JournalTitle>J Mater Sci</JournalTitle>
 <VolumeID>35</VolumeID>
 <FirstPage>1181</FirstPage>
 <BibArticleDOI>10.1023/A:1004780218732</BibArticleDOI>
 
 <Occurrence Type="DOI">
 <Handle>10.1023/A:1004780218732</Handle>
 </Occurrence>
 
 <Occurrence Type="COI">
 <Handle>1:CAS:528:DC%2BD3cXhslSls74%3D</Handle>
 </Occurrence>
 
 </BibArticle>
 
 <BibUnstructured>Sumiya H, Uesaka S, Satoh S (2000) J Mater Sci 35:1181. doi:
 <ExternalRef>
 <RefSource>10.1023/A:1004780218732</RefSource>
 <RefTarget Address="10.1023/A:1004780218732" TargetType="DOI" />
 </ExternalRef>
 </BibUnstructured>
 </Citation>
 
 */
