//
//  SearchResultController.h
//  SpringerLink
//
//  Created by Alok on 12/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLMetadataXMLParser.h"
#import "ASIHTTPRequest.h"
#import "SLService.h"
/**
 *  This is a view controller class in which show the title, authors name, publication and  volume number of articles in a tableview.
 */

@class LoaderView;
@class SLXMLResponse;
@class SLService;
@interface SearchResultController : UIViewController<ASIHTTPRequestDelegate,SLMetadataXMLParserDelegate>
{
    NSMutableArray*     _records;
    LoaderView *        _loader;
    ASIHTTPRequest*     _httpRequest;
    SLService *         _objSLService;
    MetadataInfoResult* _result;
    int                 _startNumber;

    
    
}
@property (nonatomic, retain) IBOutlet UITableView* searchTable;
@property (nonatomic, retain) SLXMLResponse*        response;
@property (nonatomic, retain) NSString*             searchKey;

@property (nonatomic, retain)FacetsQuery* facetsQuery;
@property (nonatomic, retain)ConstraintsQuery* constraintsQuery;
@property (nonatomic) TermsType termsType;

/**
 * method for start serching.
 * @param: qStr-> pass the query string.
 */
- (void)startSearchingWithQuery:(NSString *)qStr;
- (void)loadMoreResults;

@end
