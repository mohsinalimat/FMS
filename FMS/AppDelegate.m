//
//  AppDelegate.m
//  FMS
//
//  Created by indianic on 05/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "AppDelegate.h"

#import "FMS_LeftVC.h"

#import "FMS_LoginVC.h"

#import "FMS_MainVC.h"

#import "FMS_LoadDetailVC.h"

#import "FMS_DeliveredHistoryVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize filterBaseObj,navCntrl,locationManager;

+(AppDelegate *)objSharedAppDel
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[FMS_Utility sharedFMSUtility] clearBadge];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != NULL)
    {
        
        [[FMS_Utility sharedFMSUtility] setDictNotification:userInfo];
        [[FMS_Utility sharedFMSUtility] setIsFromNotification:TRUE];
        
    }
    
    if(isIOS8)
    {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    else
    {
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }

    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
     [[UINavigationBar appearance] setBarTintColor:FMS_GreenColor];


    self.navCntrl = (UINavigationController *)[[UIStoryboard storyboardWithName:FMS_StoryboardMain bundle:nil]instantiateViewControllerWithIdentifier:@"FMS_RootNavVC"];
    [self.navCntrl setNavigationBarHidden:YES animated:YES];

    
//    if(![UserDefaults objectForKey:FMS_LoggedInUserPermission])
//    {
//        [UserDefaults setObject:[[NSMutableArray alloc] init] forKey:FMS_LoggedInUserPermission];
//         [UserDefaults synchronize];
//    }
//   
    
    if(![UserDefaults objectForKey:FMS_LoginUserId])
    {
//        FMS_LoginVC *objFMS_LeftVC = (FMS_LoginVC *)[[UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_LoginVC"];
//        
//        [self.navCntrl setViewControllers:@[objFMS_LeftVC] animated:NO];
        
        
        FMS_MainVC *objFMS_MainVC = (FMS_MainVC *)[[UIStoryboard storyboardWithName:FMS_StoryboardSecondary bundle:nil] instantiateViewControllerWithIdentifier:@"FMS_MainVC"];
        
        [self.navCntrl setViewControllers:@[objFMS_MainVC] animated:NO];
        
    }
    else
    {
        [self getAPICallProfileCheck];
        
//            [[FMS_Utility sharedFMSUtility] setDrawerToUse];
//            [self.navCntrl setViewControllers:@[self.drawerController] animated:NO];
    }
    
    [self initializeLocatioManager];
    
    [self.window setRootViewController:self.navCntrl];
    
    [self.window makeKeyAndVisible];
    
    
    
        
    // Override point for customization after application launch.
    return YES;
}

-(void)getAPICallProfileCheck
{
    
    Webservice *WebserviceObj = [[Webservice alloc] init];
    NSMutableDictionary  * aDictParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[UserDefaults objectForKey:FMS_LoginUserToken],@"token",
                                          [UserDefaults objectForKey:FMS_LoginUserType],@"role",nil];
    
    
    [WebserviceObj callWebserviceToUploadImageWithURL:[NSString stringWithFormat:@"%@/users/check_profile",FMS_WSURL] withSilentCall:NO withParams:aDictParams forViewController:self withCompletionBlock:^(NSDictionary *responseData) {
        
        if([responseData[@"status"] intValue] == 1 )
        {
            
            
            if([responseData[@"profile_status"] intValue] == 1 )
            {
                
//                UDSetObject([responseData valueForKey:@"profile_status"], FMS_LoginProfileStatus);

                UDSetObject([responseData valueForKey:@"profile_status"], FMS_LoginProfileStatus);

                [[FMS_Utility sharedFMSUtility] setDrawerToUseProfile];
                [self.navCntrl setViewControllers:@[self.drawerController] animated:NO];
            
            }else{
                
                UDSetObject([responseData valueForKey:@"profile_status"], FMS_LoginProfileStatus);

                [[FMS_Utility sharedFMSUtility] setDrawerToUse];
                [self.navCntrl setViewControllers:@[self.drawerController] animated:NO];
            }
            
            NSLog(@" Profile stsus %@",[responseData valueForKey:@"profile_status"]);

        }
        else
        {
            [FMS_Utility showAlert:responseData[@"message"]];
        }
        
        
    } withFailureBlock:^(NSError *error) {
        
    }];
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[FMS_Utility sharedFMSUtility] clearBadge];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ----------------------
#pragma mark Other Methods
-(void)initializeLocatioManager
{
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //    locationManager.distanceFilter=20.0;
    }

    
    if (isIOS8)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark ----------------------
