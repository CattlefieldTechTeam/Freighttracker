//
//  DetailFreightTracerController.m
//  FreightTracer
//
//  Created by Mac on 22/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "DetailFreightTracerController.h"
#import "QuartzCore/QuartzCore.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "TracerViewController.h"
#import "PodPageViewController.h"
#define kRefreshTimeInSeconds 1



@interface DetailFreightTracerController ()


{
    float x;
    int seconds;
    UILabel *transistlabel;
    UIButton *deletebutton;
    UIButton *Fromconformationbutton;
    UIButton *Stopconformationbutton;
    UIButton *  TOconformationbutton;
    BOOL picupstatusclicked;
    
    
    BOOL tableshow;
    int Timerval;
    
}
@end

@implementation DetailFreightTracerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableshow = YES;
    
    
    NSLog(@"dictnaryis::%@",self.dictnarydata);
    picupstatusclicked = NO;
    if (self.dictnarydata.count!=0) {
        [[NSUserDefaults standardUserDefaults]setObject:[self.dictnarydata valueForKey:@"LoadID"] forKey:@"LoadID"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[self.dictnarydata valueForKey:@"ShipmentId"] forKey:@"ShipmentId"];
        
         self.shipmentidlabel.text =[NSString stringWithFormat:@"ShipmentId:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ShipmentId"]];
        
        NSString *substatus = [self.dictnarydata valueForKey:@"Substatus"];
        if (substatus.length !=0) {
            self.intransistlabel.text =[NSString stringWithFormat:@"  %@[%@]",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
            
        }else
        {
            self.intransistlabel.text =[NSString stringWithFormat:@"%@",[self.dictnarydata valueForKey:@"MainStatus"]];
        }
        
        
        
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
  
    Timerval = 30;
    UIButton *podbutton =(UIButton *)[self.view viewWithTag:120];
    [podbutton setHidden:YES];
    
    
    Fromconformationbutton  = (UIButton *)[self.view viewWithTag:10];
     Stopconformationbutton = (UIButton *)[self.view viewWithTag:11];
    
   TOconformationbutton  = (UIButton *)[self.view viewWithTag:12];
    deletebutton  = (UIButton *)[self.view viewWithTag:20];
    
    [Fromconformationbutton setHidden:YES];
    [Stopconformationbutton setHidden:YES];
    [TOconformationbutton setHidden:YES];
    [deletebutton setHidden:YES];
    [self.ToOntimelabrl setHidden:YES];
        transistlabel  = (UILabel *)[self.view viewWithTag:17];
       [self getshadowview:self.stopview];
    [self getshadowview:self.toview];
    [self timeintervalApicall];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    
    
    
    [self cornerradiusButton:fromcopyAddressBtn];
    [self cornerradiusButton:ToCopyAddresBtn];
    [self cornerradiusButton:stopCopyAddresBtn];
    [self cornerradiusButton:Fromconformationbutton];
    [self cornerradiusButton:TOconformationbutton];
    [self cornerradiusButton:Stopconformationbutton];
    
    [self.dropdowntable setHidden:YES];
    self.dropdowntable.tableFooterView = [UIView new];
    [self.ontimeLabel setHidden:YES];
    [self getapidata];

    [SVProgressHUD show];
       
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark Api Calling for all
-(void)getapidata
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *loadid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"LoadID"]];
    
    NSDictionary *params =[[NSDictionary alloc]initWithObjectsAndKeys:loadid,@"LoadID",nil];
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetLoadData?" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        ContentDictinary =[[NSMutableDictionary alloc]init];
        
        ContentDictinary = [responseObject objectForKey:@"content"];
        
        if ([[responseObject objectForKey:@"status"] isEqualToNumber:@(1)])
        {
            ContentDictinary =[responseObject objectForKey:@"content"];
            
            NSLog(@"arraydata is::%@",ContentDictinary);
            id latevarencearr =[ContentDictinary objectForKey:@"LateVarience"];
            if (latevarencearr !=(id)[NSNull null]) {
                NSString *latestring =[[latevarencearr objectAtIndex:0]objectForKey:@"OnTimeorLate"];
                NSString *Tolatestring =[[latevarencearr objectAtIndex:1]objectForKey:@"OnTimeorLate"];

                if ([latestring isEqualToString:@"Late"]) {
                    self.ontimeLabel.textColor =[UIColor redColor];

                
                }else if ([latestring isEqualToString:@"On Time"])
                    
                {
                    
                    self.ontimeLabel.textColor =[UIColor greenColor];

                }
                if ([Tolatestring isEqualToString:@"Late"]) {
                    self.ToOntimelabrl.textColor =[UIColor redColor];
                    
                }else if([Tolatestring isEqualToString:@"On Time"])
                    
                {
                    self.ToOntimelabrl.textColor =[UIColor greenColor];

                    
                }
                [self.ontimeLabel setHidden:NO];
                [self.ToOntimelabrl setHidden:NO];
                self.ontimeLabel.text =[[latevarencearr objectAtIndex:0]objectForKey:@"OnTimeorLate"];

                self.ToOntimelabrl.text =[[latevarencearr objectAtIndex:1]objectForKey:@"OnTimeorLate"];

            }
          ///  [NSTimer scheduledTimerWithTimeInterval:1.0f
                                        //     target:self selector:@selector(methodB:) userInfo:nil repeats:YES];
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(methodB:)
                                           userInfo:nil
                                            repeats:YES];

          
            SubstatusListArray = [[NSMutableArray alloc]init];
            SubstatusListArray =[ContentDictinary objectForKey:@"SubstatusList"];
            self.shipmentidlabel.text =[NSString stringWithFormat:@"ShipmentId:%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ShipmentId"]];
            self.fromaddress.text =[NSString stringWithFormat:@"Reference :%@,%@,%@,%@,%@,%@",[ContentDictinary objectForKey:@"PickupLocationName"],[ContentDictinary objectForKey:@"PickupAddress1"],[ContentDictinary objectForKey:@"PickupCity"],[ContentDictinary objectForKey:@"PickupCountry"],[ContentDictinary objectForKey:@"PickupState"],[ContentDictinary objectForKey:@"PickupZip"]] ;
            self.fromaddrsdatelbl.text = [ContentDictinary objectForKey:@"PickupScheduledDate"];
            self.fromtimelabel.text = [ContentDictinary objectForKey:@"PickupScheduledTime"];
            
            self.toaddresslabel.text=[NSString stringWithFormat:@"Reference :%@,%@,%@,%@,%@,%@,%@",[ContentDictinary objectForKey:@"DeliveryLocationName"],[ContentDictinary objectForKey:@"DeliveryAddress1"],[ContentDictinary objectForKey:@"DeliveryAddress2"],[ContentDictinary objectForKey:@"DeliveryCity"],[ContentDictinary objectForKey:@"DeliveryCountry"],[ContentDictinary objectForKey:@"DeliveryState"],[ContentDictinary objectForKey:@"DeliveryZip"]] ;
            self.Totimelabel.text = [ContentDictinary objectForKey:@"DeliveryScheduledTime"];
            self.Todatelabel.text = [ContentDictinary objectForKey:@"DeliveryScheduledDate"];
            
            NSString *Picuplatiude = [ContentDictinary objectForKey:@"PickupLocLat"];
            NSString *picuplongitude = [ContentDictinary objectForKey:@"PickupLocLng"];
            NSString *AcknowledgeLat = [ContentDictinary objectForKey:@"AcknowledgeLat"];
            NSString *Acknowledgelng = [ContentDictinary objectForKey:@"Acknowledgelng"];
  
            NSString *DeliveryLocLat = [ContentDictinary objectForKey:@"DeliveryLocLat"];
            NSString *DeliveryLocLng = [ContentDictinary objectForKey:@"DeliveryLocLng"];


            
           NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:Picuplatiude forKey:@"PickupLocLat"];
            [defaults setObject:picuplongitude forKey:@"PickupLocLng"];
            [defaults setObject:AcknowledgeLat forKey:@"AcknowledgeLat"];
            [defaults setObject:Acknowledgelng forKey:@"Acknowledgelng"];
            [defaults setObject:DeliveryLocLat forKey:@"DeliveryLocLat"];
            [defaults setObject:DeliveryLocLng forKey:@"DeliveryLocLng"];

            

            
            
            
            [defaults synchronize];
            

            
            [self getcurrentlocationlatitudelongitude];
            
            NSMutableArray *StopArray = [[NSMutableArray alloc]init];
            StopArray =[ContentDictinary objectForKey:@"Stops"];
            NSInteger countval = StopArray.count;
            
            
            
            if (countval ==0) {
                [self.stopviewHeight setConstant:0];
                [self.scrollview setContentSize:(CGSizeMake(320, 567))];
//
                
            }
          else  if ([[[StopArray objectAtIndex:0]valueForKey:@"DeliveryLocationName"]isEqualToString:@""]&&[[[StopArray objectAtIndex:0]valueForKey:@"DeliveryAddress2"]isEqualToString:@""]&&[[[StopArray objectAtIndex:0]valueForKey:@"DeliveryAddress2"]isEqualToString:@""]&&[[[StopArray objectAtIndex:0]valueForKey:@"DeliveryAddress1"]isEqualToString:@""]) {
              [self.stopviewHeight setConstant:0];
              [self.scrollview setContentSize:(CGSizeMake(320, 567))];
              
            }else
                
            {
            [self.stopviewHeight setConstant:135];
                

            
            self.stopcount.text =[NSString stringWithFormat:@"Stop : 1 of%ld",(long)countval];
             self.stopAddreslabel.text=[NSString stringWithFormat:@"STOP :%@,%@,%@,%@,%@,%@",[[StopArray objectAtIndex:0]valueForKey:@"DeliveryLocationName"],[[StopArray objectAtIndex:0]valueForKey:@"DeliveryAddress2"],[[StopArray objectAtIndex:0]valueForKey:@"DeliveryAddress1"],[[StopArray objectAtIndex:0]valueForKey:@"DeliveryCity"],[[StopArray objectAtIndex:0]valueForKey:@"DeliveryCountry"],[[StopArray objectAtIndex:0]valueForKey:@"DeliveryState"]] ;
             self.stopTimelabel.text = [[StopArray objectAtIndex:0]valueForKey:@"DeliveryScheduledTime"];
             self.Stopdatelabel.text = [[StopArray objectAtIndex:0]valueForKey:@"DeliveryScheduledDate"];
                
                
                
                
                

                
            }


            
            [self  sendingcoordinatesTOdb];

            [self  currlentLocationwithlatlongsent];
            
         

            
            [SVProgressHUD dismiss];
            
            
            
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}

