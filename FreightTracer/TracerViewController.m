//
//  TracerViewController.m
//  FreightTracer
//
//  Created by Mac on 22/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "TracerViewController.h"
#import "TracerTableViewCell.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "DetailFreightTracerController.h"
//#import "constant.h"
#import <CoreLocation/CoreLocation.h>
//#import "ACKViewController.h"

@interface TracerViewController ()

@end

@implementation TracerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    [SVProgressHUD show];
  
    [self getapidata];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrraydata.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"Cell";
    
    
    TracerTableViewCell *cell = (TracerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.shipmentiD.text = [NSString stringWithFormat:@"Shipment ID:%@",[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"ShipmentId"]];
    cell.locationlabel.text = [[arrraydata objectAtIndex:indexPath.row]valueForKey:@"LocationName"];
    cell.pickuplabel.text = [[arrraydata objectAtIndex:indexPath.row]valueForKey:@"PickUpScheduleDateTime"];
    cell.addresslabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"LocationAddress1"],[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"LocationAddress2"],[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"LocationCity"],[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"LocationZip"]];
    cell.stopslabel.text =[NSString stringWithFormat:@"%@",[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"Noofstops"]];
    NSString *substatus = [[arrraydata objectAtIndex:indexPath.row]valueForKey:@"Substatus"];
    
    if (substatus.length==0) {
         cell.statuslabel.text =[NSString stringWithFormat:@"%@",[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"MainStatus"]];
    }
       else
       {cell.statuslabel.text =[NSString stringWithFormat:@"%@(%@)",[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"MainStatus"],[[arrraydata objectAtIndex:indexPath.row]valueForKey:@"Substatus"]];
        
       
       }
    
    
    [cell.layer setBorderColor:[UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor];
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setShadowOffset:CGSizeMake(0, 1)];
    [cell.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setShadowRadius:8.0];
    [cell.layer setShadowOpacity:1.0];

    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self getcurrentlocationlatitudelongitude];
    
    NSDictionary *dictinary =[arrraydata objectAtIndex:indexPath.row];
    NSLog(@"dictinaryis::%@",dictinary);
    
            if ([[dictinary objectForKey:@"IsAcknowldeged"] isEqualToNumber:@(0)])
        {
            
            [self performSegueWithIdentifier:@"IsAcknowldeged" sender:self];

    
                }else
                {
    
  //  http://f9d4311cf5294578983153f00f296cf4.cloudapp.net/Service1.svc/LoadAcknowlegment?
    
    
   
    
    

            [self performSegueWithIdentifier:@"Detailshow" sender:self];
                }
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"Detailshow"]) {
        
        DetailFreightTracerController *detailview=[segue destinationViewController];
        NSIndexPath *indexpath =[self.tableview indexPathForSelectedRow];
        detailview.dictnarydata =[arrraydata objectAtIndex:indexpath.row];
        
        
        
        
        
    }else if ([segue.identifier isEqualToString:@"IsAcknowldeged"]) {
        
        ACKViewController *viewcntrl=[segue destinationViewController];
        NSIndexPath *indexpath =[self.tableview indexPathForSelectedRow];
        viewcntrl.dictnarydata =[arrraydata objectAtIndex:indexpath.row];
        
        
        
        
        
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

- (IBAction)pushingview:(id)sender {
    [self performSegueWithIdentifier:DetailshowSegue sender:self];
    
}
-(void)getapidata
{
    [self getcurrentlocationlatitudelongitude];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:Mobile_url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        arrraydata =[[NSMutableArray alloc]init];
        if ([[responseObject objectForKey:status] isEqualToNumber:@(1)])
        {
            arrraydata =[responseObject objectForKey:content];
            
            NSLog(@"arraydata is::%@",arrraydata);
            [self.tableview reloadData];
            [SVProgressHUD dismiss];

            
            
        }else
        {
            [self showAlertmessage:@"Alert" message:[responseObject objectForKey:@"message"]];
            [SVProgressHUD dismiss];

            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", [error description]);
        [self showAlertmessage:@"Alert" message:@"NetworkError"];
        [SVProgressHUD dismiss];
        

    }];
    
    
    
}
-(void)showAlertmessage:(NSString *)title message:(NSString *)message


{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    }

-(void)getcurrentlocationlatitudelongitude

{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    latvalue = coordinate.latitude;
    lngvalue =  coordinate.longitude;
    CLLocation *current = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    
    
    
}

@end
