//
//  FMS_Utility.m
//  FMS
//
//  Created by indianic on 06/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "FMS_Utility.h"
#import <objc/runtime.h>
#import "FMS_LeftVC.h"
#import "DZNPhotoEditorViewController.h"
#import "UIImagePickerController+Edit.h"
#import "Reachability.h"
#import "FMS_ReportCardVC.h"
#import "FMS_LoginVC.h"
#import "FMS_MainVC.h"

@implementation FMS_Utility
static FMS_Utility *sharedFMS_UtilityObj = nil;


@synthesize dateFormatterObj,boolTokenUpdated,dictNotification,isFromNotification,strUnreadCount,dictPermissions;




+(FMS_Utility*)sharedFMSUtility
{
    if (sharedFMS_UtilityObj == nil) {
        sharedFMS_UtilityObj = [[FMS_Utility alloc] init];
        sharedFMS_UtilityObj.dateFormatterObj = [[NSDateFormatter alloc]init];
    }
    return sharedFMS_UtilityObj;
}
+ (BOOL)validateEmail:(NSString *) emailString
{
    NSString *str = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    BOOL isValid = [emailTest evaluateWithObject:emailString];
    return isValid;
}


+(BOOL)validatePassword:(NSString *)strPassword
{
    //^[a-zA-Z0-9]{4,10}$
    //NSString *passwordRegex =@"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$+-_//.,}{=!%*#?&]{8,15}$";
    NSString *passwordRegex =@"^[a-zA-Z0-9]{8,15}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:strPassword];
}

