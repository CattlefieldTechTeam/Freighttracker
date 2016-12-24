//
//  DetailVC.m
//  FreightTracer
//
//  Created by Animesh Jana on 18/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import "DetailVC.h"
#import "Detailcell.h"
#import "substatuscell.h"
#import "Detaillist.h"
#import "Latevariancelist.h"
#import "Stoplist.h"
#import "PodPageViewController.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    
    flag=0;
    flag1=0;
    flag2=0;
    pod=0;
    delpod=0;

    // Do any additional setup after loading the view.
    self.arrloadlist=[NSMutableArray array];
     self.arrlatelist=[NSMutableArray array];
    self.arrstoplist=[NSMutableArray array];

    _btn_podupload.layer.cornerRadius=8.0f;
    _cancel_img.hidden=TRUE;
    numberofrows=0;
     row=0;
    shipmentdetails = [[Common SharedInstance] getValueForKey:SelectedId];
    _shipment_number.text=[NSString stringWithFormat:@"Shipment Id:%@",[shipmentdetails valueForKey:@"ShipmentId"]];
    if ([[shipmentdetails valueForKey:@"Substatus"]isEqualToString:@""]) {
        _status.text=[NSString stringWithFormat:@"%@",[shipmentdetails valueForKey:@"MainStatus"]];
    } else {
        _status.text=[NSString stringWithFormat:@"%@(%@)",[shipmentdetails valueForKey:@"MainStatus"],[shipmentdetails valueForKey:@"Substatus"]];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(table_data_show:)];
    tap.numberOfTapsRequired=1;
    tap.delegate=self;
    [_alert_break addGestureRecognizer:tap];
    
    UITapGestureRecognizer *cancel_tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel_img_tap:)];
    cancel_tap.numberOfTapsRequired=1;
    cancel_tap.delegate=self;
    [_cancel_img setUserInteractionEnabled:YES];

    [_cancel_img addGestureRecognizer:cancel_tap];
    
    [_btn_podupload addTarget:self action:@selector(podupload) forControlEvents:UIControlEventTouchUpInside];
    

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net/Service1.svc/GetLoadData?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        // NSLog(@"JSON: %@", responseObject);
        
        [SVProgressHUD dismiss];
        NSDictionary *json = (NSDictionary* )responseObject;
        content=[json objectForKey:@"content"];
        SubstatusList=(NSMutableArray*)[content objectForKey:@"SubstatusList"];
        Stops=(NSMutableArray*)[content objectForKey:@"Stops"];
        Latevariance=(NSMutableArray*)[content objectForKey:@"LateVarience"];
        
        for (int i=0; i<[SubstatusList count]; i++) {
            NSMutableDictionary *dictValues = [SubstatusList objectAtIndex:i];
            
            Detaillist *mDetaillist = [[Detaillist alloc] init];
            mDetaillist.substatus=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"SubStatusName"]];
            // NSLog(@"%@",[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"SubStatusName"]]);
            [_arrloadlist addObject:mDetaillist];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tbl_vw reloadData];
            });
        }
        for (int j=0; j<[Latevariance count]; j++) {
            NSMutableDictionary *dictValues = [Latevariance objectAtIndex:j];
            NSLog(@"Latevariance: %@", [Latevariance objectAtIndex:j]);

            Latevariancelist *mLatevariancelist = [[Latevariancelist alloc] init];
            mLatevariancelist.OnTimeorLate=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"OnTimeorLate"]];
            mLatevariancelist.Status=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"Status"]];
            [_arrlatelist addObject:mLatevariancelist];
            
        }
        for (int k=0; k<[Stops count]; k++) {
            NSMutableDictionary *dictValues = [Stops objectAtIndex:k];
            
            Stoplist *mStoplist = [[Stoplist alloc] init];
            mStoplist.DeliveryAddress1=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryAddress1"]];
            mStoplist.DeliveryAddress2=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryAddress2"]];
            mStoplist.DeliveryCity=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryCity"]];
            mStoplist.DeliveryCountry=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryCountry"]];
            mStoplist.DeliveryScheduledDate=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryScheduledDate"]];
            mStoplist.DeliveryScheduledTime=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryScheduledTime"]];
            mStoplist.Stoplocationname=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"DeliveryLocationName"]];
            [_arrstoplist addObject:mStoplist];
            
            
        }

        
        numberofrows= [Stops count]+2;

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            row=0;
            [tbl_data reloadData];
        });
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    
    NSTimeInterval time = 15.0f;
               self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                target:self
                                              selector:@selector(updateLocation)
                                               userInfo:nil
                                                repeats:YES];
    
    
}

