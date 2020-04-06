//
//  HLTNotificationRequest.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTNotificationContent.h"
#import "HLTNotificationDisplayOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLTNotificationRequest : NSObject

@property (nonatomic, strong, readonly) HLTNotificationContent *content;
@property (nonatomic, strong) HLTNotificationDisplayOption *option;

+ (instancetype)requestWithPayload:(NSDictionary *)payload;

@end

NS_ASSUME_NONNULL_END