+ (BOOL)validateMobileNumber:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+(BOOL)isEmptyText:(NSString *)aStrText
{
    NSString *aStrTrimName = [aStrText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (aStrTrimName.length==0)
    {
        return TRUE;
    }
    
    return FALSE;
}

+(void) showAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FMS_APPName message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

+(BOOL)isLoginFromDriver
{
    if([[UserDefaults objectForKey:FMS_LoginUserType] isEqualToString:FMS_Driver])
    {
        return true;
    }
    return  false;
}

-(void)showAlertWithTarget:(id)aTarget WithMessage:(NSString *)aStrMessage withCancelButton:(NSString *)aCancelBtn WithCompletionBlock:(void(^)(int index))completionBlock withOtherButtons:(NSArray *)aArray
{
    UIViewController *aVCObj = (UIViewController *)aTarget;
    
    NSString *aStrMessageChanged = aStrMessage;
    NSMutableArray *aArrTemp = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < aArray.count; i++) {
        NSString *astrChangedTemp = aArray[i];
        [aArrTemp insertObject:astrChangedTemp atIndex:i];
    }
    
    if(isIOS8)
    {
        if (aVCObj==nil || ![aVCObj isKindOfClass:[UIViewController class]] ) {
            UINavigationController *aNavController = (UINavigationController *)[AppDelegate objSharedAppDel].window.rootViewController;
            aVCObj = aNavController.topViewController;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:FMS_APPName message:aStrMessageChanged preferredStyle:UIAlertControllerStyleAlert];
        
        int count =0;
        if (aCancelBtn) {
            [alertController addAction:[UIAlertAction actionWithTitle:aCancelBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                completionBlock!=nil?completionBlock(0):nil;
            }]];
        }
        
        NSString * res = [NSString string];
        
        if (aArrTemp != nil) {
            for (res in aArrTemp) {
                count++;
                [alertController addAction:[UIAlertAction actionWithTitle:res style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    completionBlock!=nil?completionBlock(count):nil;
                }]];
            }
        }
        
        [aVCObj presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        if (aArrTemp.count>0)
        {
            UIAlertView *aAlertView = [[UIAlertView alloc]initWithTitle:FMS_APPName message:aStrMessageChanged delegate:self cancelButtonTitle:aCancelBtn otherButtonTitles:[aArrTemp componentsJoinedByString:@","],nil];
            [aAlertView show];
            
            completionBlock!=nil?objc_setAssociatedObject(aAlertView, @"AlertView", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
        }
        else
        {
            UIAlertView *aAlertView = [[UIAlertView alloc]initWithTitle:FMS_APPName message:aStrMessageChanged delegate:self cancelButtonTitle:aCancelBtn otherButtonTitles:nil];
            [aAlertView show];
            
            completionBlock!=nil?objc_setAssociatedObject(aAlertView, @"AlertView", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
        }

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    void(^completionBlock)(int index ) = objc_getAssociatedObject(alertView, @"AlertView");
    completionBlock!=nil?completionBlock((int)buttonIndex):nil;
}



-(void)addPicker:(UIViewController*)controller onTextField:(UITextField*)txtField pickerType:(NSString*)type withKey:(NSString *)key withCompletionBlock:(void(^)(id picker ,int buttonIndex,int firstindex,int secondindex))completionBlock withPickerArray:(NSArray *)aArray withPickerSecondArray:(NSArray *)aArraySecond count:(int)componentCount withTitle:(NSString*)strTitle
{
    
    
    strKey = key;
    //    pickerFirstSelectedIndex = 0;
    //    pickerSecondSelectedIndex = 0;
    pickerType = type;
    [txtField setTintColor:[UIColor clearColor]];
    UIToolbar  *keyboardDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, controller.view.bounds.size.width, 44)];
    [keyboardDateToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDone:)];
    [done setTintColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0,controller.view.bounds.size.width, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:strTitle];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [keyboardDateToolbar addSubview:titleLabel];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker:)];
    [cancel setTintColor:[UIColor whiteColor]];
    
    [keyboardDateToolbar setItems:[[NSArray alloc] initWithObjects:cancel,flexSpace, done, nil]];
    txtField.inputAccessoryView = keyboardDateToolbar;
    
    if ([type isEqualToString:@"Date"] || [type isEqualToString:@"Time"])
    {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.backgroundColor = [UIColor whiteColor];
        if ([type isEqualToString:@"Date"])
        {
            datePicker.datePickerMode = UIDatePickerModeDate;
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"dd MMM, yy";
            NSDate *date  = [formatter dateFromString:txtField.text];
            
            datePicker.date = (date) ? date : [NSDate date];
            
            txtField.inputView = datePicker;
        }else
        {
            datePicker.datePickerMode = UIDatePickerModeTime;
            txtField.inputView = datePicker;
        }
    }
    else if ([type isEqualToString:@"Month"])
    {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM yy";
        NSDate *date  = [formatter dateFromString:txtField.text];
        
        monthYearPicker = [[MonthPicker alloc]init];
        monthYearPicker.monthPickerDelegate = self;
        
        monthYearPicker.date = (date) ? date : [NSDate date];
        
        [monthYearPicker setBackgroundColor:[UIColor whiteColor]];
        txtField.inputView = monthYearPicker;
    }
    else
    {
        if (aArray != nil)
        {
            firstComponentArray = [[NSArray alloc]initWithArray:aArray];
        }
        if (aArraySecond != nil)
        {
            secondComponentArray = [[NSArray alloc]initWithArray:aArraySecond];
        }
        
        
        pickerComponentCount = componentCount;
        simplePicker = [[UIPickerView alloc] init];
        simplePicker.backgroundColor = [UIColor whiteColor];
        simplePicker.delegate = self;
        simplePicker.dataSource = self;
        
        
        
        if ([strKey isEqualToString:@"Other"])
        {
            
            NSString *aStrCurrentSelection = [txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(aStrCurrentSelection.length>0)
            {
                int aIntIndex =(int) [aArray indexOfObject:aStrCurrentSelection];
                [simplePicker selectRow:aIntIndex inComponent:0 animated:YES];
            }
            
        }
        else{
            int i = 0;
            NSString *aStrName;
            for (i = 0; i < aArray.count; i++) {
                if ([strKey isEqualToString:@"location_name"]) {
                    Location *locationObj = aArray[i];
                    aStrName = locationObj.locationName;
                }
                else if ([strKey isEqualToString:@"commodity_name"]) {
                    Commodity *commodityObj = firstComponentArray[i];
                    aStrName = commodityObj.commodityName;
                }else if ([strKey isEqualToString:@"driver_name"]) {
                    Driver *driverObj = firstComponentArray[i];
                    aStrName = driverObj.driverName;
                }
                else if ([strKey isEqualToString:@"Reason_Cancelled"]) {
                    Cancelled *cancelledObj = firstComponentArray[i];
                    aStrName = cancelledObj.reason;
                }
                else if ([strKey isEqualToString:@"Reason_Missed"]) {
                    //Reason_Missed
                    
                    Missed *missedObj = firstComponentArray[i];
                    aStrName = missedObj.reason;
                }
                if ([txtField.text isEqualToString:aStrName])
                    break;
            }
            [simplePicker selectRow:i inComponent:0 animated:YES];
            
            
            pickerFirstSelectedIndex = 0;
        }
        
        
        
        
        
        txtField.inputView = simplePicker;
    }
    completionBlock!=nil?objc_setAssociatedObject(done, @"done", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
    completionBlock!=nil?objc_setAssociatedObject(cancel, @"cancel", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
}
-(void)pickerDone:(UIBarButtonItem*)item
{
    void(^completionBlock)(id picker ,int buttonIndex,int firstindex,int secondindex ) = objc_getAssociatedObject(item, @"done");
    
    if ([pickerType isEqualToString:@"Date"] || [pickerType isEqualToString:@"Time"])
    {
        completionBlock!=nil?completionBlock(datePicker,1,0,0):nil;
    }else if ([pickerType isEqualToString:@"Month"]){
        completionBlock!=nil?completionBlock(monthYearPicker,1,0,0):nil;
    }
    else
    {
        completionBlock!=nil?completionBlock(simplePicker,1,pickerFirstSelectedIndex,pickerSecondSelectedIndex):nil;
    }
}

-(void)cancelPicker:(UIBarButtonItem*)item
{
    void(^completionBlock)(id buttonTitle ,int buttonIndex,int firstindex,int secondindex) = objc_getAssociatedObject(item, @"cancel");
    completionBlock!=nil?completionBlock(nil,0,0,0):nil;
    
}

+(NSString*)formatDateSendTOServer:(NSDate *)date
{
    //yyyy-mm-dd
    
    // A convenience method that formats the date in Month-Year format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

+(NSString *)formatStringTODateTOString:(NSString*) strDate{
    // 13 Aug, 15
    // 2015-08-14
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date  = [formatter dateFromString:strDate];
    
//    formatter.dateFormat = @"dd MMM, yyyy";
    formatter.dateFormat = @"dd-MM-yyyy";

    return [formatter stringFromDate:date];
}

+(NSString *)formatStringTODateTOString2:(NSString*) strDate{
    // 13 Aug, 15
    // 2015-08-14
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSDate *date  = [formatter dateFromString:strDate];
    
    formatter.dateFormat = @"dd MMMM,yyyy";
    return [formatter stringFromDate:date];
}

+(NSString*)formatMonth:(NSDate *)date
{
    // A convenience method that formats the date in Month-Year format
    // mmm yy
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM yy";
    return [formatter stringFromDate:date];
}

+(NSString *)formatDateComingFromServer:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMM, yy"];
    return [formatter stringFromDate:date];
    
}
#pragma UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerComponentCount;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [firstComponentArray count];
    }
    else
    {
        return [secondComponentArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        if ([strKey isEqualToString:@"location_name"]) {
            Location *locationObj = firstComponentArray[row];
            return locationObj.locationName;
        }else if ([strKey isEqualToString:@"commodity_name"]) {
            Commodity *commodityObj = firstComponentArray[row];
            return commodityObj.commodityName;
        }else if ([strKey isEqualToString:@"driver_name"]) {
            Driver *driverObj = firstComponentArray[row];
            return driverObj.driverName;
        }else if ([strKey isEqualToString:@"Reason_Cancelled"]) {
            Cancelled *cancelledObj = firstComponentArray[row];
            return cancelledObj.reason;
        } else if ([strKey isEqualToString:@"Reason_Missed"]) {
            //Reason_Missed
            
            Missed *missedObj = firstComponentArray[row];
            return missedObj.reason;
        }
        else if ([strKey isEqualToString:@"Other"]) {
            return firstComponentArray[row];
        }else if ([strKey isEqualToString:@"name"]) {
            return firstComponentArray[row][strKey];
        }
    }
    else
    {
        if ([strKey isEqualToString:@"location_name"]) {
            Location *locationObj = secondComponentArray[row];
            return locationObj.locationName;
        }else if ([strKey isEqualToString:@"commodity_name"]) {
            Commodity *commodityObj = secondComponentArray[row];
            return commodityObj.commodityName;
        }else if ([strKey isEqualToString:@"driver_name"]) {
            Driver *driverObj = secondComponentArray[row];
            return driverObj.driverName;
        }else if ([strKey isEqualToString:@"Reason_Cancelled"]) {
            Cancelled *cancelledObj = firstComponentArray[row];
            return cancelledObj.reason;
        } else if ([strKey isEqualToString:@"Reason_Missed"]) {
            //Reason_Missed
            
            Missed *missedObj = firstComponentArray[row];
            return missedObj.reason;
        }
        else if ([strKey isEqualToString:@"Other"]) {
            return secondComponentArray[row];
        }else if ([strKey isEqualToString:@"name"]) {
            return firstComponentArray[row][strKey];
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        pickerFirstSelectedIndex = (int)row;
    }
    else
    {
        pickerSecondSelectedIndex = (int)row;
    }
}
-(void)setDrawerToUse
{
    UITabBarController *objFMS_TabBarVC = (UITabBarController *)[[UIStoryboard storyboardWithName:FMS_StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_TabBarVC"];
    
    FMS_LeftVC *objFMS_LeftVC = (FMS_LeftVC *)[[UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_LeftVC"];
    
    float height = objFMS_TabBarVC.tabBar.frame.size.height;
    
    
    
    
    objFMS_LeftVC.floatHeight=height;
    
    [AppDelegate objSharedAppDel].drawerController = [[MMDrawerController alloc]
                                                      initWithCenterViewController:objFMS_TabBarVC
                                                      leftDrawerViewController:objFMS_LeftVC
                                                      rightDrawerViewController:nil];
    
    [[AppDelegate objSharedAppDel].drawerController setShowsShadow:NO];
    [[AppDelegate objSharedAppDel].drawerController setRestorationIdentifier:@"MMDrawer"];
    [[AppDelegate objSharedAppDel].drawerController setMaximumRightDrawerWidth:200.0];
    [[AppDelegate objSharedAppDel].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [[AppDelegate objSharedAppDel].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}

-(void)setDrawerToUseProfile
{
    
    FMS_ProfileVC *objFMSProfile = (FMS_ProfileVC*)[[UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_ProfileVC"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:objFMSProfile];

    FMS_LeftVC *objFMS_LeftVC = (FMS_LeftVC *)[[UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_LeftVC"];
    
    float height = 49;
    objFMS_LeftVC.floatHeight=height;
    [AppDelegate objSharedAppDel].drawerController = [[MMDrawerController alloc]
                                                      initWithCenterViewController:nav
                                                      leftDrawerViewController:objFMS_LeftVC
                                                      rightDrawerViewController:nil];
    
    [[AppDelegate objSharedAppDel].drawerController setShowsShadow:NO];
    [[AppDelegate objSharedAppDel].drawerController setRestorationIdentifier:@"MMDrawer"];
    [[AppDelegate objSharedAppDel].drawerController setMaximumRightDrawerWidth:200.0];
    [[AppDelegate objSharedAppDel].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [[AppDelegate objSharedAppDel].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}
-(BOOL)checkForAcceptLoadPermission
{
    BOOL aBOOlVal = TRUE;
    
    NSArray *aArrCurrentPermission = [UserDefaults objectForKey:FMS_LoggedInUserPermission];
    
    
    if(![aArrCurrentPermission containsObject:@"accept_load"] && [FMS_Utility isLoginFromDriver] && aArrCurrentPermission)
    {
        aBOOlVal = FALSE;
    }
    
    return aBOOlVal;
}
-(BOOL)checkForViewRatePermission
{
    BOOL aBOOlVal = TRUE;
    
    NSArray *aArrCurrentPermission = [UserDefaults objectForKey:FMS_LoggedInUserPermission];
    
    if(![aArrCurrentPermission containsObject:@"view_rate"] && [FMS_Utility isLoginFromDriver] && aArrCurrentPermission)
    {
        aBOOlVal = FALSE;
    }
    
    return aBOOlVal;
}
-(void)openCamera:(UIViewController*)controller isRoundCrop:(BOOL)isCrop withCompletionBlock:(void(^)(UIImage *img))completionBlock
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self  cancelButtonTitle:@"Cancel"  destructiveButtonTitle:nil  otherButtonTitles:@"Take a picture",@"Open gallery",nil];
    [actionSheet showInView:controller.view];
    viewController = controller;
    isCropImage = isCrop;
    completionBlock!=nil?objc_setAssociatedObject(controller, @"controller", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [FMS_Utility showAlert:CAM_NOT_AVAIL];
        }
        else
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if(authStatus == AVAuthorizationStatusAuthorized)
            {
                [self openPickerWithCamera:YES];
            }
            else if(authStatus == AVAuthorizationStatusNotDetermined)
            {
                NSLog(@"%@", @"Camera access not determined. Ask for permission.");
                
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                 {
                     if(granted)
                     {
                         NSLog(@"Granted access to %@", AVMediaTypeVideo);
                         [self openPickerWithCamera:YES];
                     }
                     else
                     {
                         NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                     }
                 }];
            }
            else if (authStatus == AVAuthorizationStatusRestricted)
            {
                [FMS_Utility showAlert:@"You've been restricted from using the camera on this device. Please contact the device owner so they can give you access."];
            }
            else
            {
                [[FMS_Utility sharedFMSUtility]showAlertWithTarget:self WithMessage:AuthorizeCamera withCancelButton:@"Cancel" WithCompletionBlock:^(int index) {
                    
                } withOtherButtons:@[@"OK"]];
            }
        }
        
    }
    else if(buttonIndex==1)
    {
        [self openPickerWithCamera:NO];
    }
}
- (UIImage*) rotateImageAppropriately:(UIImage*)imageToRotate
{
    UIImage* properlyRotatedImage;
    
    CGImageRef imageRef = [imageToRotate CGImage];
    
    if (imageToRotate.imageOrientation == 0)
    {
        properlyRotatedImage = imageToRotate;
    }
    else if (imageToRotate.imageOrientation == 3)
    {
        
        CGSize imgsize = imageToRotate.size;
        UIGraphicsBeginImageContext(imgsize);
        [imageToRotate drawInRect:CGRectMake(0.0, 0.0, imgsize.width, imgsize.height)];
        properlyRotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else if (imageToRotate.imageOrientation == 1)
    {
        properlyRotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:1];
    }
    
    return properlyRotatedImage;
}

-(void)openPickerWithCamera:(BOOL)isopenCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if (isopenCamera)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (isCropImage)
    {
        picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    }
    else
    {
        picker.cropMode = DZNPhotoEditorViewControllerCropModeNone;
        // picker.cropSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200.0);
    }
    
    [picker.navigationBar setTintColor:[UIColor whiteColor]];
    [picker.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        
        UIImage *image;
        if (isCropImage)
            image= info[UIImagePickerControllerEditedImage];
        else
            image= info[UIImagePickerControllerOriginalImage];
        
        NSData *dataToWrite=UIImageJPEGRepresentation(image,0.3);
        
        UIImage * newImage = [UIImage imageWithData:dataToWrite];
        
        
        
        newImage = [self rotateImageAppropriately:newImage];
        
        
        
        
        void(^completionBlock)(UIImage *img) = objc_getAssociatedObject(viewController, @"controller");
        completionBlock!=nil?completionBlock(newImage):nil;
        
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone)
        {
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        
        void(^completionBlock)(UIImage *img) = objc_getAssociatedObject(viewController, @"controller");
        completionBlock!=nil?completionBlock(nil):nil;
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
    };
    
    [viewController presentViewController:picker animated:YES completion:nil];
}

-(BOOL)checkNetworkStatus
{
    
    [Reachability reachabilityWithHostname:@"http://www.google.com"];
    BOOL isAvailable;
    NetworkStatus hostStatus =[[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (hostStatus){
        case NotReachable:{
            isAvailable = NO;
            break;
        }
        case ReachableViaWiFi:{
            isAvailable = YES;
            break;
        }
        case ReachableViaWWAN:{
            isAvailable = YES;
            break;
        }
    }
    return isAvailable;
}


-(FMS_Filter *)addViewControllerforFilter:(UIViewController *)viewCntrl withStatus:(int)intStatus withFilledDictionary:(NSMutableDictionary *)dictMutFromCurrCntrl
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:FMS_StoryboardThird bundle:nil];
    self.fms_FilterObj  = [storyboard instantiateViewControllerWithIdentifier:@"FMS_Filter"];
    
    
    self.fms_FilterObj.viewObj = intStatus;
    self.fms_FilterObj.dictTextFieldData = [NSMutableDictionary dictionaryWithDictionary:dictMutFromCurrCntrl];
    
    self.fms_FilterObj.view.frame = CGRectMake(self.fms_FilterObj.view.frame.origin.x, -568, self.fms_FilterObj.view.frame.size.width,self.fms_FilterObj.view.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.fms_FilterObj.view.frame = CGRectMake(self.fms_FilterObj.view.frame.origin.x, 0, self.fms_FilterObj.view.frame.size.width,self.fms_FilterObj.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
    
    
    [[AppDelegate objSharedAppDel].window addSubview:self.fms_FilterObj.view];
    
    if ([viewCntrl isKindOfClass:[FMS_ReportCardVC class]])
        [self.fms_FilterObj.view setFrame:CGRectMake(0, 0, self.fms_FilterObj.view.frame.size.width, self.fms_FilterObj.view.frame.size.height)];
    else
        [self.fms_FilterObj.view setFrame:CGRectMake(0, 0, self.fms_FilterObj.view.frame.size.width, self.fms_FilterObj.view.frame.size.height)];
    
    
    
    return self.fms_FilterObj;
}


-(void)MailWithtext:(NSString*)strBody subject:(NSString*)strSubject recipientsTo:(NSMutableArray*)arrayTo recipientsCC:(NSMutableArray*)arrayCC targetFrom:(id)target WithCompletionBlock:(void (^)(MFMailComposeResult result))completionBlock
{
    UIViewController *aVCObj = (UIViewController *)target;
    if ([[FMS_Utility sharedFMSUtility] checkNetworkStatus])
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *aMailcomposerVC = [[MFMailComposeViewController alloc] init];
            aMailcomposerVC.mailComposeDelegate = self;
            if ([arrayTo count]>0) {
                NSArray *arrayFotTo =[[NSArray alloc]initWithObjects:[arrayTo objectAtIndex:0], nil];
                [aMailcomposerVC setToRecipients:arrayFotTo];
                [arrayTo removeObjectAtIndex:0];
            }
            if ([arrayCC count]>0) {
                [aMailcomposerVC setCcRecipients:arrayCC];
            }
            [aMailcomposerVC setSubject:strSubject];
            [aMailcomposerVC setMessageBody:strBody isHTML:YES];
            [aMailcomposerVC.navigationBar setTintColor:[UIColor whiteColor]];
            [aMailcomposerVC.navigationBar
             setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            [aVCObj presentViewController:aMailcomposerVC animated:YES completion:
             ^{
                 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
             }];
            
            completionBlock!=nil?objc_setAssociatedObject(aMailcomposerVC, @"Mail", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
            
        }
        else
        {
            [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:@"MailNoConfigure" withCancelButton:nil WithCompletionBlock:^(int index) {
                
            } withOtherButtons:@[@"AlertOk"]];
        }
    }
    else
    {
        [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:@"AlertInternetNotAvailable" withCancelButton:nil WithCompletionBlock:^(int index) {
            
        } withOtherButtons:@[@"AlertOk"]];
    }
}


#pragma mark - MailComposer Delegate



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    void(^completionBlock)(MFMailComposeResult result) = objc_getAssociatedObject(controller, @"Mail");
    completionBlock!=nil?completionBlock((MFMailComposeResult)result):nil;
    
}

-(void)CompletionMail:(MFMailComposeResult)result target:(id)target
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultSaved:
            break;
            
        case MFMailComposeResultSent:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0)), dispatch_get_main_queue(), ^{
                [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:@"Email has been sent successfully." withCancelButton:nil WithCompletionBlock:^(int index) {
                    
                } withOtherButtons:@[@"OK"]];
            });
        }
            break;
            
        case MFMailComposeResultFailed:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0)), dispatch_get_main_queue(), ^{
                [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:@"Email sending failed." withCancelButton:nil WithCompletionBlock:^(int index) {
                    
                } withOtherButtons:@[@"OK"]];
            });
        }
            break;
            
        default:
            break;
    }
    [target dismissViewControllerAnimated:YES completion:nil];
}
-(void)pullToRefeshCalled:(UIRefreshControl*)aRefreshControlObj
{
    [aRefreshControlObj endRefreshing];
    void(^completionBlock)(void) = objc_getAssociatedObject(aRefreshControlObj, @"pullToRefresh");
    completionBlock!=nil?completionBlock():nil;
}
-(void)addPullToRefreshOnTableView:(UITableView*)aTblVWObj WithCompleton:(void (^)(void))completionBlock
{
    
    UIRefreshControl * refreshControlObj = [[UIRefreshControl alloc]init];
    
    completionBlock!=nil?objc_setAssociatedObject(refreshControlObj, @"pullToRefresh", completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC):nil;
    
    [aTblVWObj addSubview:refreshControlObj];
    refreshControlObj.tintColor = FMS_GreenColor;
    [refreshControlObj addTarget:self action:@selector(pullToRefeshCalled:) forControlEvents:UIControlEventValueChanged];
}

