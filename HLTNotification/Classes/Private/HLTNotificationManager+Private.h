//
//  HLTNotificationManager+Private.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/16.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationManager.h"
#import "HLTNotificationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTNotificationManager (Private)<HLTNotificationViewDelegate>

- (void)notificationView:(HLTNotificationView *)view takeAction:(NSString *)actionIdentifier actionInfo:(NSDictionary *)actionInfo;
- (void)notificationView:(HLTNotificationView *)view dismissed:(HLTNotificationDismissReason)reason;

@end

NS_ASSUME_NONNULL_END
