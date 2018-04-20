//
//  AppDelegate.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHBookListController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:[ZHBookListController new]];
    self.window.rootViewController =NAV ;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
