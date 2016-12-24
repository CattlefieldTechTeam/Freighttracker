//
//  DetailFreightTracerController.h
//  FreightTracer
//
//  Created by Mac on 22/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface DetailFreightTracerController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

{
   

    NSMutableDictionary *ContentDictinary;
    NSMutableArray *SubstatusListArray;
    CLLocationManager *locationManager;
    double latvalue;
    double lngvalue;
    NSString *substatusID;
    NSDictionary *secondsDictinary;
    
    float valtimer;
    

    
    __weak IBOutlet UIButton *ToCopyAddresBtn;
    __weak IBOutlet UIButton *fromcopyAddressBtn;
    
    __weak IBOutlet UIButton *stopCopyAddresBtn;

}
@property (weak, nonatomic) IBOutlet UITableView *dropdowntable;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrolviewheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stopviewHeight;
@property (nonatomic,strong)NSDictionary *dictnarydata;
@property (weak, nonatomic) IBOutlet UILabel *ontimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *ToOntimelabrl;

@property (weak, nonatomic) IBOutlet UILabel *shipmentidlabel;
@property (weak, nonatomic) IBOutlet UILabel *fromaddress;
@property (weak, nonatomic) IBOutlet UILabel *fromaddrsdatelbl;
@property (weak, nonatomic) IBOutlet UILabel *fromtimelabel;
@property (weak, nonatomic) IBOutlet UILabel *toaddresslabel;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UILabel *Todatelabel;
@property (weak, nonatomic) IBOutlet UILabel *intransistlabel;

@property (weak, nonatomic) IBOutlet UILabel *Totimelabel;
@property (weak, nonatomic) IBOutlet UIView *stopview;
@property (weak, nonatomic) IBOutlet UIView *toview;
@property (weak, nonatomic) IBOutlet UILabel *stopAddreslabel;
@property (weak, nonatomic) IBOutlet UIButton *dispatchedBtn;


@property (weak, nonatomic) IBOutlet UILabel *Stopdatelabel;
@property (weak, nonatomic) IBOutlet UILabel *stopTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *stopcount;

@property (weak, nonatomic) IBOutlet UILabel *drivetimeremainglbl;

@property (weak, nonatomic) IBOutlet UILabel *milestravelledlabel;

@property (weak, nonatomic) IBOutlet UILabel *milesremainglabel;

-(void)dstenceCallingApi:(CLLocation *)fromlocation toloaction:(CLLocation *)tolocation;


- (IBAction)StopCopyaddresAction:(id)sender;
-(void)getcurrentlocationlatitudelongitude;
- (IBAction)poduploadingviewAction:(id)sender;


- (IBAction)popview:(id)sender;
- (IBAction)fomcopyaddrsaction:(id)sender;
- (IBAction)onsiteconformationAction:(id)sender;

- (IBAction)ToaddressAction:(id)sender;
@end
