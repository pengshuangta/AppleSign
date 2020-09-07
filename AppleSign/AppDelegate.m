//
//  AppDelegate.m
//  AppleSign
//
//  Created by 彭双塔 on 2020/9/7.
//  Copyright © 2020 pst. All rights reserved.
//

#import "AppDelegate.h"
#import "PST_HomeViewController.h"
#import "PST_NavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self loadRootVC];
    return YES;
}

#pragma mark - 根试图
-(void)loadRootVC{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    PST_HomeViewController *vc = [PST_HomeViewController new];
    PST_NavigationViewController *nav = [[PST_NavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}



@end
