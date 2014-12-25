//
//  NSTimer+Addition.h
//  PagedScrollView
//
//  Created by 刘康 on 14/11/16.
//  Copyright (c) 2014年 origheart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
