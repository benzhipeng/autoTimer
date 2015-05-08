//
//  NSTimer+AutoStop.h
//  ECalendar-Pro
//
//  Created by B.E.N on 15/5/7.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimeBlock)(NSTimer* timer);

@class AutoStopTarget;
@interface AutoStopTracker : NSObject
@property (nonatomic,weak) AutoStopTarget* autoStopTarget;
@end


@interface AutoStopTarget : NSObject
@property (nonatomic,weak) NSTimer* timer;
@property (nonatomic,weak) id target;
@property (nonatomic) SEL     selector;

@property (nonatomic,copy) TimeBlock    block;
@end


@interface NSTimer (AutoStop)

+ (NSTimer*)scheduledTimerWithAutoTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                      selector:(SEL)selector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats;


+ (void)scheduledTimerWithAutoTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                         block:(TimeBlock)block
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats;
@end
