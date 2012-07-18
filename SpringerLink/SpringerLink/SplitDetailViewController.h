//
//  SplitDetailViewController.h
//  SpringerLink
//
//  Created by kiwitech kiwitech on 11/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol callerDelegate <NSObject>
@optional
- (void)setSelectedIndexOfTable:(short)index;
@end

@interface SplitDetailViewController : UIViewController {
   
    NSArray    *_articlesList;
}

@property (nonatomic, retain) id callerDelegate;
@property (nonatomic, retain) NSArray *articlesList;

- (void)makeHomeScreenLayout;
@end
