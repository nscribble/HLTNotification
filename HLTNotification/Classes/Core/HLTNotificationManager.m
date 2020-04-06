//
//  HLTNotificationManager.m
//  HLTNotification
//
//  Created by nscribble on 2017/12/15.
//  Copyright © 2017年 Jason Chan. All rights reserved.
//

#import "HLTNotificationManager.h"
#import "HLTNotificationQueue.h"
#import "HLTNotification+Private.h"
#import "HLTNotificationManager+Private.h"

//! 取消
NSString *kInAppNotificationEventShow           = @"show";
//! 关闭
NSString *kInAppNotificationEventDismiss        = @"dismiss";

NSTimeInterval const kMinPresentInterval        = 0.35;

#pragma mark - Observer

@interface HLTNotificationObserver : NSObject

@property (nonatomic,copy) NSString                     *name;
@property (nonatomic,strong) NSOperationQueue           *callbackQueue;
@property (nonatomic,copy) HLTNotificationEventBlock   callbackBlock;

@end

@implementation HLTNotificationObserver

+ (instancetype)observerForName:(NSString *)name queue:(NSOperationQueue *)queue block:(HLTNotificationEventBlock)block {
    HLTNotificationObserver *observer = [HLTNotificationObserver new];
    observer.name = name;
    observer.callbackQueue = queue;
    observer.callbackBlock = block;
    if (!name || !block) {
        HLTLog(@"[Error]HLTNotificationObserver: no name or no block");
    }
    
    return observer;
}

@end

#pragma mark - HLTNotificationManager

@interface HLTNotificationManager()

//! 消息队列
@property (nonatomic, strong) HLTNotificationQueue *queue;
//! 最后展示的通知
@property (nonatomic, strong) HLTNotification *lastPresenting;

//! 当前展示中的视图
@property (nonatomic,strong) NSMutableDictionary        *presentingViews;
//! 最近展示开始时间
@property (nonatomic,assign) NSTimeInterval lastPresentTime;
//! 最近展示结束时间
@property (nonatomic,assign) NSTimeInterval lastDismissTime;

//! 事件监听者
@property (nonatomic,strong) NSMutableDictionary <NSString *, NSMutableArray<HLTNotificationObserver *> *> *observers;
//! 锁
@property (nonatomic,strong) NSLock     *lock;

@end

void (^__HLTNotificationLogger)(NSString *format, ...);

@implementation HLTNotificationManager

+ (instancetype)sharedInstance {
    static HLTNotificationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    
    return manager;
}

+ (void)setLogger:(void (^)(NSString *format, ...))logger {
    __HLTNotificationLogger = logger;
}

- (void)addNotificationWithPayload:(NSDictionary *)payload {
    HLTNotificationRequest *req = [HLTNotificationRequest requestWithPayload:payload];
    [self addNotificationRequest:req];
}

- (void)addNotificationRequest:(HLTNotificationRequest *)request {
    HLTNotification *notification = [self __notificationForRequest:request];
    if (!request.option) {
        request.option = self.displayOption;
    }
    
    if ([self.eventDelegate respondsToSelector:@selector(manager:willAddNotification:)]) {
        [self.eventDelegate manager:self willAddNotification:notification];
    }
    
    [self.queue enqueue:notification];
}

- (HLTNotification *)__notificationForRequest:(HLTNotificationRequest *)request {
    HLTNotification *notification = [HLTNotification notificationWithRequest:request];
    return notification;
}

//- (void)getPendingRequests:(void(^)(NSArray<HLTNotificationRequest *> *requests))completion{
//    
//}
//
//- (void)removePendingRequests:(NSArray<HLTNotificationRequest *> *)requests {
//    
//}

//- (void)getDeliveredNotifications:(void (^)(NSArray<HLTNotification *> *))completion {
//
//}
//
//- (void)removeDeliveredNotifications:(NSArray<HLTNotification *> *)notifications{
//
//}


#pragma mark - Getter

- (HLTNotificationQueue *)queue {
    if (!_queue) {
        _queue = [HLTNotificationQueue new];
        
        __weak typeof(self) weakSelf = self;
        _queue.onDequeue = ^(HLTNotification *notification) {
            [weakSelf presentNotification:notification];
        };
    }
    
    return _queue;
}

- (NSLock *)lock {
    if (!_lock) {
        _lock = [NSLock new];
    }
    
    return _lock;
}

- (NSMutableDictionary<NSString *,NSMutableArray<HLTNotificationObserver *> *> *)observers {
    if (!_observers) {
        _observers = [NSMutableDictionary dictionary];
    }
    
    return _observers;
}

