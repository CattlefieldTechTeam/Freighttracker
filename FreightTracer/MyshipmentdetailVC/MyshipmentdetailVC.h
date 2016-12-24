//
//  MyshipmentdetailVC.h
//  FreightTracer
//
//  Created by Animesh Jana on 09/12/16.
//  Copyright © 2016 Animesh Jana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyshipmentdetailVC : UIViewController{
    
    __weak IBOutlet UITableView *tbl_data;
    NSMutableArray *dictAddress;

    
}

@property (nonatomic, strong) NSMutableArray *arrloadlist;



@end
