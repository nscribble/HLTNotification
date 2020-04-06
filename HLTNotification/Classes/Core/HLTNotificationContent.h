//
//  HLTNotificationContent.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLTNotificationContent : NSObject

@property (nonatomic,strong,readonly) NSDictionary *payload;

+ (instancetype)contentWithPayload:(NSDictionary *)payload;

@end

NS_ASSUME_NONNULL_END