//! 注意：内部有加锁操作
- (NSMutableArray *)observersForName:(NSString *)name {
    NSMutableArray *array = self.observers[name];
    if (!array) {
        [self.lock lock];
        if (self.observers[name]) {
            array = self.observers[name];
        }
        else {
            array = [NSMutableArray<HLTNotificationObserver *> array];
            self.observers[name] = array;
        }
        [self.lock unlock];
    }
    
    return array;
}

- (NSMutableDictionary *)presentingViews {
    if (!_presentingViews) {
        _presentingViews = @{}.mutableCopy;
    }
    
    return _presentingViews;
}

#pragma mark - Event & Observers

- (id)addObserverForEvent:(NSString *)name queue:(NSOperationQueue *)queue usingBlock:(HLTNotificationEventBlock)block {
    
    if (!name || block == NULL) {
        HLTLog(@"addObserverForName: No Name or Block");
        return nil;
    }
    
    HLTNotificationObserver *observer = [HLTNotificationObserver observerForName:name queue:queue block:block];
    NSMutableArray *observers = [self observersForName:name];
    [self.lock lock];
    [observers addObject:observer];
    [self.lock unlock];
    
    return observer;
}

- (void)removeObserver:(HLTNotificationObserver *)observer {
    NSAssert([observer isKindOfClass:[HLTNotificationObserver class]], @"removeObserver: invalid observer class");
    
    if (!observer || !observer.name) {
        return;
    }
    
    NSString *name = observer.name;
    NSMutableArray *observers = [self observersForName:name];
    if (observers.count <= 0) {
        return;
    }
    
    [self.lock lock];
    [observers removeObject:observer];
    [self.lock unlock];
}

- (void)notifyEvent:(NSString *)name notification:(HLTNotification *)notification {
    if (!name || !self.observers[name]) {
        return;
    }
    
    NSMutableArray<HLTNotificationObserver *> *observers = [self observersForName:name];
    if (observers.count) {
        NSArray<HLTNotificationObserver *> *observersCopy = [observers copy];
        [observersCopy enumerateObjectsUsingBlock:^(HLTNotificationObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.callbackBlock == NULL) {
                return ;
            }
            if (obj.callbackQueue) {
                [obj.callbackQueue addOperationWithBlock:^{
                    if (obj.callbackBlock) {
                        obj.callbackBlock(name, notification);
                    }
                }];
            }
            else {// 默认主线程
                obj.callbackBlock(name, notification);
            }
        }];
    }
}

#pragma mark - Queue & Present

- (void)addNotification:(HLTNotification *)notification {
    [self.queue enqueue:notification];
}

- (void)cancelNotification:(HLTNotification *)notification {
    [self.queue cancel:notification];
}

- (HLTNotificationView *)presentNotification:(HLTNotification *)notification {
    if (!notification) {
        return nil;
    }
    
    __block BOOL decision = YES;
    if ([self.eventDelegate respondsToSelector:@selector(manager:willPresentNotification:decision:)]) {
        [self.eventDelegate manager:self
            willPresentNotification:notification
                           decision:^(BOOL result) {
                               decision = result;
                           }];
    }
    
    if (!decision) {
        HLTLog(@"Decided Not To Present: %@", notification);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.queue checkToDequeue];
        });
        
        return nil;
    }
    
    HLTNotificationView *view = self.presentingViews[@((uintptr_t)notification)];
    if (view) {
        return view;
    }
    
    view = [self.interfaceDelegate viewForNotification:notification];
    if (!view) {// using default view
        view = [HLTNotificationView viewForNotification:notification];
    }
    
    self.presentingViews[@((uintptr_t)notification)] = view;
    
#warning 修改展示queueing逻辑
    NSTimeInterval delta = [[NSDate date] timeIntervalSince1970] - self.lastDismissTime;
    if (delta < kMinPresentInterval) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((kMinPresentInterval - delta) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view show];
            self.lastPresentTime = [[NSDate date] timeIntervalSince1970];
        });
    }
    else {
        [view show];
        self.lastPresentTime = [[NSDate date] timeIntervalSince1970];
    }
    
    return view;
}

- (void)checkToDequeue {
    [self.queue checkToDequeue];
}

- (void)dimissAllPresentingNotificationViews {
    NSArray<HLTNotificationView *> *views = [self.presentingViews allValues];
    [views enumerateObjectsUsingBlock:^(HLTNotificationView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(dismiss)]) {
            [obj dismiss];
        }
    }];
}

@end
