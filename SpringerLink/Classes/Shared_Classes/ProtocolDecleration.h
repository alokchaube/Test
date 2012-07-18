//
//  ProtocolDecleration.h
//  SpringerLink
//
//  Created by Kiwitech on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark- SLServerDataFetcher Delegate methods

@protocol SLServerDataFetcherDelegate <NSObject>

@optional
//call back method when an error accured
- (void)requestFailedWithError;
/*
 * call back method to get the response
 * @param : data - returned the response data.
 */
- (void)requestFinishedWithData:(NSData *)data;
@end



#pragma mark- SLArticleDataXMLParser Delegate methods

@class SLServerXMLResponse;
@protocol SLArticleDataXMLParserDelegate <NSObject>

@optional
/*
 * call back method to get information of article
 * @param : response - object of SLServerXMLResponse class contains
 informations of articles.
 */
- (void)didRecieveResponse:(SLServerXMLResponse *)response;
@end


#pragma mark- SectionHeaderViewDelegate
/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@class SectionHeaderView;
@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;
@end


#pragma mark- DatePickerViewControllerDelegate
/*
 Protocol declaration to carry date for DatePickerViewController when user select any month and year, and come back to previous screen.
 */
@protocol PickerViewControllerDelegate <NSObject>

@optional
- (void)didPickedMonth:(short)month andYear:(short)year;
- (void)didPickerCancel;
- (void)onSelectingPickerRow:(NSString*)rowTitle;
- (void)onChangingPickerTitleSelection:(NSString*)rowTitle;
@end

#pragma mark - CustomScrollViewDelegate
/*
 Protocol declaration to carry date for CustomScrollView.
 */
@protocol CustomScrollViewDelegate <NSObject>

@optional
- (void)performTouchEndTasks;
@end


#pragma mark- ArticalListViewDelegate
/*
 Protocol declaration to carry date for DatePickerViewController when user select any month and year, and come back to previous screen.
 */
@protocol ArticalListViewDelegate <NSObject>

@optional
- (void)onSelectingTableViewCell:(NSIndexPath*)indexPath  
    withTableViewDataSourceArray:(NSArray*)dataSourceArray;
- (void)onScrollTableView:(UIScrollView*)scrollView;
@end

#pragma mark- ArticalListViewDelegate
/*
 Protocol declaration to carry date for ArticleDetailView.
 */
@protocol ArticleDetailViewDelegate <NSObject>

@optional
- (void)addLoader:(BOOL)flag;
- (void)downloadBtnClicked;
- (void)openRefLink:(NSString *)linkUrlStr;
@end