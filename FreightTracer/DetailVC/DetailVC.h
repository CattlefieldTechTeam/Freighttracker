//
//  DetailVC.h
//  FreightTracer
//
//  Created by Animesh Jana on 18/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailVC : UIViewController<UIGestureRecognizerDelegate,CLLocationManagerDelegate>{
    
    
    __weak IBOutlet UITableView *tbl_data;
    NSMutableDictionary *shipmentdetails;
    NSMutableDictionary *content;
    NSMutableArray *SubstatusList;
    NSMutableArray *Stops;
    NSMutableArray *Latevariance;

    NSMutableDictionary*sub;

    __weak IBOutlet UITableView *tbl_vw;
    
    int numberofrows;
    int row;
    int flag;
    int flag1;
    int flag2;
    int pod;
    int delpod;


    CLLocationManager *locationManager;
    NSString *latvalue;
    NSString *lngvalue;
    CLRegion *bridge;
    NSString *substatus;
    NSString *substatusId;


}
@property (weak, nonatomic) IBOutlet UILabel *milesremaining_txt;



@property (weak, nonatomic) IBOutlet UILabel *driveremaining_txt;

@property (weak, nonatomic) IBOutlet UILabel *shipment_number;
@property (weak, nonatomic) IBOutlet UILabel *status_txt;
@property (weak, nonatomic) IBOutlet UIView *vw_popup;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *alert_break;
@property (nonatomic, strong) NSMutableArray *arrloadlist;
@property (nonatomic, strong) NSMutableArray *arrlatelist;
@property (nonatomic, strong) NSMutableArray *arrstoplist;
@property (nonatomic) NSTimer* locationUpdateTimer;

- (IBAction)podupload_click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_podupload;

@property (weak, nonatomic) IBOutlet UIImageView *cancel_img;

@end
