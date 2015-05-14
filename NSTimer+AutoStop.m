//
//  NSTimer+AutoStop.m
//  ECalendar-Pro
//
//  Created by B.E.N on 15/5/7.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import "NSTimer+AutoStop.h"
#import <objc/runtime.h>

@implementation AutoStopTracker

- (void)dealloc{

    [self.autoStopTarget.timer invalidate];
    self.autoStopTarget.timer = nil;
}

@end


@implementation AutoStopTarget
- (void)timeAction:(NSTimer*)timer{
    
    if(self.selector){
        if ([self.target respondsToSelector:self.selector]) {
            NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:self.selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            if (methodSignature.numberOfArguments > 2) [invocation setArgument:&timer atIndex:2];
            invocation.selector = self.selector;
            [invocation invokeWithTarget:self.target];
        } else {
            [self.target doesNotRecognizeSelector:self.selector];
        }
    }
    
    if(self.block){
        self.block(timer);
    }
}

- (void)dealloc{

}
@end


@implementation NSTimer (AutoStop)
+ (NSTimer*)scheduledTimerWithAutoTimeInterval:(NSTimeInterval)timeInterval
                                target:(id)target
                                  selector:(SEL)selector
                                  userInfo:(id)userInfo
                                   repeats:(BOOL)repeats{
    AutoStopTarget* autoStopTarget = [[AutoStopTarget alloc] init];
    autoStopTarget.selector  = selector;
    autoStopTarget.target = target;
    
    NSTimer* timer =[NSTimer scheduledTimerWithTimeInterval:timeInterval target:autoStopTarget selector:@selector(timeAction:) userInfo:userInfo repeats:repeats];
    autoStopTarget.timer = timer;
    
    AutoStopTracker* tracker = [[AutoStopTracker alloc] init];
    tracker.autoStopTarget = autoStopTarget;
    objc_setAssociatedObject(target, (__bridge void *)tracker, tracker,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return timer;
}

+ (void)scheduledTimerWithAutoTimeInterval:(NSTimeInterval)timeInterval
                                        target:(id)target
                                         block:(TimeBlock)block
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)repeats{
    AutoStopTarget* autoStopTarget = [[AutoStopTarget alloc] init];
    autoStopTarget.block  = block;
    autoStopTarget.target = target;
    
    __unused NSTimer* timer =[NSTimer scheduledTimerWithTimeInterval:timeInterval target:autoStopTarget selector:@selector(timeAction:) userInfo:userInfo repeats:repeats];
    autoStopTarget.timer = timer;
    
    AutoStopTracker* tracker = [[AutoStopTracker alloc] init];
    tracker.autoStopTarget = autoStopTarget;
    objc_setAssociatedObject(target, (__bridge void *)tracker, tracker,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
