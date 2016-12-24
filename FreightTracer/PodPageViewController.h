//
//  PodPageViewController.h
//  FreightTracer
//
//  Created by Mac on 24/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PodPageViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic,strong) NSMutableArray *imagearr;
@property (nonatomic,strong) NSDictionary *imagedictinary;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UIButton *SendPodBtn;
@property (weak, nonatomic) IBOutlet UIButton *AddPageBtn;
@property (weak, nonatomic) IBOutlet UIView *intialView;
@property (weak, nonatomic) IBOutlet UIButton *addfirstPageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collctionviewheight;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)SendPodAction:(id)sender;
- (IBAction)AddFirstPageAction:(id)sender;
- (IBAction)BackAction:(id)sender;

@end
