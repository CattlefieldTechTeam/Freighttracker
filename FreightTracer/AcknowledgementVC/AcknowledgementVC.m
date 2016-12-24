//
//  AcknowledgementVC.m
//  FreightTracer
//
//  Created by Animesh Jana on 17/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import "AcknowledgementVC.h"
#import "DetailVC.h"

@interface AcknowledgementVC ()

@end

@implementation AcknowledgementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _yes_btn.layer.cornerRadius=8.0f;
    _no_btn.layer.cornerRadius=8.0f;
    selectedload = [[Common SharedInstance] getValueForKey:SelectedId];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    
    UITouch *touch = [touches anyObject];
    NSLog(@"%ld",touch.view.tag);
    
    if (touch.view.tag == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.freighttracer.com/terms.html"]];
    }
    else if (touch.view.tag == 2){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.freighttracer.com/privacy.html"]];
 
    }
    
    
    

    
}
- (IBAction)yes_btn_pressed:(id)sender {
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/ValidateDeviceID?" parameters:[selectedload valueForKey:@"LoadID"] progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToNumber:@(1)])
        {
            
            NSString *displayNameType = NSStringFromClass([[responseObject objectForKey:@"Deviceid"] class]);
            if ([displayNameType  isEqual:@""] || [displayNameType  isEqual:@"NSNull"])
            {
                
                NSLog(@"%@",displayNameType);
                [self deviceIDValidate];

                
            }
            else
            {
                

            
            }
            
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    
}

- (IBAction)no_btn_pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deviceIDValidate

{
    
    [self getcurrentlocationlatitudelongitude];

    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", Identifier);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *params =[[NSDictionary alloc]initWithObjectsAndKeys:loadid,@"loadID",[self.dictnarydata objectForKey:@"ShipmentId"],@"ShipmentId",latvalue,@"Latitude",lngvalue,@"Longitude",Identifier,@"deviceid",nil];
    [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/LoadAcknowlegment?" parameters:@{@"loadID":[selectedload valueForKey:@"LoadID"],@"ShipmentId":[selectedload valueForKey:@"ShipmentId"],@"Latitude":latvalue,@"Longitude":lngvalue,@"deviceid":Identifier}progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToNumber:@(1)])
        {
          
            DetailVC *mDetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
            [self.navigationController pushViewController:mDetailVC animated:YES];
            
            
        }else
        {
            
            
            
        }
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}

-(void)getcurrentlocationlatitudelongitude

{
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = [NSString stringWithFormat:@"%f",coordinate.latitude];
    lngvalue = [NSString stringWithFormat:@"%f",coordinate.longitude] ;
    [locationManager stopUpdatingLocation];
    locationManager =nil;
    
    
    
    
    
    
}

@end