+(void)loads_filtersData:(UIViewController *)viewCntrl withCompletionBlock:(void(^)(NSDictionary * responseData))completionBlock withFailureBlock:(void(^)(NSError * error))failureBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            
            Webservice *WebserviceObj = [[Webservice alloc] init];
            
            NSDictionary *aDictObj = @{@"token":[UserDefaults objectForKey:FMS_LoginUserToken],
                                       @"role":[UserDefaults objectForKey:FMS_LoginUserType]};
            [WebserviceObj callWebserviceWithURL:[NSString stringWithFormat:@"%@/loads/loads_filters",FMS_WSURL] withSilentCall:TRUE  withParams:aDictObj forViewController:nil withCompletionBlock:^(NSDictionary *responseData)
             {
                 
                 if([responseData[@"status"] intValue]==1)
                 {
                     
                     
                     if ([responseData[@"code"] intValue] == 200)
                     {
                         // Success
                         [AppDelegate objSharedAppDel].filterBaseObj = [FiltersBaseClass modelObjectWithDictionary:responseData];
                         
                         Status *statusObj = [AppDelegate objSharedAppDel].filterBaseObj.data.status;
                         
                         NSMutableDictionary *aDictTemp = [NSMutableDictionary dictionary];
                         [aDictTemp setObject:@"Other" forKey:@"reason"];
                         [aDictTemp setObject:@"0" forKey:@"reason_id"];
                         
                         Cancelled *cancelledObj = [Cancelled modelObjectWithDictionary:aDictTemp];
                         Missed *missedObj = [Missed modelObjectWithDictionary:aDictTemp];
                         
                         [statusObj.cancelled insertObject:cancelledObj atIndex:statusObj.cancelled.count];
                         [statusObj.missed insertObject:missedObj atIndex:statusObj.missed.count];
                         
                         if(responseData[@"data"][@"driver_permission"])
                         {
                             
                             sharedFMS_UtilityObj.dictPermissions = [[NSDictionary alloc] initWithDictionary:responseData[@"data"][@"driver_permission"]];
                             
                         }
                         
                     }
                     //completionBlock((NSMutableDictionary *)responseData);
                     
                 }
                 
             }
                                withFailureBlock:^(NSError *error)
             {
                 failureBlock(error);
             }];
            
            
            
        });
    });
    
}


