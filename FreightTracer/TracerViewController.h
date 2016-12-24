//
//  TracerViewController.h
//  FreightTracer
//
//  Created by Mac on 22/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TracerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
     UIProgressView *progressView;
    
    NSMutableArray *arrraydata;
    CLLocationManager *locationManager;
    double latvalue;
    double lngvalue;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;



-(void)getapidata;
- (IBAction)pushingview:(id)sender;
@end