-(void)GoogleAPIdistence:(CLLocation *)fromlocation tolocation:(CLLocation *)tolocation

{
    NSString *fromlatitude =[NSString stringWithFormat:@"%f",fromlocation.coordinate.latitude];
    NSString *fromlongitude =[NSString stringWithFormat:@"%f",fromlocation.coordinate.longitude];
    NSString *Tolatitude =[NSString stringWithFormat:@"%f",tolocation.coordinate.latitude];
    NSString *Tolongitude =[NSString stringWithFormat:@"%f",tolocation.coordinate.longitude];

    
//https://maps.googleapis.com/maps/api/directions/json?origin=22.73931300,75.89195600&destination=22.74290400%2C75.89317200

    
    NSString *urlstring =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@,%@&destination=%@,%@",fromlatitude,fromlongitude,Tolatitude,Tolongitude];
    NSLog(@"urlstroin::%@",urlstring);

   // NSString *urlPath = [NSString stringWithFormat:@"/maps/api/distancematrix/json?origins=%@&destinations=%@&mode=driving&language=en-EN&sensor=false" ,fromlocation,tolocation];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // optionally update the UI to say 'done'
                               if (!error) {
                                   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                                   NSArray *routearry =jsonDict[@"routes"];
                                   // NSString  *distencestring =distencedict[@"routes"];
                                   NSLog(@"distence::%@",routearry);
                                   
                                  
                                   NSDictionary *distanceDict =[[[[routearry objectAtIndex:0]objectForKey:@"legs"]objectAtIndex:0]objectForKey:@"distance"];
                                   
                                   NSLog(@"distncedict is::%@",distanceDict);
                                   NSString *distence =[distanceDict objectForKey:@"text"];
                                   NSLog(@"distncedict is::%@",distence);
                                   
                                   
                                   
                                 
                                   NSLog(@"distance:%@",[distanceDict valueForKey:@"text"]);
                                   if ([[NSUserDefaults standardUserDefaults] boolForKey:@"onsitloading"]==YES) {
                                       NSString *distencemiles =[distanceDict valueForKey:@"text"];
                                       
                                       NSArray *tempArray = [distencemiles componentsSeparatedByString:@" "];
                                       NSString *traveld =[tempArray objectAtIndex:0];
                                       NSString *travelledtype =[tempArray objectAtIndex:1];
                                       if ([travelledtype isEqualToString:@"km"]) {
                                           
                                           double travel =[traveld doubleValue] * 0.000621371;
                                           NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", travel];

                                           self.milesremainglabel.text =[NSString stringWithFormat:@"%@",formattedNumber];

                                           
                                       }

                                       else if ([travelledtype isEqualToString:@"m"])
                                       {
                                           
                                       }

                                       
                                       
  
                                   }
                                   
                                   // update the UI here (and only here to the extent it depends on the json)
                               } else {
                                   // update the UI to indicate error
                               }
                           }];
   
    
   // NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    // address.text = [distanceDict valueForKey:@"text"];

    
}

