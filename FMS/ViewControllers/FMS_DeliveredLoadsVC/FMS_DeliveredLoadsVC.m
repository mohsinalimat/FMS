//
//  FMS_DeliveredLoadsVC.m
//  FMS
//
//  Created by indianic on 10/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "FMS_DeliveredLoadsVC.h"
#import "UIImageView+MHFacebookImageViewer.h"

@interface FMS_DeliveredLoadsVC ()

@end

@implementation FMS_DeliveredLoadsVC
@synthesize FMS_LoadDetailObj,strOrderID,showRightButtons,isForPickup;
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [imgViewTicketNo1 setupImageViewer];
    [imgViewTicketNo2 setupImageViewer];
    
    if(isForPickup)
    {
        [self setNavigationBarWithTitle:@"Pick up order" withBack:true];
        [self setLayOutForPickup];
    }
    else
    {
        [self setNavigationBarWithTitle:@"Deliver order" withBack:true];
        [self setLayOutForDelivered];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController==[AppDelegate objSharedAppDel].navCntrl)
    {
        [[AppDelegate objSharedAppDel].navCntrl setNavigationBarHidden:YES];
        
    }
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshBadge];
    
    if (self.navigationController==[AppDelegate objSharedAppDel].navCntrl)
    {
        [[AppDelegate objSharedAppDel].navCntrl setNavigationBarHidden:NO];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Events

- (IBAction)btnSaveClick:(UIButton *)sender {
    
    [self resignAll];
    BOOL isSucceed = YES;
    
    NSMutableDictionary *aMutDictObj;
    if(isForPickup)
    {
        
        if (!viewPickUpImage.hidden)
        {
            if (imgViewTicketNo2.image == nil)
            {
                isSucceed = NO;
            }
        }
        
        
        if(isSucceed)
        {
           aMutDictObj = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UserDefaults objectForKey:FMS_LoginUserType],@"role",[UserDefaults objectForKey:FMS_LoginUserToken],@"token",strOrderID,@"order_id",@"Picked up",@"order_status",[UserDefaults objectForKey:FMS_Latitude],@"latitude",[UserDefaults objectForKey:FMS_Longitude],@"longitude",nil];
            
            if (!viewPickUpImage.hidden)
            {
                [aMutDictObj setObject:@"pickup_image" forKey:@"ParamName2"];
                [aMutDictObj setObject:imgViewTicketNo2.image forKey:@"Image2"];
            }

        }

    }
    else
    {
        
        BOOL isTicketNoCompulsory = YES;
        
        if (!viewTicketImage.hidden)
        {
            isTicketNoCompulsory = NO;
            if (imgViewTicketNo1.image == nil)
            {
                isSucceed = NO;
            }
        }
        
        if ([FMS_Utility isEmptyText:txtFTicketNo.text] && isTicketNoCompulsory)
        {
            isSucceed = NO;
        }
        
        if ([FMS_Utility isEmptyText:txtFDeliveredQty.text])
        {
            isSucceed = NO;
        }
        else
        {
            if([FMS_LoadDetailObj.units.lowercaseString hasPrefix:@"ton"])
            {
                if([txtFDeliveredQty.text intValue]>40)
                {
                    [FMS_Utility showAlert:@"Incorrect load quantity"];
                    return;
                }
            }
            else  if([FMS_LoadDetailObj.units.lowercaseString hasPrefix:@"bus"])
            {
                if([txtFDeliveredQty.text intValue]>1500)
                {
                    [FMS_Utility showAlert:@"Incorrect load quantity"];
                    return;
                }
            }
        }
        
        if (isSucceed)
        {
            aMutDictObj = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UserDefaults objectForKey:FMS_LoginUserType],@"role",[UserDefaults objectForKey:FMS_LoginUserToken],@"token",strOrderID,@"order_id",@"Delivered",@"order_status",@"",@"reason_id",@"",@"other_reason",txtFDeliveredQty.text,@"delivered_qty",txtFTicketNo.text,@"ticket_num", nil];
            
            if (!viewTicketImage.hidden)
            {
                [aMutDictObj setObject:@"delivered_image" forKey:@"ParamName1"];
                [aMutDictObj setObject:imgViewTicketNo1.image forKey:@"Image1"];
            }
        }

    }
    
    
    if (isSucceed)
    {
        
        Webservice *WebserviceObj = [[Webservice alloc] init];
        [WebserviceObj callWebserviceToUploadImageWithURL:[NSString stringWithFormat:@"%@/loads/update_order_details",FMS_WSURL] withSilentCall:NO withParams:aMutDictObj forViewController:self withCompletionBlock:^(NSDictionary *responseData) {
         
            if([responseData[@"status"] intValue] == 1 )
            {
               [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:responseData[@"message"] withCancelButton:@"Ok"
                                               WithCompletionBlock:^(int index) {
                                                   
                                                   NSArray *aArrControls = self.navigationController.viewControllers;
                                                   [self.navigationController popToViewController:aArrControls[aArrControls.count-3] animated:true];
                                                   
                                                   
                            
                                               } withOtherButtons:nil];
                
                
                
    
            }
            else
            {
                [FMS_Utility showAlert:responseData[@"message"]];
            }

        } withFailureBlock:^(NSError *error) {
            
        }];
    }
    else
    {
        [FMS_Utility showAlert:AllFields];
    }
}
-(void)resignAll
{
    [txtFTicketNo resignFirstResponder];
    [txtFDeliveredQty resignFirstResponder];
}

- (IBAction)btnTakeTicketImage1:(UIButton *)sender{
    
    [self resignAll];
    [[FMS_Utility sharedFMSUtility]openCamera:self isRoundCrop:NO withCompletionBlock:^(UIImage *img) {
        
        if (img != nil)
        {
            [imgViewTicketNo1 setImage:img];
        }
    }];
}
- (IBAction)btnTakeTicketImage2:(UIButton *)sender{
    
    [self resignAll];
    [[FMS_Utility sharedFMSUtility]openCamera:self isRoundCrop:NO withCompletionBlock:^(UIImage *img) {
        
        if (img != nil)
        {
            [imgViewTicketNo2 setImage:img];
        }
    }];
}

#pragma mark OtherMethods
-(void)setLayOutForDelivered
{
    viewPickUpImage.hidden =  TRUE;
    
    
    [txtFDeliveredQty setTintColor:FMS_WhiteColor];
    [txtFTicketNo setTintColor:FMS_WhiteColor];
    lblDeliveredQty.text = [NSString stringWithFormat:@"Delivered Quantity (%@)",self.FMS_LoadDetailObj.units];
    if ([self.FMS_LoadDetailObj.ticketImgRequired isEqualToString:@"0"])
    {
        [viewTicketImage setHidden:YES];
    }
}
-(void)setLayOutForPickup
{
    viewPickUpImage.hidden =  FALSE;
    viewTicketImage.hidden  = TRUE;
    viewDeliverQty.hidden  = TRUE;
    viewTicketNum.hidden  = TRUE;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtFTicketNo)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (currentString.length >20)
        {
            return NO;
        }
    }
    else if (textField == txtFDeliveredQty)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (currentString.length >10)
        {
            return NO;
        }
    }
    return YES;
}


@end
