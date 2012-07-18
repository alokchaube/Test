//
//  SectionInfo.h
//  SpringerLink
//
//  Created by Alok on 25/04/12.
//  Copyright (c) 2012 kiwi technologies india pvt ltd. All rights reserved.
//


/*
     File: SectionInfo.h
 Abstract: A section info object maintains information about a section:
 * Whether the section is open
 * The header view for the section
 * The model objects for the section -- in this case, the dictionary containing the issues for a single volume
 * The height of each row in the section
 
 */

#import <Foundation/Foundation.h>

@class SectionHeaderView;
@class VolumeListInfo;


@interface SectionInfo : NSObject 

@property (assign) BOOL open;
@property (strong) VolumeListInfo* objectVolume;
@property (strong) SectionHeaderView* headerView;

@property (nonatomic,strong,readonly) NSMutableArray *rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
