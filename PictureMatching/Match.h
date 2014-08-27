//
//  Match.h
//  PictureMatching
//
//  Created by fengsl on 14-8-20.
//  Copyright (c) 2014年 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

- (BOOL) vertical:(int)firstTag second:(int)secondTag;
- (BOOL) oneCorner:(int)firstTag second:(int)secondTag;
- (void) scan:(int)Tag1 bTag:(int)Tag2;
- (BOOL) twoCorner:(int)firstTag second:(int)secondTag;
- (BOOL) checkLink:(int)firstTag second:(int)secondTag;
//- (BOOL) matchPic:(int)firstTag second:(int)secondTag;

@end