#pragma mark CLLocationManager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(isIOS8)
    {
        if(status ==kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [self initializeLocatioManager];
        }
    }
    else
    {
        if(status ==kCLAuthorizationStatusAuthorized)
        {
            [self initializeLocatioManager];
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSLog(@"didUpdateToLocation called %@",newLocation);
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        NSString*aStrLat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
        NSString*aStrLong = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
        
        [UserDefaults setObject:aStrLat forKey:FMS_Latitude];
        [UserDefaults setObject:aStrLong forKey:FMS_Longitude];
        [UserDefaults synchronize];
    }
}

#pragma mark ----------------------
#pragma mark Push Notification Delegate Methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    
    //convert token to device ID
    
    
    [FMS_Utility sharedFMSUtility].boolTokenUpdated = FALSE;
    
    
    NSString *aStrToken = [NSString
                           stringWithFormat:@"%@",deviceToken];
    NSString *aStrFiltered = [aStrToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    aStrFiltered = [aStrFiltered stringByReplacingOccurrencesOfString:@"<" withString:@""];
    aStrFiltered = [aStrFiltered stringByReplacingOccurrencesOfString:@">" withString:@""];

    
    
    

    [UserDefaults setObject:[NSString stringWithString:aStrFiltered] forKey:FMS_deviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"strdevicetoken: %@",aStrFiltered);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err  {
    
    [NSString stringWithFormat: @"Error: %@", err];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [[FMS_Utility sharedFMSUtility] clearBadge];
    
    if([[UserDefaults objectForKey:FMS_LoginUserToken] length]>0)
    {
        //'New Load','Update Load','Assigned','Arrived','Picked up','Delivered','Missed','Other'
        NSString *aStrType = userInfo[@"aps"][@"object_type"];
        
        NSArray *aArrNavRequiredStatus = [NSArray arrayWithObjects:@"Arrived",@"Picked up",@"Assigned",@"Delivered",@"New Load", nil];
        
        if([aArrNavRequiredStatus containsObject:aStrType])
        {
            [[FMS_Utility sharedFMSUtility] showAlertWithTarget:self WithMessage:[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]] withCancelButton:@"Show" WithCompletionBlock:^(int index)
             {
                 if(index==0)
                 {
                     if([aStrType isEqualToString:@"Delivered"])
                     {
                         UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:FMS_StoryboardMain bundle:nil];
                         FMS_DeliveredHistoryVC *FMS_DeliveredHistoryVCObj = [aStoryBoardObj instantiateViewControllerWithIdentifier:@"FMS_DeliveredHistoryVC"];
                         FMS_DeliveredHistoryVCObj.strOrderID = userInfo[@"aps"][@"object_id"];
                         FMS_DeliveredHistoryVCObj.showRightButtons = FALSE;
                         [self.navCntrl setNavigationBarHidden:FALSE];
                         [self.navCntrl pushViewController:FMS_DeliveredHistoryVCObj animated:TRUE];

                     }
                     else
                     {
                         UIStoryboard *aStoryBoardObj = [UIStoryboard storyboardWithName:FMS_StoryboardMain bundle:nil];
                         FMS_LoadDetailVC *FMS_LoadDetailVCObj = [aStoryBoardObj instantiateViewControllerWithIdentifier:@"FMS_LoadDetailVC"];
                         
                         if([aStrType isEqualToString:@"New Load"])
                         {
                             FMS_LoadDetailVCObj.isLoadDetail = YES;
                         }
                         else
                         {
                             FMS_LoadDetailVCObj.isLoadDetail = NO;
                         }
                         
                         FMS_LoadDetailVCObj.showRightButtons = FALSE;
                         
                         FMS_LoadDetailVCObj.strLoadId = userInfo[@"aps"][@"object_id"];
                         [self.navCntrl setNavigationBarHidden:FALSE];
                         [self.navCntrl pushViewController:FMS_LoadDetailVCObj animated:TRUE];

                     }
   
                 }
                 else
                 {
                     
                 }
                 
             } withOtherButtons:[NSArray arrayWithObject:@"Cancel"]];

        }
        else
        {
            [FMS_Utility showAlert:userInfo[@"aps"][@"alert"]];

        }

    }
}

@end