-(void)timeintervalApicall

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSDictionary *params =[[NSDictionary alloc]initWithObjectsAndKeys:[self.dictnarydata objectForKey:@"LoadID"],@"LoadID",nil];
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetIntravel?" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
         valtimer =[[responseObject objectForKey:@"Intravel"] intValue];
        
         x = valtimer / 1000;
        

        
        NSTimer *myTimerName;
        
        
        
       
        myTimerName = [NSTimer scheduledTimerWithTimeInterval: kRefreshTimeInSeconds
                                                       target:self
                                                     selector:@selector(handleTimer:)
                                                     userInfo:nil
                                                      repeats:YES];
      //  [self getapidata];


    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}
- (void)handleTimer:(NSTimer *)timer
{
    
    
       int valueis =x --;
 //   NSLog(@"valueis::%d",valueis);
  
    if (valueis ==0) {
        [self getcurrentlocationlatitudelongitude];
        
    }
    
    
    
    
    
}
-(void)sendingcoordinatesTOdb

{
    
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   // loadID=209&ShipmentId=100135&Latitude=13.068973999999999&Longitude=80.2176144
    NSDictionary *params =[[NSDictionary alloc]initWithObjectsAndKeys:[ContentDictinary objectForKey:@"LoadID"],@"loadID",[self.dictnarydata objectForKey:@"ShipmentId"],@"ShipmentId",[NSString stringWithFormat:@"%F",latvalue],@"Latitude",[NSString stringWithFormat:@"%F",lngvalue],@"Longitude",nil];
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/SendCordinates?" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
}
-(void)currlentLocationwithlatlongsent

