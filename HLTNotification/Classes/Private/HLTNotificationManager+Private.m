//
//  HLTNotificationManager+Private.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/16.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationManager+Private.h"

@implementation HLTNotificationManager (Private)

- (void)notificationView:(HLTNotificationView *)view takeAction:(NSString *)action actionInfo:(nonnull NSDictionary *)actionInfo {
    HLTNotificationResponse *resp = [self __responseForNotification:view.notification
                                                             action:action
                                                         actionInfo:actionInfo];
    if (resp && [self.eventDelegate respondsToSelector:@selector(manager:didReceiveNotificationResponse:completion:)]) {
        [self.eventDelegate manager:self didReceiveNotificationResponse:resp completion:^{
            
        }];
    } else {
        // close view and check to dequeue
    }
}

- (void)notificationView:(HLTNotificationView *)view dismissed:(HLTNotificationDismissReason)reason {
    if ([self.eventDelegate respondsToSelector:@selector(manager:notificationDidDismiss:)]) {
        [self.eventDelegate manager:self notificationDidDismiss:view.notification];
    }
}

- (HLTNotificationResponse *)__responseForNotification:(HLTNotification *)notification action:(NSString *)action actionInfo:(NSDictionary *)actionInfo {
    HLTNotificationResponse *resp = [HLTNotificationResponse responseForNotification:notification action:action actionInfo:actionInfo];
    
    return resp;
}

@end
