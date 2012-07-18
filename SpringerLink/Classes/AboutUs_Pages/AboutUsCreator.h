//
//  AboutUsCreator.h
//  SpringerLink
//
//  Created by Prakash on 25/05/12.
//  Copyright (c) 2012 kiwitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutUsCreator : NSObject

+ (AboutUsCreator *)shared;
- (void)createAboutUsPage;
@end
