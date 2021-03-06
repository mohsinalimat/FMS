//
//  UIViewController+FMS_NavSetting.m
//  FMS
//
//  Created by indianic on 06/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "UIViewController+FMS_NavSetting.h"
#import "MMDrawerBarButtonItem.h"
#import "FMS_LoadDetailVC.h"
#import "FMS_DeliveredLoadsVC.h"
#import "FMS_DeliveredHistoryVC.h"
#import "FMS-Swift.h"
@implementation UIViewController (FMS_NavSetting)
-(void)setNavigationBarWithTitle:(NSString*)aStrTitle withBack:(BOOL)backRequired
{
    [self.navigationItem setHidesBackButton:YES];
    [self setNavTitle:aStrTitle];
    
   
    //set left button
    [self setLeftBarButton:backRequired];
    
    
    //Set Right button
    if(![self.restorationIdentifier isEqualToString:@"FMS_LoginlessVC"] && ![self.restorationIdentifier isEqualToString:@"FMS_ForgotPWDVC"]  && ![self.restorationIdentifier isEqualToString:@"FMS_NotificationVC"] && ![self.restorationIdentifier isEqualToString:@"FMS_CreateMessageVC"] && ![self.restorationIdentifier isEqualToString:@"FMS_MessageDetailVC"] && ![self.restorationIdentifier isEqualToString:@"FMS_RegisterVC"])
    {
        
        //showRightButtons
        if([self.restorationIdentifier isEqualToString:@"FMS_LoadDetailVC"] || [self.restorationIdentifier isEqualToString:@"FMS_DeliveredLoadsVC"] || [self.restorationIdentifier isEqualToString:@"FMS_DeliveredHistoryVC"])
        {
            if([self.restorationIdentifier isEqualToString:@"FMS_LoadDetailVC"])
            {
                FMS_LoadDetailVC * FMS_LoadDetailVCObj =(FMS_LoadDetailVC*)self;
                if(FMS_LoadDetailVCObj.showRightButtons)
                {
                    [self setRightButton];
                }
            }
            else if([self.restorationIdentifier isEqualToString:@"FMS_DeliveredLoadsVC"])
            {
                FMS_DeliveredLoadsVC *FMS_DeliveredLoadsVCObj = (FMS_DeliveredLoadsVC*)self;
                if(FMS_DeliveredLoadsVCObj.showRightButtons)
                {
                    [self setRightButton];
                }
            }
            else if([self.restorationIdentifier isEqualToString:@"FMS_DeliveredHistoryVC"])
            {
                FMS_DeliveredHistoryVC *FMS_DeliveredHistoryVCObj = (FMS_DeliveredHistoryVC*)self;
                if(FMS_DeliveredHistoryVCObj.showRightButtons)
                {
                    [self setRightButton];
                }
            }
            
            
            //FMS_DeliveredLoadsVC
        }
        else
        {
          [self setRightButton];
        }
        
        
        
    }
}
-(void)setRightButton
{
    UIView *aVWContainerObj = [[UIView alloc] initWithFrame:CGRectMake(0,0,88,44)];
    
    UIButton *aBtnRightFirstItemObj;
    UIButton *aBtnRightSecondItemObj;
    CustomImageView*badgeVW;
    aBtnRightFirstItemObj = [self getBarButtonWithImageNamed:@"ic-noticication" withSelector:@selector(notificationButtonClicked)];
    
    if([self.restorationIdentifier isEqualToString:@"FMS_MessageVC"])
    {
        aBtnRightSecondItemObj = [self getBarButtonWithImageNamed:@"ic-compose" withSelector:@selector(createMessageButtonClicked)];
    }
    else if([self.restorationIdentifier isEqualToString:@"FMS_MyDriversVC"])
    {
        aBtnRightSecondItemObj = [self getBarButtonWithImageNamed:@"ic-compose" withSelector:@selector(createDriverClicked)];
    }
    else 
    {
        aBtnRightSecondItemObj = [self getBarButtonWithImageNamed:@"ic-mail" withSelector:@selector(messageButtonClicked)];
        
         badgeVW= [[CustomImageView alloc] initWithFrame:CGRectMake(74,10,7,7)];
        [badgeVW setBackgroundColor:[UIColor redColor]];
        [badgeVW setTag:5001];
        [badgeVW setCornerRadius:3.5];
        [badgeVW setHidden:TRUE];
        [aVWContainerObj addSubview:badgeVW];
    }
    
    if(![self.restorationIdentifier isEqualToString:@"FMS_MessageVC"] && ![self.restorationIdentifier isEqualToString:@"FMS_MyDriversVC"])
    {
      [aVWContainerObj addSubview:aBtnRightFirstItemObj];
      [aBtnRightFirstItemObj setFrame:CGRectMake(0,0,44,44)];
    }
    
    [aVWContainerObj addSubview:aBtnRightSecondItemObj];
    [aBtnRightSecondItemObj setFrame:CGRectMake(44,0,44,44)];
    
    
    if(badgeVW)
    {
        [aVWContainerObj addSubview:badgeVW];
    }
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:aVWContainerObj];
    
    
    
    UIBarButtonItem *negativeSpacerRight = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    negativeSpacerRight.width = -15;
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:negativeSpacerRight,customBarItem,nil];

}
-(void)setLeftBarButton:(BOOL)isbackRequired
{
    //Set Left button
    UIButton *aBtnLeftItemObj;
    if(isbackRequired)
        aBtnLeftItemObj = [self getBarButtonWithImageNamed:@"ic-back" withSelector:@selector(backButtonClicked)];
    else
        aBtnLeftItemObj = [self getBarButtonWithImageNamed:@"ic-drawer-menu" withSelector:@selector(MenuButtonClicked)];
    // self.navigationItem.leftBarButtonItem=aBtnLeftItemObj;
    
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:aBtnLeftItemObj];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, customBarItem/*this will be the button which u actually need*/, nil] animated:NO];

}
-(void)setNavTitle:(NSString*)aStrTitle
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 150)];
    titleLabel.text = aStrTitle;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:17.0], NSLigatureAttributeName:@2, NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, titleLabel.text.length)];
    [titleLabel setAttributedText:attributedString];
    [self.navigationItem setTitleView:titleLabel];
}
- (UIButton*)getBarButtonWithImageNamed:(NSString*)aStrImageName withSelector:(SEL)aSelObj
{
    UIImage *buttonImage = [UIImage imageNamed:aStrImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:aSelObj forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - Navigationbar Button Actions
-(void)createMessageButtonClicked
{
    UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil];
    id aCenterControllerObj =  [aStoryBoardObj instantiateViewControllerWithIdentifier:@"FMS_CreateMessageVC"];
    [self.navigationController pushViewController:aCenterControllerObj animated:YES];
    //[self performSegueWithIdentifier:@"pushCreateMessage" sender:self];
}

-(void)createDriverClicked
{
    UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil];
    FMS_DriverProfileVC *FMS_DriverProfileVCObj = (FMS_DriverProfileVC*)[aStoryBoardObj instantiateViewControllerWithIdentifier:@"FMS_DriverProfileVC"];
    FMS_DriverProfileVCObj.intUsageType = 0;
    
    [self.navigationController pushViewController:FMS_DriverProfileVCObj animated:TRUE];

}

