//
//  Detailcell.h
//  FreightTracer
//
//  Created by Animesh Jana on 18/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detailcell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *from_txt;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *late;

@property (weak, nonatomic) IBOutlet UIButton *btn_onsite;


@end