{
  
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",latvalue],@"CLatitude",[NSString stringWithFormat:@"%f",lngvalue],@"CLongitude" ,[ContentDictinary objectForKey:@"DeliveryLocLat"],@"DLatitude",[ContentDictinary objectForKey:@"DeliveryLocLng"],@"DLongitude",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetTimeandMilesRemaining?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        NSString *distence =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Distance"]];
        if (distence.length!=0&& ![distence isEqualToString:@"<null>"]) {
             self.milesremainglabel.text =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Distance"]];
        }
       
        
        NSString * string =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"Duration"]];
        if (string.length!=0 && ![string isEqualToString:@"<null>"]){
            self.drivetimeremainglbl.text =[string substringWithRange:NSMakeRange(3, [string length]-3)];
        }
        
        NSString *picuplatitude =[ContentDictinary objectForKey:@"PickupLocLat"];
        NSString *picuplongitude =[ContentDictinary objectForKey:@"PickupLocLng"];
        NSString *delevarylat =[ContentDictinary objectForKey:@"DeliveryLocLat"];
        NSString *delevarylng =[ContentDictinary objectForKey:@"DeliveryLocLng"];

        CLLocation *picuplocatation = [[CLLocation alloc] initWithLatitude:[picuplatitude doubleValue] longitude:[picuplongitude doubleValue]];
        
        CLLocation *deleverylocation = [[CLLocation alloc] initWithLatitude:[delevarylat doubleValue] longitude:[delevarylng doubleValue]];
        
        CLLocationDistance distance = [picuplocatation distanceFromLocation:deleverylocation];
       // double remaingdistence =distance - [[responseObject objectForKey:@"Distance"] doubleValue];
       // self.milestravelledlabel.text =[NSString stringWithFormat:@"%f",remaingdistence];
        

        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    
    //NSUserDefaults *defults =[NSUserDefaults standardUserDefaults];
    
   // [defaults setObject:latitude forKey:@"starLatitude"];
    //[defaults setObject:longitude forKey:@"starLongitude"];
   // NSString *lat =[defults objectForKey:@"starLatitude"];
  //  NSString *lng =[defults objectForKey:@"starLongitude"];
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/600;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue];
    
}

-(void)intransistitcallApi

{


    
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *loadid = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoadID"];
    
    // NSString *loadid =[NSString stringWithFormat:@"%@",[NSUserDefaults standardUserDefaults]]
    
    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:@"11",@"StatusId",loadid,@"LoadID",@"0",@"Delivery",[NSString stringWithFormat:@"%f",latvalue],@"Latitude",[NSString stringWithFormat:@"%f",lngvalue],@"Longitude",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverMainStatus?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"inTransist"];
        
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
 
    
    
    
}

-(void)onsiteloadingApiCalling

{
    
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   NSString *loadid = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoadID"];
    
   // NSString *loadid =[NSString stringWithFormat:@"%@",[NSUserDefaults standardUserDefaults]]

    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:@"12",@"StatusId",loadid,@"LoadID",@"0",@"Delivery",[NSString stringWithFormat:@"%f",latvalue],@"Latitude",[NSString stringWithFormat:@"%f",lngvalue],@"Longitude",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverMainStatus?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *contentdict = [responseObject objectForKey:@"content"];
        id LateVarienceArray =[contentdict objectForKey:@"LateVarience"];
        if ( LateVarienceArray !=(id)[NSNull null]) {
            NSDictionary *delevery0 =[LateVarienceArray objectAtIndex:0];
            
            NSDictionary *delevery1 =[LateVarienceArray objectAtIndex:1];
            
            
            
            NSString *ontimestring =[delevery0 objectForKey:@"OnTimeorLate"];
            NSString *Totimestring =[delevery1 objectForKey:@"OnTimeorLate"];

            if ([ontimestring isEqualToString:@"Late"])
            {
                self.ontimeLabel.textColor =[UIColor redColor];
                self.ontimeLabel.text =ontimestring;
                [self.ontimeLabel setHidden:NO];
                
                
                
                
            }if ([Totimestring isEqualToString:@"Late"]) {
                [self.ToOntimelabrl setHidden:NO];
                self.ToOntimelabrl.textColor =[UIColor redColor];
                self.ToOntimelabrl.text =Totimestring;

            }

        }
        else
        {
            
            
            [self.ontimeLabel setHidden:YES];
            [self.ToOntimelabrl setHidden:YES];
            
        }
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    
    
    
}


