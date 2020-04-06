//
//  HLTNotificationView.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTNotificationDef.h"

NS_ASSUME_NONNULL_BEGIN

@class HLTNotification;
@class HLTNotificationView;

@protocol HLTNotificationViewDelegate <NSObject>
@optional

- (void)notificationView:(HLTNotificationView *)view takeAction:(NSString *)actionIdentifier actionInfo:(NSDictionary *)actionInfo;
- (void)notificationView:(HLTNotificationView *)view dismissed:(HLTNotificationDismissReason)reason;

@end

@interface HLTNotificationView : UIView

// 自定义View的交互事件，应当通过delegate将action转发
@property (nonatomic,weak,readonly) id<HLTNotificationViewDelegate> delegate;
@property (nonatomic,strong,readonly) HLTNotification *notification;

- (instancetype)initWithNotification:(HLTNotification * _Nullable)notification NS_DESIGNATED_INITIALIZER;

+ (instancetype)viewForNotification:(HLTNotification *)notification;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
