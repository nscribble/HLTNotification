//
//  HLTNotificationQueue.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/18.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLTNotification;

typedef void(^HLTNotificationDequeueBlock)(HLTNotification *notification);

@interface HLTNotificationQueue : NSObject

@property (nonatomic, copy) HLTNotificationDequeueBlock onDequeue;

- (void)enqueue:(HLTNotification *)notification;
- (void)cancel:(HLTNotification *)notification;

- (void)checkToDequeue;

@end