-(void)onsiteloadConfromation

{
    
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    double confromlatitude = coordinate.latitude;
     double confromlongitude =  coordinate.longitude;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:@"13",@"StatusId",confromlatitude,@"Latitude",confromlongitude,@"Longitude",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/OnsiteConfirmPickup?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    
}

-(void)onsiteUnloadingApi

{
    
    [TOconformationbutton setHidden:YES];
    
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *loadid = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoadID"];
    
    // NSString *loadid =[NSString stringWithFormat:@"%@",[NSUserDefaults standardUserDefaults]]
    
    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:@"13",@"StatusId",loadid,@"LoadID",@"0",@"Delivery",[NSString stringWithFormat:@"%f",latvalue],@"Latitude",[NSString stringWithFormat:@"%f",lngvalue],@"Longitude",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverMainStatus?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"onsiteunloading"];
        
        [TOconformationbutton setHidden:YES];
        
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [TOconformationbutton setHidden:NO];

    }];
    

    
    
    
}
-(void)ontimeDisplaylateorEarly

{
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
       latvalue =  currentLocation.coordinate.longitude;
        lngvalue =  currentLocation.coordinate.latitude;
        [locationManager stopUpdatingLocation];
        
       // NSUserDefaults *defults =[NSUserDefaults standardUserDefaults];
        
      //  [defaults setObject:[ContentDictinary objectForKey:@"PickupLocLat"] forKey:@"PickupLat"];
       // [defaults setObject:[ContentDictinary objectForKey:@"PickupLocLng"] forKey:@"PickupLng"];
        
   //     double lat =[[defults valueForKey:@"PickupLocLat"] doubleValue];
   //     double  lng =[[defults valueForKey:@"PickupLocLng"] doubleValue];
        
       }
}

-(void)getcurrentlocationlatitudelongitude

{
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
  latvalue = coordinate.latitude;
   lngvalue =  coordinate.longitude;
   // CLLocation *current = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    NSLog(@"%f%f",latvalue,lngvalue);
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *piclat =[defaults valueForKey:@"PickupLocLat"];
    NSString *piclng =[defaults valueForKey:@"PickupLocLng"];
    NSLog(@"picuplatlng%@,%@",piclat,piclng);
    double picuplat =[piclat doubleValue];
    double picuplng =[piclng doubleValue];

    
    
    CLLocation *fromlocation =[[CLLocation alloc]initWithLatitude:latvalue longitude:lngvalue];
    
    
    CLLocation *tolocation =[[CLLocation alloc]initWithLatitude:picuplat longitude:picuplng];
    NSLog(@"Tolocationis::%@",tolocation);
    double delvierylatitude =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeliveryLocLat"]] doubleValue];
     double delvierylongitutude =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeliveryLocLng"]] doubleValue];
    
    NSLog(@"deleverylocationlatlong:%F,%F",delvierylatitude,delvierylongitutude);
    
    CLLocation *delverylocation =[[CLLocation alloc]initWithLatitude:delvierylatitude longitude:delvierylongitutude];

   // [self GoogleAPIdistence:fromlocation tolocation:tolocation];

    CLLocationDistance delveryloationdistence =[fromlocation distanceFromLocation:delverylocation];
    
    CLLocationDistance itemDist = [fromlocation distanceFromLocation:tolocation];
    NSLog(@"itemdistence::%f",itemDist);
    
    float feet= itemDist  *3.280;
    float delveryfeet = delveryloationdistence  *3.280;
    NSLog(@"feetis::%f",feet);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"onsitloading"]==YES) {
        [self GoogleAPIdistence:tolocation tolocation:fromlocation];
        
    }
    
    
    if (feet <= 600) {
        NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
        self.intransistlabel.text = substatus;
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"onsitloading"]) {
            [self onsiteloadingApiCalling];
            //  self.intransistlabel.text =@"";
            [self GoogleAPIdistence:fromlocation tolocation:tolocation];

        }
        
        NSLog(@"substatusis::%@",substatus);
        if ([substatus isEqualToString:@"Onsite Loading(Confirmed)"]||[substatus isEqualToString:@"In Transit()"]) {
            [Fromconformationbutton setHidden:YES];
           // self.intransistlabel.text =@"Onsite Loading(Confirmed)";
            

            
        }
        
    }
    else if (feet >= 2640)
        
    {

        
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"inTransist"]) {
            [self intransistitcallApi];
            // [Stopconformationbutton setHidden:NO];
            NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
            
            NSLog(@"substatusis::%@",substatus);

            if (![substatus isEqualToString:@"InTransit()"]) {
                [Fromconformationbutton setHidden:NO];
                
            }else
            {
                [TOconformationbutton setHidden:YES];
                [Fromconformationbutton setHidden:YES];
                [Stopconformationbutton setHidden:YES];
            }

        }
       
       
    }
    NSLog(@"datais::%f",delveryfeet);
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"fromOnsiteLoadingClicked"] ==YES) {
        if (delveryfeet <= 660)
        
        {
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"onsiteunloading"]) {
                [self GoogleAPIdistence:fromlocation tolocation:delverylocation];

                [self onsiteUnloadingApi];
                [TOconformationbutton setHidden:NO];

                
            }else
            {
                [TOconformationbutton setHidden:YES];
   
                
            }
            
            

            
            
        }
        else if (delveryfeet >= 2640)
        
        {
              if (![[NSUserDefaults standardUserDefaults]boolForKey:@"inTransist"]) {
                  [self GoogleAPIdistence:fromlocation tolocation:delverylocation];

            [self intransistitcallApi];
            NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
            self.intransistlabel.text = substatus;
              }
            
        }

    }
    
     }


