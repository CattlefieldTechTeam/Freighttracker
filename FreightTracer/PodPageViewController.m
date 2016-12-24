//
//  PodPageViewController.m
//  FreightTracer
//
//  Created by Mac on 24/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

#import "PodPageViewController.h"
#import "PODCollectionViewCell.h"
#import "DetailFreightTracerController.h"
#import <AFNetworking.h>
@implementation UIImage (PodPageViewController)

- (NSString *)base64String {
    NSData * data = [UIImagePNGRepresentation(self) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}

@end
@interface PodPageViewController ()

@end
@implementation PodPageViewController (Extended)

- (NSString *)base64String {
    NSData * data = [UIImagePNGRepresentation(self) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}

@end

@implementation PodPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    _imagearr =[[NSMutableArray alloc]init];
    NSLog(@"contentdict::%@",self.imagedictinary);
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(activateDeletionMode:)];
    longPress.delegate = self;
    [self.collectionview addGestureRecognizer:longPress];
    [self cornerradiusButton:self.AddPageBtn];
    [self cornerradiusButton:self.SendPodBtn];
    [self cornerradiusButton:self.addfirstPageBtn];
    if (self.imagearr.count==0) {
        [self.collctionviewheight setConstant:0];
        
    }
    else
    {
        [self.collctionviewheight setConstant:101];

        
    }
     
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}
- (void)activateDeletionMode:(UILongPressGestureRecognizer *)gr
{
   
    if (gr.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gr locationInView:self.collectionview];
    
    NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
 
        [self.collectionview performBatchUpdates:^(void){
            NSLog(@"rowvalue :%d",indexPath.row);
            
            [_imagearr removeObjectAtIndex:indexPath.row];
            [self.collectionview deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
        } completion:nil];
        
        
        
        [self.collectionview reloadData];
        if (_imagearr.count!=0) {
            
            if (_imagearr.count >indexPath.row) {
                self.imageview.image =[_imagearr objectAtIndex:indexPath.row];

            }
            else
            {
                self.imageview.image = [_imagearr objectAtIndex:indexPath.row-1];
                
            }

        }else
        {
            self.imageview.image = [UIImage imageNamed:@"camera"];
            if (self.imagearr.count==0) {
                [self.collctionviewheight setConstant:0];
                
            }
            else
            {
                [self.collctionviewheight setConstant:101];
                
                
            }

            
        }

        
    }
    
    
}

- (IBAction)takePhoto:(UIButton *)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
  
}

- (IBAction)SendPodAction:(id)sender {
    
  //  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
       UIImage *uploadimag= [self.imagearr objectAtIndex:0];
    
    UIImage *imgeis =[self resizeImage:uploadimag];
    
    
    NSData* data = UIImageJPEGRepresentation(imgeis, 1.0f);
    NSString *encodedString = [data base64Encoding];
 
    NSString *value =[self.imagedictinary objectForKey:@"LoadID"];
    int loadvalue = [value intValue];
    
      NSDictionary *parameterdata =[[NSDictionary alloc]initWithObjectsAndKeys:value,@"LoadID",@"1",@"Delivery",encodedString,@"base64string",nil];
    NSLog(@"params: %@", parameterdata);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterdata options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://6956c8b0bb1345218c92e9de4bd9cd54.cloudapp.net/Service1.svc/PodUpload" parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"requst is::%@",req);
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                //blah blah
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];}

- (IBAction)AddFirstPageAction:(id)sender {
    
    [self.intialView setHidden:YES];
    
    

}
- (NSString *)base64String {
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (IBAction)BackAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailFreightTracerController *myNewVC = (DetailFreightTracerController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailFreightTracerController"];
    [self.navigationController pushViewController:myNewVC animated:YES];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    //encoding image to base64
    UIImage *imgeis =[self resizeImage:chosenImage];
    
    
   NSData  *imgData=[[NSData alloc] initWithData:UIImagePNGRepresentation(imgeis)];
   NSString * _base64=[[NSString alloc]init];
    
    _base64=[imgData  base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"sdfsd:%@",_base64);
    
    if (self.imagearr.count!=20) {
        [self.imagearr addObject:chosenImage];
        self.imageview.image = chosenImage;
        
        if (self.imagearr.count==0) {
            [self.collctionviewheight setConstant:0];
            
        }
        else
        {
            [self.collctionviewheight setConstant:101];
            
            
        }


        [self.collectionview reloadData];


    }else
    {
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert" message:@"maximum limit 20 images only" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagearr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PODCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.cellimageview.image =[_imagearr objectAtIndex:indexPath.item];
    cell.tag = indexPath.item;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.imageview.image =[_imagearr objectAtIndex:indexPath.item];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    
    
    return YES;
}

-(void)cornerradiusButton:(UIButton *)addressbtn

{
    addressbtn.layer.cornerRadius=addressbtn.frame.size.width/2;
    addressbtn.layer.borderColor=[UIColor blackColor].CGColor;
    
    addressbtn.layer.cornerRadius =5.0;
    
}
-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 50;
    float maxWidth = 100;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.01;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