+(BOOL)checkIfIncomplete:(NSString *)aStrvalue
{
    NSString *value = [aStrvalue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([value length]==0) {
        return NO;
    }
    else
        return YES;
}


+(BOOL)checkIfIncomplete:(NSString *)aStrvalue withMessage:(NSString *)message
{
    NSString *value = [aStrvalue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([value length]==0) {
        [self showAlert:message];
        return NO;
    }
    else
        return YES;
}
-(void)clearBadge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)logOutForNavigationControl
{
    //login screen exist in stack
    //[self.navigationController popToRootViewControllerAnimated:TRUE];
    
    if([AppDelegate objSharedAppDel].drawerController)
    {
        
        UINavigationController *aNavRootCtrl =[AppDelegate objSharedAppDel].navCntrl;
        
        NSMutableArray *aMutArr= [NSMutableArray arrayWithArray:aNavRootCtrl.viewControllers];
        
        //New CR Changes
        
        BOOL isLoginExist=FALSE;
        for (id aIdObj in aMutArr)
        {
            if([aIdObj isKindOfClass:[FMS_MainVC class]])
            {
                isLoginExist = TRUE;
            }
        }
        
        
        if(!isLoginExist)
        {
            UIStoryboard *aStoryboardObj = [UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil];
            FMS_MainVC *aFMS_MainVCObj = [aStoryboardObj instantiateViewControllerWithIdentifier:@"FMS_MainVC"];
            [aMutArr insertObject:aFMS_MainVCObj atIndex:0];
            
            [aNavRootCtrl setViewControllers:aMutArr];
        }
        /*
         BOOL isLoginExist=FALSE;
         for (id aIdObj in aMutArr)
         {
         if([aIdObj isKindOfClass:[FMS_LoginVC class]])
         {
         isLoginExist = TRUE;
         }
         }
         
         
         if(!isLoginExist)
         {
         UIStoryboard *aStoryboardObj = [UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil];
         FMS_LoginVC *aFMS_LoginVCObj = [aStoryboardObj instantiateViewControllerWithIdentifier:@"FMS_LoginVC"];
         [aMutArr insertObject:aFMS_LoginVCObj atIndex:0];
         
         [aNavRootCtrl setViewControllers:aMutArr];
         }
         */
        
        
        [AppDelegate objSharedAppDel].drawerController = nil;
        
        [FMS_Utility sharedFMSUtility].boolTokenUpdated =  FALSE;
        
        [UserDefaults removeObjectForKey:FMS_LoginUserId];
        [UserDefaults removeObjectForKey:FMS_LoginUserType];
        [UserDefaults removeObjectForKey:FMS_LoginUserName];
        [UserDefaults removeObjectForKey:FMS_LoginUserToken];
        [UserDefaults removeObjectForKey:FMS_LoginUserAvtar];
        [UserDefaults removeObjectForKey:FMS_LoggedInUserPermission];
        [UserDefaults synchronize];
        
        [aNavRootCtrl popToRootViewControllerAnimated:TRUE];
        
    }
}
-(void)updateUserPermission:(NSDictionary*)aDictRef
{
    if([FMS_Utility isLoginFromDriver])
    {
        NSArray *aArrCurrentPermission = [UserDefaults objectForKey:FMS_LoggedInUserPermission];
        NSArray *aArrPermissions = aDictRef[@"permission"];
        
        if(aArrPermissions && [aArrPermissions isKindOfClass:[NSArray class]])
        {
            if(![aArrCurrentPermission isEqualToArray:aArrPermissions] && aArrCurrentPermission)
            {
                [sharedFMS_UtilityObj showAlertWithTarget:self WithMessage:@"Your access permission has been changed by your contractor." withCancelButton:@"Ok" WithCompletionBlock:^(int index) {
                    
                    NSDictionary *aDictObj = [[NSDictionary alloc] initWithObjectsAndKeys:[UserDefaults objectForKey:FMS_LoginUserType],@"role",[UserDefaults objectForKey:FMS_LoginUserToken],@"token", nil];
                    
                    Webservice *WebserviceObj = [[Webservice alloc] init];
                    [WebserviceObj callWebserviceWithURL:[NSString stringWithFormat:@"%@/users/logout",FMS_WSURL] withSilentCall:TRUE withParams:aDictObj forViewController:nil  withCompletionBlock:^(NSDictionary *responseData)
                     {
                         if([responseData[@"status"] intValue]==1)
                         {
                             
                             [[FMS_Utility sharedFMSUtility] clearBadge];
                             
                             [[FMS_Utility sharedFMSUtility] logOutForNavigationControl];
                         }
                         else
                         {
                             [FMS_Utility showAlert:responseData[@"message"]];
                         }
                         
                     }
                                        withFailureBlock:^(NSError *error)
                     {
                         
                     }];
                    
                    
                    
                    
                } withOtherButtons:nil];
            }
            else
            {
                aArrCurrentPermission = [NSArray arrayWithArray:aArrPermissions];
                
                [UserDefaults setObject:aArrCurrentPermission forKey:FMS_LoggedInUserPermission];
                [UserDefaults synchronize];
                
            }
        }
        
    }
    
    
    
    
}
+(NSMutableAttributedString*)appednDollarToText:(NSString*)strToAppend
{
    NSDictionary *dollarFont = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Roboto-Regular" size:12],NSFontAttributeName,[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5],NSForegroundColorAttributeName,nil];
    
    NSDictionary *amountFont = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Roboto-Regular" size:12],NSFontAttributeName,[UIColor colorWithRed:0.2627 green:0.7059 blue:0.2902 alpha:1.0],NSForegroundColorAttributeName,nil];
    
    NSMutableAttributedString *strString = [[NSMutableAttributedString alloc] init];
    [strString appendAttributedString:[[NSAttributedString alloc] initWithString:@"$ " attributes:dollarFont]];
    [strString appendAttributedString:[[NSAttributedString alloc] initWithString:strToAppend attributes:amountFont]];
    return strString;
}

@end