- (IBAction)poduploadingviewAction:(id)sender {
    [self performSegueWithIdentifier:@"podfileuploading" sender:self];
    
}
-(void)travllingDistencefinding

{
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
     CLLocation *location = [locationManager location];
      CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    // CLLocation *current = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *acklat =[defaults valueForKey:@"AcknowledgeLat"];
    NSString *acklng =[defaults valueForKey:@"Acknowledgelng"];
    NSLog(@"picuplatlng%@,%@",acklat,acklng);
    double acknolegmentlatitude =[acklat doubleValue];
    double acknoledgementlongitude =[acklng doubleValue];
    
    double PickupLocLat =[[defaults valueForKey:@"PickupLocLat"] doubleValue];
   double PickupLocLng  =[[defaults valueForKey:@"PickupLocLng"] doubleValue];
    
        CLLocation *acklocation =[[CLLocation alloc]initWithLatitude:acknolegmentlatitude longitude:acknoledgementlongitude];
    
    CLLocation *currentlocation =[[CLLocation alloc]initWithLatitude:latvalue longitude:lngvalue];
    CLLocation *picuplocation =[[CLLocation alloc]initWithLatitude:PickupLocLat longitude:PickupLocLng];
    
    [self currlentLocationwithlatlongsent];
    
    
    CLLocationDistance travelddistnce = [currentlocation distanceFromLocation:picuplocation];
    CLLocationDistance remaingmilesdistence = [acklocation distanceFromLocation:currentlocation];

  //[self dstenceCallingApi: currentlocation toloaction:picuplocation];
    int trdistence =[[NSString stringWithFormat:@"%f",travelddistnce] intValue];
//
    if (trdistence<=660) {
        
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(trdistence/1609.344)]);
        self.milestravelledlabel.text=[NSString stringWithFormat:@"%f",(trdistence/1609.344)];
        self.milesremainglabel.text =[NSString stringWithFormat:@"%f",(remaingmilesdistence/1609.344)];
        

        
    }
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark buttonactions

#pragma mark TableviewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SubstatusListArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellidentifier";
    
    UITableViewCell *cell = [self.dropdowntable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }    // Set up the cell...
    cell.textLabel.text = [[SubstatusListArray objectAtIndex:indexPath.row]valueForKey:@"SubStatusName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.dispatchedBtn setHidden:YES];
    
    
    transistlabel.text = [NSString stringWithFormat:@"IN TRANSIT [%@]",[[SubstatusListArray objectAtIndex:indexPath.row]valueForKey:@"SubStatusName"]];
    [deletebutton setHidden:NO];
    
    
    substatusID = [NSString stringWithFormat:@"%@",[[SubstatusListArray objectAtIndex:indexPath.row]valueForKey:@"Id"]];
    NSLog(@"substatusID:%@",substatusID);
    [self.dropdowntable setHidden:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:substatusID,@"StatusId",[ContentDictinary objectForKey:@"LoadID"],@"LoadID",@"0",@"Delivery",nil];
    NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverSubStatus?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
  //  [self intransistitcallApi];
    
    

}

