//
//  AppDelegate.m
//  Photo Briefer
//
//  Created by yonglim on 2/16/17.
//  Copyright © 2017 u023. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrKit.h"

@interface AppDelegate ()

@end

    // Initialise FlickrKit with your flickr api key and shared secret
NSString *apiKey = @"d084aca8b3bb201f9db2fe6ec0329b22";
NSString *secret = @"7ea3d22026dc64e5";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *scheme = [ url scheme];
    
    if ([@"photobriefer" isEqualToString:scheme]) {
        //TODO: this is just demo purpose need to revisit authentication controller to handle this properly
        // I don't recommend doing it like this, it's just a demo... I use an authentication
        // controller singleton object in my projects
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthCallbackNotification" object:url userInfo:nil];
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Initialise FlickrKit with your flickr api key and shared secret
//    NSString *apiKey = @"";
//    NSString *secret = @"";
    
    if (!apiKey) {
        NSLog(@"\n------------\n");
        exit(0);
    }
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:apiKey sharedSecret:secret];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    // Override point for customization after application launch
//    if ([[UIDevice currentDevice] userInterfaceIdiom == UIUserInterfaceIdiomPhone]) {
//        
//        self.viewController = [[FKViewController alloc] initWithNibName:@"FKViewController_iPhone" bundle:nil];
//        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//        
//    }
//    self.window.rootViewController = self.navigationController;
//    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
