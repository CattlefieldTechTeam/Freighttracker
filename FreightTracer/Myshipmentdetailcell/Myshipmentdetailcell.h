//
//  Myshipmentdetailcell.h
//  FreightTracer
//
//  Created by Animesh Jana on 09/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Myshipmentdetailcell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shipmentid_text;

@property (weak, nonatomic) IBOutlet UILabel *status_text;
@property (weak, nonatomic) IBOutlet UILabel *location_text;
@property (weak, nonatomic) IBOutlet UILabel *pickup_text;
@property (weak, nonatomic) IBOutlet UILabel *address_text;
@property (weak, nonatomic) IBOutlet UIButton *arw_btn;

@property (weak, nonatomic) IBOutlet UILabel *stops_text;


@end
