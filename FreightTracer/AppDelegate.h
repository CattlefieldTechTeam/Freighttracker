//
//  AppDelegate.h
//  Testbackgroundfetch
//
//  Created by Animesh Jana on 02/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    int value;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@end