- (void) methodB:(NSTimer *)timer
{
    
Timerval --;
    
    if (Timerval == 0)
    
    {
        Timerval =30;
        NSLog(@"contentDict::%@",ContentDictinary);
        //        https://maps.googleapis.com/maps/api/distancematrix/json?origins=Vancouver+BC|Seattle&destinations=San+Francisco|Victoria+BC&mode=bicycling&language=fr-FR&key=YOUR_API_KEY
        NSString *OnsiteLoadingstring =[NSString stringWithFormat:@"%@",[[ContentDictinary objectForKey:@"GeoFenceData"]objectForKey:@"OnsiteLoading"]];
        
        if ([OnsiteLoadingstring isEqualToString:@"0"]) {
            [self travllingDistencefinding];
            locationManager =[[CLLocationManager alloc]init];
            
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
            
            [locationManager startUpdatingLocation];
            
            
            
            CLLocation *location = [locationManager location];
            
            
            CLLocationCoordinate2D coordinate = [location coordinate];
            
            
            latvalue = coordinate.latitude;
            lngvalue =  coordinate.longitude;
            // CLLocation *current = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            NSLog(@"%f%f",latvalue,lngvalue);
            
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *piclat =[defaults valueForKey:@"PickupLocLat"];
            NSString *piclng =[defaults valueForKey:@"PickupLocLng"];
            NSLog(@"picuplatlng%@,%@",piclat,piclng);
            double picuplat =[piclat doubleValue];
            double picuplng =[piclng doubleValue];
            
            
            
            CLLocation *fromlocation =[[CLLocation alloc]initWithLatitude:latvalue longitude:lngvalue];
            
            
            CLLocation *tolocation =[[CLLocation alloc]initWithLatitude:picuplat longitude:picuplng];
            NSLog(@"Tolocationis::%@",tolocation);
            double delvierylatitude =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeliveryLocLat"]] doubleValue];
            double delvierylongitutude =[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DeliveryLocLng"]] doubleValue];
            
            NSLog(@"deleverylocationlatlong:%F,%F",delvierylatitude,delvierylongitutude);
            
            CLLocation *delverylocation =[[CLLocation alloc]initWithLatitude:delvierylatitude longitude:delvierylongitutude];
            
            // [self GoogleAPIdistence:fromlocation tolocation:tolocation];
            
            CLLocationDistance delveryloationdistence =[fromlocation distanceFromLocation:delverylocation];
            
            CLLocationDistance itemDist = [fromlocation distanceFromLocation:tolocation];
            NSLog(@"itemdistence::%f",itemDist);
            
            float feet= itemDist  *3.280;
            float delveryfeet = delveryloationdistence  *3.280;
            NSLog(@"feetis::%f",feet);
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"onsitloading"]==YES) {
                [self GoogleAPIdistence:tolocation tolocation:fromlocation];
                
            }
            
            
            if (feet <= 600) {
                NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
                self.intransistlabel.text = substatus;
                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"onsitloading"]) {
                    [self onsiteloadingApiCalling];
                    //  self.intransistlabel.text =@"";
                    [self GoogleAPIdistence:fromlocation tolocation:tolocation];
                    
                }
                
                NSLog(@"substatusis::%@",substatus);
                if ([substatus isEqualToString:@"Onsite Loading(Confirmed)"]||[substatus isEqualToString:@"In Transit()"]) {
                    [Fromconformationbutton setHidden:YES];
                    // self.intransistlabel.text =@"Onsite Loading(Confirmed)";
                    
                    
                    
                }
                
            }
            else if (feet >= 2640)
                
            {
                
                
                if (![[NSUserDefaults standardUserDefaults]boolForKey:@"inTransist"]) {
                    [self intransistitcallApi];
                    // [Stopconformationbutton setHidden:NO];
                    NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
                    
                    NSLog(@"substatusis::%@",substatus);
                    
                    if (![substatus isEqualToString:@"InTransit()"]) {
                        [Fromconformationbutton setHidden:NO];
                        
                    }else
                    {
                        [TOconformationbutton setHidden:YES];
                        [Fromconformationbutton setHidden:YES];
                        [Stopconformationbutton setHidden:YES];
                    }
                    
                }
                
                
            }
            NSLog(@"datais::%f",delveryfeet);
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"fromOnsiteLoadingClicked"] ==YES) {
                if (delveryfeet <= 660)
                    
                {
                    
                    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"onsiteunloading"]) {
                        [self GoogleAPIdistence:fromlocation tolocation:delverylocation];
                        
                        [self onsiteUnloadingApi];
                        [TOconformationbutton setHidden:NO];
                        
                        
                    }else
                    {
                        [TOconformationbutton setHidden:YES];
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                else if (delveryfeet >= 2640)
                    
                {
                    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"inTransist"]) {
                        [self GoogleAPIdistence:fromlocation tolocation:delverylocation];
                        
                        [self intransistitcallApi];
                        NSString *substatus = [NSString stringWithFormat:@"%@(%@)",[self.dictnarydata valueForKey:@"MainStatus"],[self.dictnarydata valueForKey:@"Substatus"]];
                        self.intransistlabel.text = substatus;
                    }
                    
                }
                
            }

            
        }
        
        
        
    }
    
}

