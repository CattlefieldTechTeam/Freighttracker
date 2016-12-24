//
//  AcknowledgementVC.h
//  FreightTracer
//
//  Created by Animesh Jana on 17/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AcknowledgementVC : UIViewController<CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    NSString *latvalue;
    NSString *lngvalue;
    NSMutableDictionary *selectedload;

}
@property (weak, nonatomic) IBOutlet UIButton *yes_btn;
@property (weak, nonatomic) IBOutlet UIButton *no_btn;
@property (weak, nonatomic) IBOutlet UILabel *termsnconditions;
@property (weak, nonatomic) IBOutlet UILabel *ploicies;
- (IBAction)yes_btn_pressed:(id)sender;
- (IBAction)no_btn_pressed:(id)sender;



@end
