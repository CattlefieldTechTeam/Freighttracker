//
//  Stoplist.h
//  FreightTracer
//
//  Created by Animesh Jana on 21/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stoplist : NSObject

@property (nonatomic, strong) NSString *DeliveryAddress1;
@property (nonatomic, strong) NSString *DeliveryAddress2;
@property (nonatomic, strong) NSString *DeliveryCity;
@property (nonatomic, strong) NSString *DeliveryCountry;
@property (nonatomic, strong) NSString *DeliveryScheduledDate;
@property (nonatomic, strong) NSString *DeliveryScheduledTime;
@property (nonatomic, strong) NSString *Stoplocationname;


@end
