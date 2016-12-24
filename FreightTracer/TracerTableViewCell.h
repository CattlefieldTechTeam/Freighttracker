//
//  TracerTableViewCell.h
//  FreightTracer
//
//  Created by Mac on 22/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shipmentiD;

@property (weak, nonatomic) IBOutlet UILabel *locationlabel;
@property (weak, nonatomic) IBOutlet UILabel *pickuplabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UILabel *stopslabel;

@property (weak, nonatomic) IBOutlet UILabel *statuslabel;

@end