-(void)messageButtonClicked
{
    
    NSString *isUpdateProfile =     UDGetObject(FMS_LoginProfileStatus);
    NSLog(@"Uddate profile %@",isUpdateProfile);
    if ([isUpdateProfile isEqualToString:@"1"]) {
        [FMS_Utility showAlert:@"Please complete your profile."];
        return;
    }
    NSString *aStrStoryBoardName = FMS_StoryboardSecondary;
    NSString *aStrStoryBoardID = @"FMS_MessageVC";
    
    UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:aStrStoryBoardName bundle:nil];
    id aCenterControllerObj =  [aStoryBoardObj instantiateViewControllerWithIdentifier:aStrStoryBoardID];
    
    [self.navigationController pushViewController:aCenterControllerObj animated:TRUE];
    
    //[self.mm_drawerController setCenterViewController:aCenterControllerObj];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)notificationButtonClicked
{
    
    NSString *isUpdateProfile =     UDGetObject(FMS_LoginProfileStatus);
    NSLog(@"Uddate profile %@",isUpdateProfile);
    if ([isUpdateProfile isEqualToString:@"1"]) {
        [FMS_Utility showAlert:@"Please complete your profile."];
        return;
    }
    
    NSString *aStrStoryBoardName = FMS_StoryboardSecondary;
    NSString *aStrStoryBoardID = @"FMS_NotificationVC";
    
    UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:aStrStoryBoardName bundle:nil];
    id aCenterControllerObj =  [aStoryBoardObj instantiateViewControllerWithIdentifier:aStrStoryBoardID];
    
    [self.navigationController pushViewController:aCenterControllerObj animated:TRUE];
    
    //[self.mm_drawerController setCenterViewController:aCenterControllerObj];
    //[self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)backButtonClicked
{
       [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)MenuButtonClicked
{
    NSString *isUpdateProfile =     UDGetObject(FMS_LoginProfileStatus);
    NSLog(@"Uddate profile %@",isUpdateProfile);
    if ([isUpdateProfile isEqualToString:@"1"]) {
        [FMS_Utility showAlert:@"Please complete your profile."];
        return;
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)refreshBadge
{
    if(self.navigationItem.rightBarButtonItems.count>0)
    {
        UIBarButtonItem * myButtonItemObj  =  self.navigationItem.rightBarButtonItems[1];
        
        CustomImageView *aBadgeVWObj = (CustomImageView*) [myButtonItemObj.customView viewWithTag:5001];
        
        if([FMS_Utility sharedFMSUtility].strUnreadCount)
        {
            if(aBadgeVWObj)
            {
                if([[FMS_Utility sharedFMSUtility].strUnreadCount intValue]>0)
                {
                    [aBadgeVWObj setHidden:FALSE];
                }
                else
                {
                    [aBadgeVWObj setHidden:TRUE];
                }
            }
        }
    }
}
@end
