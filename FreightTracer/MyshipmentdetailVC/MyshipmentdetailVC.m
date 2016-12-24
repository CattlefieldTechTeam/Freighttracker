//
//  MyshipmentdetailVC.m
//  FreightTracer
//
//  Created by Animesh Jana on 09/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import "MyshipmentdetailVC.h"
#import "Myshipmentdetailcell.h"
#import "MyshipmentdetailList.h"
#import  "AcknowledgementVC.h"
#import "DetailVC.h"

@interface MyshipmentdetailVC ()

@end

@implementation MyshipmentdetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrloadlist=[[NSMutableArray alloc]init ];
    
    dictAddress = [[Common SharedInstance] getValueForKey:LoadDetails];

    NSData *data = [[Common SharedInstance] getValueForKey:LoadDetails];
    dictAddress = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%d",[dictAddress count]);
    
    for (int i=0; i<[dictAddress count]; i++) {
        
        NSLog(@"%d",i);
        NSMutableDictionary *dictValues = [dictAddress objectAtIndex:i];
        NSLog(@"value::%@",[dictValues objectForKey:@"ShipmentId"]);
        
        
        
        MyshipmentdetailList *mMyshipmentdetailList = [[MyshipmentdetailList alloc] init];
        
        mMyshipmentdetailList.shipment_id = [dictValues objectForKey:@"ShipmentId"];
        mMyshipmentdetailList.status =[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"MainStatus"]];

        mMyshipmentdetailList.substatus =[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"Substatus"]];

        mMyshipmentdetailList.location=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"LocationName"]];

        mMyshipmentdetailList.pickup=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"PickUpScheduleDateTime"]];

        mMyshipmentdetailList.address=[[Common SharedInstance] NULLInputinitWithString:[dictValues objectForKey:@"LocationAddress1"]];
        mMyshipmentdetailList.isacknowledge=[dictValues objectForKey:@"IsAcknowldeged"];
        mMyshipmentdetailList.loadid=[dictValues objectForKey:@"LoadID"];
        mMyshipmentdetailList.address1=[dictValues objectForKey:@"LocationAddress2"];
        
        mMyshipmentdetailList.city=[dictValues objectForKey:@"LocationCity"];
        mMyshipmentdetailList.pin=[dictValues objectForKey:@"LocationZip"];
        mMyshipmentdetailList.stops=[dictValues objectForKey:@"Noofstops"];

        
        
        
        
        [_arrloadlist addObject:mMyshipmentdetailList];
        
        
        
    }dispatch_async(dispatch_get_main_queue(), ^{
        [tbl_data reloadData];
    });

    
    NSLog(@"_arrcomplist:::%@",_arrloadlist);

    
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dictAddress count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 192;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Myshipmentdetailcell *cell = [tableView dequeueReusableCellWithIdentifier:@"Myshipmentdetailcell" forIndexPath:indexPath];
    MyshipmentdetailList *mMyshipmentdetailList = [_arrloadlist objectAtIndex:indexPath.row];

    
    cell.shipmentid_text.text=[NSString stringWithFormat:@"SHIPMENT ID:%@",mMyshipmentdetailList.shipment_id];
    
    if ([mMyshipmentdetailList.substatus isEqualToString:@""]) {
         cell.status_text.text=[NSString stringWithFormat:@"%@",mMyshipmentdetailList.status];
    } else {
        cell.status_text.text=[NSString stringWithFormat:@"%@(%@)",mMyshipmentdetailList.status,mMyshipmentdetailList.substatus];

    }

   
    cell.location_text.text=[NSString stringWithFormat:@"LOCATION:   %@",mMyshipmentdetailList.location];
    cell.pickup_text.text=[NSString stringWithFormat:@"PICKUP:       %@",mMyshipmentdetailList.pickup];
    cell.address_text.text=[NSString stringWithFormat:@"%@,%@,%@,%@",mMyshipmentdetailList.address,mMyshipmentdetailList.address1,mMyshipmentdetailList.city,mMyshipmentdetailList.pin];
    cell.stops_text.text=[NSString stringWithFormat:@"No. Of Stops:%@",mMyshipmentdetailList.stops];
    cell.arw_btn.tag=indexPath.row;
    [cell.arw_btn addTarget:self action:@selector(arw_btn_click:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)arw_btn_click:(UIButton *)sender{

       ///
    
    
    
    MyshipmentdetailList *mMyshipmentdetailList = [_arrloadlist objectAtIndex:sender.tag];
    NSMutableDictionary *details =[dictAddress objectAtIndex:sender.tag];
    NSLog(@"%@",[details valueForKey:@"ShipmentId"]);
    [[Common SharedInstance] storObject:details forKey:SelectedId];
    


    if ([mMyshipmentdetailList.isacknowledge isEqualToNumber:@(1)]) {
        NSLog(@"%@",mMyshipmentdetailList.isacknowledge);
        DetailVC *mDetailVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        [self.navigationController pushViewController:mDetailVC animated:YES];
        
        
        
    } else {
        AcknowledgementVC *mAcknowledgementVC =[self.storyboard instantiateViewControllerWithIdentifier:@"AcknowledgementVC"];
        [self.navigationController pushViewController:mAcknowledgementVC animated:YES];
    }
    
}






@end
