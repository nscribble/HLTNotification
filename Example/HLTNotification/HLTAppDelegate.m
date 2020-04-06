//
//  HLTAppDelegate.m
//  HLTNotification
//
//  Created by nscribble on 03/19/2019.
//  Copyright (c) 2019 nscribble. All rights reserved.
//

#import "HLTAppDelegate.h"
#import <HLTNotification/HLTNotificationManager.h>
#import <HLTNotification/HLTNotificationSlideView.h>

@interface HLTAppDelegate ()
<
HLTNotificationInterfaceDelegate,
HLTNotificationEventDelegate
>

@end

@implementation HLTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setup];
    [self test];
    
    return YES;
}

- (void)setup {
    [HLTNotificationManager setLogger:^(NSString *format, ...) {
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSLog(@"%@", message);
        va_end(args);
    }];
    [[HLTNotificationManager sharedInstance] setInterfaceDelegate:self];
    [[HLTNotificationManager sharedInstance] setEventDelegate:self];
    [[HLTNotificationManager sharedInstance] addObserverForEvent:@"actionHaha"
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSString *event, HLTNotification *notification) {
                                                          NSLog(@"on event: %@, noti: %@", event, notification);
                                                      }];
}

- (void)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *payload = @{@"avatar": @"https://lovepicture.nosdn.127.net/1640487892230897359?imageView",
                                  @"title": @"哈哈哈哈这是标题",
                                  @"subtitle": @"副标题"
                                  };
        [[HLTNotificationManager sharedInstance] addNotificationWithPayload:payload];
        
    });
}

#pragma mark - HLTNotificationInterfaceDelegate

- (HLTNotificationView *)viewForNotification:(HLTNotification *)notification {
    return [HLTNotificationSlideView viewForNotification:notification];
}

#pragma mark - HLTNotificationEventDelegate

- (void)manager:(HLTNotificationManager *)um didReceiveNotificationResponse:(HLTNotificationResponse *)response completion:(void (^)(void))completion {
    NSLog(@"didReceiveNotificationResponse: %@", response);
}

@end