-(void)updateLocation {
    
    [self getcurrentlocationlatitudelongitude];

   
    //f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetTimeandMilesRemaining?CLatitude=13.068973999999999&CLongitude=80.2176144&DLatitude=13.0082211&DLongitude=80.21257480000001
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/GetTimeandMilesRemaining?" parameters:@{@"CLatitude":latvalue,@"CLongitude":lngvalue,@"DLatitude":[content objectForKey:@"PickupLocLat"],@"DLongitude":[content objectForKey:@"PickupLocLng"]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *json = (NSDictionary* )responseObject;
        
        if ([[json objectForKey:@"Duration"]  isEqual:@""] || [[json objectForKey:@"Duration"]  isEqual:@"NSNull"])
        {
            
            _driveremaining_txt.text=@"0";
            
        }
        else
        {
            _driveremaining_txt.text=[json objectForKey:@"Duration"];
        }

        if ([[json objectForKey:@"Distance"]  isEqual:@""] || [[json objectForKey:@"Distance"]  isEqual:@"NSNull"])
        {
            
             _milesremaining_txt.text=@"0";
            
        }
        else
        {
             _milesremaining_txt.text=[json objectForKey:@"Distance"];
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
    
    NSMutableDictionary*dict=[Stops objectAtIndex:0];

    
    double picklat= [[content objectForKey:@"PickupLocLat"] doubleValue ];
    double picklon = [[content objectForKey:@"PickupLocLng"] doubleValue];
    
    double stoplat= [[dict objectForKey:@"PickupLocLat"] doubleValue ];
    double stoplon = [[dict objectForKey:@"PickupLocLng"] doubleValue];
    
    double dellat= [[content objectForKey:@"DeliveryLocLat"] doubleValue ];
    double dellon = [[content objectForKey:@"DeliveryLocLng"] doubleValue];
    
    
    
    CLLocation *locdriver = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    CLLocation *locpickup = [[CLLocation alloc] initWithLatitude:picklat longitude:picklon];
    CLLocation *locstop = [[CLLocation alloc] initWithLatitude:stoplat longitude:stoplon];
    CLLocation *locdelivery = [[CLLocation alloc] initWithLatitude:dellat longitude:dellon];
    
    

    
    CLLocationDistance distance = [locdriver distanceFromLocation:locpickup];
    CLLocationDistance distance1 = [locdriver distanceFromLocation:locstop];
    CLLocationDistance distance2 = [locdriver distanceFromLocation:locdelivery];
    
    if (distance <=10) {
        flag = 1;
        [tbl_data reloadData];
    }
    else if (distance1 <=10){
        flag1=1;
        [tbl_data reloadData];

    }
    else if (distance2<=10){
        flag2=1;
        [tbl_data reloadData];
        
    }

    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{

    
}

-(IBAction)table_data_show:(id)sender{
    NSLog(@"hitt");
    [UIView animateWithDuration:0.25 animations:^{
        _vw_popup.alpha=1.0;
    } completion:^(BOOL finished) {
        
    }];
}


-(IBAction)cancel_img_tap:(id)sender{
    NSLog(@"JSON");

    _cancel_img.hidden=TRUE;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //        NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:substatusID,@"StatusId",[ContentDictinary objectForKey:@"LoadID"],@"LoadID",@"0",@"Delivery",nil];
    //        NSLog(@"params: %@", parameterdata);
    
    [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/UpdateDriverSubStatus?" parameters:@{@"StatusId":@"0",@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"Delivery":@"0"} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        _status.text=[shipmentdetails valueForKey:@"MainStatus"];
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self->locationManager stopMonitoringForRegion:bridge];
    
    
    double lat= [[content objectForKey:@"PickupLocLat"] doubleValue ];
    double lon = [[content objectForKey:@"PickupLocLng"] doubleValue];
    
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat,lon);
    bridge = [[CLCircularRegion alloc]initWithCenter:center
                                              radius:804.672
                                          identifier:@"Bridge"];
    [self->locationManager startMonitoringForRegion:bridge];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag==1000){
        return 1;
    }
    else{
    return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView.tag==1000){
        return [SubstatusList count];
    }
    
    else{
    switch (section) {
        case 0:{
            return 1;
        }break;
            
        case 1:{
            return [Stops count];
        }break;
            
        case 2:{
            return 1;
        }break;
            
        default:
            return 0;
            break;
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1000){
        return 40;
    }
    else{
    return 140;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==1000){
        substatuscell *cell=[tableView dequeueReusableCellWithIdentifier:@"substatuscell" forIndexPath:indexPath];
        Detaillist *mDetaillist = [_arrloadlist objectAtIndex:indexPath.row];

        cell.item.text=mDetaillist.substatus;
        NSLog(@"status:::%@",mDetaillist.substatus);
        
        return  cell;
        
    }
    else{
        
    Detailcell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detailcell" forIndexPath:indexPath];
        
        Latevariancelist *mLatevariancelist;
        NSLog(@"row::%d",row);
        NSLog(@"numberofrows::%d",numberofrows);
        NSLog(@"Latevariance::%d",Latevariance.count);

        if ((Latevariance.count>0) && (row<numberofrows)) {
           mLatevariancelist = [_arrlatelist objectAtIndex:row];
            row++;
           NSLog(@"row::%d",row);

       }


    switch (indexPath.section) {
        case 0:{

            cell.from_txt.text =[NSString stringWithFormat:@"From:%@",[content objectForKey:@"PickupLocationName"]];
            cell.address.text= [NSString stringWithFormat:@"%@,%@,%@",[content objectForKey:@"PickupAddress1"],[content objectForKey:@"PickupAddress2"],[content objectForKey:@"PickupCity"]];
            cell.date.text= [content objectForKey:@"PickupScheduledDate"];
            cell.time.text= [content objectForKey:@"PickupScheduledTime"];
            if ([mLatevariancelist.Status isEqualToString:@"PickUp"]){
                if ([mLatevariancelist.OnTimeorLate isEqualToString:@"Late"]) {
                    cell.late.textColor=[UIColor redColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
                else{
                    cell.late.textColor=[UIColor greenColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
            }
            
            if (flag == 1) {
                cell.btn_onsite.layer.cornerRadius=8.0f;

                cell.btn_onsite.hidden=FALSE;
                cell.btn_onsite.tag=indexPath.section;
                [cell.btn_onsite addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];


            }else{
                cell.btn_onsite.layer.cornerRadius=8.0f;

                cell.btn_onsite.hidden=TRUE;

            }


        }break;
            
        case 1:{
            Stoplist *mStoplist=[_arrstoplist objectAtIndex:indexPath.row];

            cell.from_txt.text =[NSString stringWithFormat:@"Stop:%@",mStoplist.Stoplocationname];
            cell.address.text=[NSString stringWithFormat:@"%@,%@,%@",mStoplist.DeliveryAddress1,mStoplist.DeliveryAddress2,mStoplist.DeliveryCity];
            cell.date.text=mStoplist.DeliveryScheduledDate;
            cell.time.text=mStoplist.DeliveryScheduledTime;
            
            if ([mLatevariancelist.Status isEqualToString:@"Stop"]){
                if ([mLatevariancelist.OnTimeorLate isEqualToString:@"Late"]) {
                    cell.late.textColor=[UIColor redColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
                else{
                    cell.late.textColor=[UIColor greenColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
            }
            if (flag1 == 1) {
                cell.btn_onsite.layer.cornerRadius=8.0f;

                cell.btn_onsite.hidden=FALSE;
                cell.btn_onsite.tag=indexPath.section;
                [cell.btn_onsite addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];

            }else{
                cell.btn_onsite.layer.cornerRadius=8.0f;

                if (pod==1) {
                    cell.btn_onsite.backgroundColor=[UIColor redColor];
                    [cell.btn_onsite setTitle: @"Pod Upload" forState: UIControlStateNormal];
                    [cell.btn_onsite addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];


                }
                else{
                    cell.btn_onsite.hidden=TRUE;

                }
                
            }
            
        }break;
            
        case 2:{

            cell.from_txt.text =[NSString stringWithFormat:@"To:%@",[content objectForKey:@"DeliveryLocationName"]];
            cell.address.text= [NSString stringWithFormat:@"%@,%@,%@",[content objectForKey:@"DeliveryAddress1"],[content objectForKey:@"DeliveryAddress2"],[content objectForKey:@"DeliveryCity"]];
            cell.date.text= [content objectForKey:@"DeliveryScheduledDate"];
            cell.time.text= [content objectForKey:@"DeliveryScheduledTime"];
            if ([mLatevariancelist.Status isEqualToString:@"Delivery"]){
                if ([mLatevariancelist.OnTimeorLate isEqualToString:@"Late"]) {
                    cell.late.textColor=[UIColor redColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
                else{
                    cell.late.textColor=[UIColor greenColor];
                    cell.late.text=mLatevariancelist.OnTimeorLate;
                }
            }
            if (flag2 == 1) {
                cell.btn_onsite.layer.cornerRadius=8.0f;
                cell.btn_onsite.hidden=FALSE;
                cell.btn_onsite.tag=indexPath.section;
                [cell.btn_onsite addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];


            }else{
                cell.btn_onsite.layer.cornerRadius=8.0f;

                
                if (delpod==1) {
                    cell.btn_onsite.backgroundColor=[UIColor redColor];
                    [cell.btn_onsite setTitle: @"Pod Upload" forState: UIControlStateNormal];
                    [cell.btn_onsite addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];

                    
                }
                else{
                    cell.btn_onsite.hidden=TRUE;
                    
                }
            }

        }break;
            
        default:
            break;
    }

    
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UIView animateWithDuration:0.25 animations:^{
        _vw_popup.alpha=0.0;
    } completion:^(BOOL finished) {
        
    }];

    
    if (tableView.tag==1000) {
        NSMutableDictionary *dictValues = [SubstatusList objectAtIndex:indexPath.row];
        
        NSLog(@"%@",[SubstatusList objectAtIndex:indexPath.row]);

        substatus =[dictValues objectForKey:@"SubStatusName"];
        substatusId =[dictValues objectForKey:@"Id"];

        _status.text=[NSString stringWithFormat:@"%@(%@)",[shipmentdetails valueForKey:@"MainStatus"],[dictValues objectForKey:@"SubStatusName"]];
        _cancel_img.hidden=FALSE;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:substatusID,@"StatusId",[ContentDictinary objectForKey:@"LoadID"],@"LoadID",@"0",@"Delivery",nil];
//        NSLog(@"params: %@", parameterdata);
        
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/UpdateDriverSubStatus?" parameters:@{@"StatusId":[dictValues objectForKey:@"Id"],@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"Delivery":@"0"} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        if ([[dictValues objectForKey:@"SubStatusName"] isEqualToString:@"Onsite Loading"]) {
            [self->locationManager stopMonitoringForRegion:bridge];

            
            double lat= [[content objectForKey:@"PickupLocLat"] doubleValue ];
            double lon = [[content objectForKey:@"PickupLocLng"] doubleValue];


            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat,lon);
            bridge = [[CLCircularRegion alloc]initWithCenter:center
                                                                radius:201.168
                                                            identifier:@"Bridge"];
            [self->locationManager startMonitoringForRegion:bridge];

        
        }
        else if ([[dictValues objectForKey:@"SubStatusName"] isEqualToString:@"Onsite Unloading"]){
            [self->locationManager stopMonitoringForRegion:bridge];

            
            double lat= [[content objectForKey:@"DeliveryLocLat"] doubleValue ];
            double lon = [[content objectForKey:@"DeliveryLocLng"] doubleValue];
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat,lon);
            bridge = [[CLCircularRegion alloc]initWithCenter:center
                                                                radius:201.168
                                                            identifier:@"Bridge"];
            [self->locationManager startMonitoringForRegion:bridge];
            
        }
        
        
        
        
        
        
    }
    else{
        
        
        
        
        
        
    }
    
}


///geofencing



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    ////://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/UpdateDriverMainStatus?LoadID=303&ShipmentID=2009&StatusId=13&Delivery=1&Latitude=13.2525&Longitude=80.2534
    
    if ([substatus isEqualToString:@"Onsite Loading"]) {
    
        NSLog(@"startLocalNotification");
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
        notification.alertBody = @"Entering Onsite Loading";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/UpdateDriverSubStatus?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"StatusId":substatusId,@"Delivery":@"0",@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else if ([substatus isEqualToString:@"Onsite Unloading"]){
        
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
        notification.alertBody = @"Entering Onsite Unloading";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/UpdateDriverSubStatus?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"StatusId":substatusId,@"Delivery":@"1",@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        
    }
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    
    
    if ([_status.text isEqualToString:@"IN TRANSIST"]) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
        notification.alertBody = @"You are outside Half Mile";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/UpdateDriverSubStatus?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"StatusId":substatusId,@"Delivery":@"1",@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];


        
    }

    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    
    NSLog(@"start Monitoring");

    
    
}
- (void)stopMonitoringForRegion:(CLRegion *)region{
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(void)getapidata
//{
//    [SVProgressHUD show];
//
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//   
//    
//    [manager GET:@"http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/GetLoadData?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"]} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//       // NSLog(@"JSON: %@", responseObject);
//    
//            [SVProgressHUD dismiss];
//        NSDictionary *json = (NSDictionary* )responseObject;
//        content=[json objectForKey:@"content"];
//        SubstatusList=[content objectForKey:@"SubstatusList"];
//        Stops=[content objectForKey:@"Stops"];
//        Latevariance=[content objectForKey:@"LateVarience"];
//        
//        for (int i=0; i<[SubstatusList count]; i++) {
//            NSMutableDictionary *dictValues = [SubstatusList objectAtIndex:i];
//            
//            Detaillist *mDetaillist = [[Detaillist alloc] init];
//            mDetaillist.substatus=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"SubStatusName"]];
//           // NSLog(@"%@",[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"SubStatusName"]]);
//            [_arrloadlist addObject:mDetaillist];
//            dispatch_async(dispatch_get_main_queue(), ^{ // 2
//                [tbl_vw reloadData]; // 3
//            });
//        }
//        for (int i=0; i<[Latevariance count]; i++) {
//            NSMutableDictionary *dictValues = [Latevariance objectAtIndex:i];
//            
//            Latevariancelist *mLatevariancelist = [[Latevariancelist alloc] init];
//            mLatevariancelist.OnTimeorLate=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"OnTimeorLate"]];
//            mLatevariancelist.Status=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"Status"]];
//            [_arrlatelist addObject:mLatevariancelist];
//            
//        }
//
//
//       
//        dispatch_async(dispatch_get_main_queue(), ^{ // 2
//            [tbl_data reloadData]; // 3
//        });
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//    
//
//    
//    
//    
//}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.25 animations:^{
        _vw_popup.alpha=0.0;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)podupload{
    
    
    
}


-(void)arw_btn_click:(UIButton *)sender{
    
    //f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/OnsiteConfirmPickup?LoadID=56&ShipmentId=100035&Latitude=13.0742234&Longitude=80.220834
    if (sender.tag == 0) {
        
        flag=0;
        [tbl_data reloadData];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/OnsiteConfirmPickup?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    else if (sender.tag==1){
        flag1=0;
        pod=1;
        [tbl_data reloadData];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/OnsiteConfirmPickup?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        
        if (pod==1) {
            pod=0;
            PodPageViewController *mPodPageViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PodPageViewController"];
            [self.navigationController pushViewController:mPodPageViewController animated:YES];
        }
        
        
    }else if (sender.tag==2){
        
        flag2=0;
        delpod=1;
        [tbl_data reloadData];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net//Service1.svc/OnsiteConfirmPickup?" parameters:@{@"LoadID":[shipmentdetails valueForKey:@"LoadID"],@"ShipmentID":[shipmentdetails valueForKey:@"ShipmentId"],@"Latitude":latvalue,@"Longitude":lngvalue} progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            NSLog(@"JSON: %@", responseObject);
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

        
        if (delpod==1) {
            delpod=0;
            PodPageViewController *mPodPageViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PodPageViewController"];
            [self.navigationController pushViewController:mPodPageViewController animated:YES];
        }

    }
    
    
    
    
}





- (IBAction)podupload_click:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
