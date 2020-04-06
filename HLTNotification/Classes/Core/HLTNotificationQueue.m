//
//  HLTNotificationQueue.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/18.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationQueue.h"
#import "HLTNotification+Private.h"
#import "HLTNotificationRequest.h"

@interface HLTNotificationQueue()

@property (nonatomic,strong) NSMutableArray<HLTNotification *> *queue;
@property (nonatomic,strong) HLTNotification *current;

@end

@implementation HLTNotificationQueue

- (NSMutableArray<HLTNotification *> *)queue {
    if (!_queue) {
        _queue = @[].mutableCopy;
    }
    
    return _queue;
}

#pragma mark -

- (void)enqueue:(HLTNotification *)notification {
    HLTLog(@"enqueue: %@, self.current: %@", notification, @((uintptr_t)self.current));
    HLTNotification *previous = self.current;
    
    HLTNotificationDisplayOption *option = previous.request.option;
    CGFloat preMinDuration = option.minDuration;
    NSTimeInterval lastPresentTime = previous.presentTime;
    NSTimeInterval delta = preMinDuration - ([[NSDate date] timeIntervalSince1970] - lastPresentTime);
    
    BOOL enqueue = NO;
    if (self.current) {
        
        // 独占展示（直到结束）
        if (option.exclusive || delta > 0) {
            enqueue = YES;
        }
    }
    
    if (enqueue) {
        [self.queue addObject:notification];
        
        [self performSelector:@selector(checkToDequeue) withObject:nil afterDelay:MAX(0, delta)];
    }
    else {
        [self presentNotification:notification];
    }
}

- (void)cancel:(HLTNotification *)notification {
    if (!notification) {
        return;
    }
    
    [self.queue removeObject:notification];
}

- (void)checkToDequeue {
    HLTLog(@"checkToDequeue");
    
    if (!self.current) {
        [self dequeue];
        return;
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ((now - self.current.presentTime >= self.current.duration) ||
        (now - self.current.presentTime >= self.current.minDuration &&
         !(self.current.isExclusive)
         )) {
        [self dequeue];
    }
}

- (void)sortQueue:(NSMutableArray<HLTNotification *> *)queue {
    [queue sortUsingComparator:^NSComparisonResult(HLTNotification * obj1, HLTNotification  * obj2) {
        if (obj1.priority == obj2.priority) {
            return NSOrderedSame;
        }
        else if (obj1.priority > obj2.priority) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
}

- (HLTNotification *)dequeue {
    HLTNotification *notification = self.queue.firstObject;
    if (notification) {
        [self.queue removeObject:notification];
    }
    
    if (notification) {
#if DEBUG
        HLTLog(@"dequeue: %@", notification);
#endif
        [self presentNotification:notification];
    }
    
    return notification;
}

- (void)presentNotification:(HLTNotification *)notification {
    if (!notification) {
        return;
    }
    
    notification.presentTime = [[NSDate date] timeIntervalSince1970];
    self.current = notification;
    // 界面展示
    if (self.onDequeue) {
        self.onDequeue(notification);
    }
}

#pragma mark -

- (HLTNotification *)notificationOnBoard {
    return self.current;
}

@end
