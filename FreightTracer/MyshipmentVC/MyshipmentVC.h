//
//  MyshipmentVC.h
//  FreightTracer
//
//  Created by Animesh Jana on 08/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"


@interface MyshipmentVC : UIViewController

- (IBAction)Getstatus_Pressed:(id)sender;

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@property (weak, nonatomic) IBOutlet UITextField *txt_mob;

@property (weak, nonatomic) IBOutlet UIButton *btn_getstatus;

@end
