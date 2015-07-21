//
//  AppDelegate.m
//  TODO-LIST
//
//  Created by Siyao Lu on 14/12/1.
//  Copyright (c) 2014年 CSE436. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SubclassConfigViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"cvxdxhLK9Di6FV5etw4Y96Y126HV9VpGtxSqCfX5"
                  clientKey:@"1oWPmwlm4eQPZuFYc7wrkmHnP2x5TGSZFoNZ84IN"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //default ACL
    PFACL *defaultACL = [PFACL ACL];
    //[defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    SubclassConfigViewController *VC = [[SubclassConfigViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    nav.navigationBar.barStyle = UIBarStyleDefault;
    //nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    nav.navigationBar.translucent = NO;
    //nav.navigationBar.backgroundColor = [UIColor colorWithRed:0.45 green:0.3 blue:0.25 alpha:0.5];
    //[nav.navigationBar setTintColor:[UIColor redColor]];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.65 green:0.25 blue:0.1 alpha:1.0], NSForegroundColorAttributeName, [UIFont fontWithName:@"Zapfino" size:25], NSFontAttributeName, nil]];
    // Navigation bar appearance (background and title)
    
    [nav.navigationBar setBarTintColor:[UIColor darkGrayColor]];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
