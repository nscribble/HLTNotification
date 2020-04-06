//
//  HLTNotificationResponse.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTNotificationResponse : NSObject

@property (nonatomic, strong, readonly) HLTNotification *notification;
@property (nonatomic, copy, readonly) NSString *actionIdentifier;
@property (nonatomic, copy, readonly) NSDictionary *actionInfo;

+ (instancetype)responseForNotification:(HLTNotification *)notification action:(NSString *)action actionInfo:(NSDictionary *)actionInfo;

@end

NS_ASSUME_NONNULL_END