#pragma mark button actions
- (IBAction)selectClicked:(id)sender {
    self.dropdowntable.layer.cornerRadius = 5;
    if (tableshow == YES) {
        [self.dropdowntable setHidden:NO];
        tableshow =NO;
    }
    else if (tableshow ==NO)
    
    {
        [self.dropdowntable setHidden:YES];
        tableshow =YES;
    }
    NSLog(@"substatus::%@",SubstatusListArray);
    [self.dropdowntable reloadData];
}
- (IBAction)onsiteconformationAction:(id)sender
{
    locationManager =[[CLLocationManager alloc]init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    [Fromconformationbutton setHidden:YES];
    
    
    
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    
    //onsiteConfromation
    if ([sender tag] == 10)
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        ;
        NSString *loadid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoadID"]];
        NSString *ShipmentId= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:@"ShipmentId"]];
        
        NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:loadid,@"LoadID",ShipmentId,@"ShipmentId",[NSString stringWithFormat:@"%f",latvalue],@"Latitude",[NSString stringWithFormat:@"%f",lngvalue],@"Longitude",nil];
        NSLog(@"params: %@", parameterdata);
        
        [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/OnsiteConfirmPickup?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            self.intransistlabel.text =[responseObject objectForKey:@"message"];
           [ [NSUserDefaults standardUserDefaults]setBool:YES forKey:@"onsitloading"];
            
            [Fromconformationbutton setHidden:YES];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"fromOnsiteLoadingClicked"];
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            picupstatusclicked =NO;

        }];
        
        
    }
    //onsiteunloading confromation
    else if([sender tag] == 12)
    {
        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        ;
        NSString *loadid =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoadID"]];
        NSString *ShipmentId= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults ]objectForKey:@"ShipmentId"]];
        
        NSDictionary *parameter =[[NSDictionary alloc]initWithObjectsAndKeys:loadid,@"LoadID",ShipmentId,@"ShipmentId",[NSString stringWithFormat:@"%f",latvalue],@"Latitude",[NSString stringWithFormat:@"%f",lngvalue],@"Longitude",nil];
        NSLog(@"params: %@", parameter);
        
        [manage GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/OnsiteUnloadConfirmPickup?" parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
             self.intransistlabel.text =[responseObject objectForKey:@"message"];
            [TOconformationbutton setHidden:YES];
            
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
    }
    else if([sender tag] == 11)
    {
        
        
    }
    
}

- (IBAction)ToaddressAction:(id)sender {
    NSString *toAddress = self.toaddresslabel.text;
    NSLog(@"toaddrees is::%@",toAddress);
    
    
}
- (IBAction)StopCopyaddresAction:(id)sender {
}

- (IBAction)popview:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TracerViewController *myNewVC = (TracerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TracerViewController"];
    [self.navigationController pushViewController:myNewVC animated:YES];
}

- (IBAction)fomcopyaddrsaction:(id)sender {
    
    NSString *copyfrom =self.fromaddress.text;
    NSLog(@"copyfromaddress::%@",copyfrom);
    
}


-(IBAction)dispatchupdate:(id)sender
{
    if ([sender tag] ==20) {
        NSLog(@"substatusID:%@",substatusID);
        [self.dropdowntable setHidden:YES];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"StatusId",[ContentDictinary objectForKey:@"LoadID"],@"LoadID",@"0",@"Delivery",nil];
        NSLog(@"params: %@", parameterdata);
        
        [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverSubStatus?" parameters:parameterdata progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [deletebutton setHidden:YES];
        transistlabel.text =@" IN ITRANSIST";
        
        
    }
    
    
}



#pragma mark segue actions
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"podfileuploading"]) {
        
        PodPageViewController *destinationview =[segue destinationViewController];
        destinationview.imagedictinary = ContentDictinary;
        
        
    }
   
    
    
}



#pragma mark Radiusbuttons
-(void)getshadowview:(UIView *)myView

{
    myView.layer.cornerRadius = 5;
    myView.layer.shadowColor = [UIColor blackColor].CGColor;
    myView.layer.shadowOffset = CGSizeMake(0.5, 4.0); //Here your control your spread
    myView.layer.shadowOpacity = 0.5;
    myView.layer.shadowRadius = 5.0;
}
-(void)cornerradiusButton:(UIButton *)addressbtn

{
    addressbtn.layer.cornerRadius=addressbtn.frame.size.width/2;
    addressbtn.layer.borderColor=[UIColor blackColor].CGColor;
    
    addressbtn.layer.cornerRadius =11.0;
    
}


@end
