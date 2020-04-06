//
//  HLTNotificationManager.h
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTNotification.h"
#import "HLTNotificationView.h"
#import "HLTNotificationRequest.h"
#import "HLTNotificationResponse.h"

@class HLTNotificationManager;
@protocol HLTNotificationEventDelegate <NSObject>
@optional

// 此处可修改notification的优先级等
- (void)manager:(HLTNotificationManager *)um willAddNotification:(HLTNotification *)notification;
// 确定是否要展示notification。注：decision必须同步调用
- (void)manager:(HLTNotificationManager *)um willPresentNotification:(HLTNotification *)notification decision:(void(^)(BOOL result))decision;
- (void)manager:(HLTNotificationManager *)um didReceiveNotificationResponse:(HLTNotificationResponse *)response completion:(void(^)(void))completion;
- (void)manager:(HLTNotificationManager *)um notificationDidDismiss:(HLTNotification *)notification;

@end

// 提供UI自定义
@protocol HLTNotificationInterfaceDelegate <NSObject>
@optional

- (HLTNotificationView *)viewForNotification:(HLTNotification *)notification;

@end


//! 通知回调
typedef void(^HLTNotificationEventBlock)(NSString *event, HLTNotification *notification);

typedef BOOL(^HLTNotificationWillPresentBlock)(HLTNotification *notification);

extern NSString *kInAppNotificationEventShow;
extern NSString *kInAppNotificationEventDismiss;

//! 通知管理器
@interface HLTNotificationManager : NSObject<HLTNotificationViewDelegate>

@property (nonatomic, weak) id<HLTNotificationInterfaceDelegate> interfaceDelegate;
@property (nonatomic, weak) id<HLTNotificationEventDelegate> eventDelegate;
@property (nonatomic, strong, readonly) HLTNotificationDisplayOption *displayOption;

@property (nonatomic,copy) HLTNotificationWillPresentBlock decidePresentation;

+ (instancetype)sharedInstance;

/** for example
 [self setLogger:^(NSString *format, ...) {
     va_list args;
     va_start(args, fmt);
     NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
     va_end(args);
     NSLog(message);
 }];
 @param logger 日志器
 */
+ (void)setLogger:(void(^)(NSString *format, ...))logger;

#pragma mark - 消息管理

- (void)addNotificationWithPayload:(NSDictionary *)payload;
- (void)addNotificationRequest:(HLTNotificationRequest *)request;

//! 查询/移除 未展示的通知请求
- (void)getPendingRequests:(void(^)(NSArray<HLTNotificationRequest *> *requests))completion;
- (void)removePendingRequests:(NSArray<HLTNotificationRequest *> *)requests;

- (void)getDeliveredNotifications:(void(^)(NSArray<HLTNotification *> *notifications))completion;
- (void)removeDeliveredNotifications:(NSArray<HLTNotification *> *)notifications;



//! 触发展示队列检查
- (void)checkToDequeue;

#pragma mark - 消息事件交互

/**
 添加事件观察者

 @param name 事件名称
 @param queue 队列
 @param block 回调块
 @return 观察者对象（请注意持有并及时注销观察）
 */
- (id)addObserverForEvent:(NSString *)name
                    queue:(NSOperationQueue *)queue
               usingBlock:(HLTNotificationEventBlock)block;

/**
 移除事件观察者

 @param observer 事件观察者（-addObserverForEvent:queue:usingBlock:返回）
 */
- (void)removeObserver:(id)observer;

@end
