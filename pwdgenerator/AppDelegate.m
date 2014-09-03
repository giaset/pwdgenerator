//
//  AppDelegate.m
//  pwdgenerator
//
//  Created by Gianni Settino on 2014-09-03.
//  Copyright (c) 2014 Milton and Parc. All rights reserved.
//

#import "AppDelegate.h"
#import "PWDMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[PWDMainViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
