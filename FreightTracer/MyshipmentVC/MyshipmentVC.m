//
//  MyshipmentVC.m
//  FreightTracer
//
//  Created by Animesh Jana on 08/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import "MyshipmentVC.h"
#import "MyshipmentdetailVC.h"

@interface MyshipmentVC ()

@end

@implementation MyshipmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _btn_getstatus.layer.cornerRadius=8.0f;
    
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

- (IBAction)Getstatus_Pressed:(id)sender {
    
    ////http//f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetMyShipments?mobileno=9943523175

    if ([[Common SharedInstance] removeWhiteSpaceFromString:_txt_mob.text].length>0){
            if ([InternetValidation connectedToNetwork]) {
                
                
                
                [SVProgressHUD show];
                
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                
                 //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/GetMyShipments" parameters:@{@"mobileno":_txt_mob.text}  progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    // do whatever you'd like here; for example, if you want to convert
                    // it to a string and log it, you might do something like:
                    
                    //
                    //                                                        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    NSDictionary *json = (NSDictionary* )responseObject;
                    NSLog(@"json::%@",json);
                    NSLog(@"responseObject::%@",responseObject);
                    
                    [SVProgressHUD dismiss];
                    
                    if([[json objectForKey:@"status"] intValue] == 1){
                        
                        NSMutableArray *dictuserDetails = [json objectForKey:@"content"];
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictuserDetails];

                        [[Common SharedInstance] storObject:data forKey:LoadDetails];
                        
                        MyshipmentdetailVC *mMyshipmentdetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyshipmentdetailVC"];
                        [self.navigationController pushViewController:mMyshipmentdetailVC animated:YES ];
                        
                        
                        
                            }
                    else{
                        [[Common SharedInstance]showAlertWithTitle:@"Apprenticeship" message:[json objectForKey:@"message"] For:self];
                    }
                    
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    [SVProgressHUD dismiss];
                    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"FreightTracer"  message:error.localizedDescription  preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }];
                
                
                
                
                
            }
            
            else{
                
                [[Common SharedInstance] ShowAlertWithMessage:kNETWORK_CONNECTION];
                
            }
            
            
        }
        
        else {
            [[Common SharedInstance]showAlertWithTitle:nil message:@"Please Enter Your Mobile number." For:self];
        }
        
        
        
        
        
        
    
    
    
//    self.locationTracker = [[LocationTracker alloc]init];
//           [self.locationTracker startLocationTracking];
//
//    NSTimeInterval time = 600.0f;
//            self.locationUpdateTimer =
//            [NSTimer scheduledTimerWithTimeInterval:time
//                                             target:self
//                                           selector:@selector(updateLocation)
//                                           userInfo:nil
//                                            repeats:YES];
}


-(void)updateLocation {
    NSLog(@"updateLocation");

    [self.locationTracker updateLocationToServer];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}




@end
