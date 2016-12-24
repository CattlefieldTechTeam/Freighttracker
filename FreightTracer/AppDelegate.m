//
//  AppDelegate.m
//  Testbackgroundfetch
//
//  Created by Animesh Jana on 02/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import "AppDelegate.h"
#import "MyshipmentVC/MyshipmentVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MyshipmentVC *mMyshipmentVC=[storyBoard instantiateViewControllerWithIdentifier:@"MyshipmentVC"];
    
    self.navigationController=[[UINavigationController alloc] initWithRootViewController:mMyshipmentVC];
    [self.navigationController setNavigationBarHidden:YES];
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
   }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //else{
//        
//        self.locationTracker = [[LocationTracker alloc]init];
//        [self.locationTracker startLocationTracking];
//        
//        NSString *urlString = [NSString stringWithFormat:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetIntravel?loadID=%@",@"209"];
//        
//        NSLog(@"%@",urlString);
//        
//        NSURLSession *session = [NSURLSession sharedSession];
//        [[session dataTaskWithURL:[NSURL URLWithString:urlString]
//                completionHandler:^(NSData *data,
//                                    NSURLResponse *response,
//                                    NSError *error) {
//                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//                    if (!error) {
//                        //---print out the result obtained---
//                        NSString *result =[[NSString alloc] initWithBytes:[data bytes]
//                                                                   length:[data length]
//                                                                 encoding:NSUTF8StringEncoding];
//                        
//                        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                        NSLog(@"%@", [res objectForKey:@"Intravel"]);
//                        value = [[res objectForKey:@"Intravel"] intValue];
//                        
//                        //---parse the JSON result---
//                        
//                        
//                        NSLog(@"value:::%d...",value);
//                    } else {
//                        NSLog(@"%@", error.description);
//                        
//                        NSLog(@" fetch Failed...");
//                    }
//                }
//          ] resume
//         ];
//        
//        
//        sleep(3);
//        
//        //Send the best location to server every 60 seconds
//        //You may adjust the time interval depends on the need of your app.
//        
//        ///
//        NSLog(@"value1:::%d...",(value/1000)/60);
//        
//        
//        NSTimeInterval time = 600.0f;
//        self.locationUpdateTimer =
//        [NSTimer scheduledTimerWithTimeInterval:time
//                                         target:self
//                                       selector:@selector(updateLocation)
//                                       userInfo:nil
//                                        repeats:YES];
//    }
    
    return YES;
}

//-(void)updateLocation {
//    NSLog(@"updateLocation");
//    
//    [self.locationTracker updateLocationToServer];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    
    // NSLog(@"didReceiveLocalNotification");
}



@end
