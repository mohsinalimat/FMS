//
//  Webservice.m
//  Nobby
//
//  Created by ind563 on 7/21/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "Webservice.h"
#import "AFNetworking.h"
@implementation Webservice

-(void)callWebserviceWithURL:(NSString *)aStrURL withSilentCall:(BOOL)boolIsSilent withParams:(NSDictionary *)aDict forViewController:(UIViewController*)aVCObj withCompletionBlock:(void(^)(NSDictionary * responseData))completionBlock withFailureBlock:(void(^)(NSError * error))failureBlock
{
    NSLog(@"callWebserviceWithURL called");
    NSLog(@"aStrURL===%@",aStrURL);
    NSLog(@"aDict===%@",aDict);
    
    if([[FMS_Utility sharedFMSUtility] checkNetworkStatus])
    {
         if(!boolIsSilent)
        [ProgressHUD show:@"Please wait" Interaction:false];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setTimeoutInterval:10];
        [manager POST:aStrURL parameters:aDict success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
             NSLog(@"responseObject===%@",responseObject);
        
            if(!boolIsSilent)
            [ProgressHUD dismiss];
            
            if([responseObject[@"status"] intValue]==0)
            {
                if([responseObject[@"code"] intValue]==101 || [responseObject[@"code"] intValue]==102)
                {
                    if(aVCObj)
                    {
                        if(!boolIsSilent)
                        {
                            [[FMS_Utility sharedFMSUtility] logOutForNavigationControl];
                            [FMS_Utility  showAlert:responseObject[@"message"]];
                        }
                    }
                }
                else
                {
                    completionBlock((NSMutableDictionary *)responseObject);
                }
            }
            else
            {
                completionBlock((NSMutableDictionary *)responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             if(!boolIsSilent)
             {
                 NSLog(@"error===%@",error.description);
                 [ProgressHUD dismiss];
                 failureBlock(error);
                 [FMS_Utility  showAlert:@"Some problem occured,please try again later."];
             }
        }];
    }
    else
    {
        if(!boolIsSilent)
        {
            [ProgressHUD dismiss];
            
            [FMS_Utility  showAlert:@"Please check your internet connection."];
        }
    }
}



-(void)callWebserviceWithGET:(NSString *)aStrURL withSilentCall:(BOOL)boolIsSilent withParams:(NSDictionary *)aDict forViewController:(UIViewController*)aVCObj withCompletionBlock:(void(^)(NSDictionary * responseData))completionBlock withFailureBlock:(void(^)(NSError * error))failureBlock
{
    NSLog(@"callWebserviceWithURL called");
    NSLog(@"aStrURL===%@",aStrURL);
    NSLog(@"aDict===%@",aDict);
    
    if([[FMS_Utility sharedFMSUtility] checkNetworkStatus])
    {
        if(!boolIsSilent)
            [ProgressHUD show:@"Please wait" Interaction:false];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setTimeoutInterval:10];
        
        
        [manager GET:aStrURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if(!boolIsSilent)
                [ProgressHUD dismiss];
            
            if([responseObject[@"status"] intValue]==0)
            {
                if([responseObject[@"code"] intValue]==101 || [responseObject[@"code"] intValue]==102)
                {
                    if(aVCObj)
                    {
                        if(!boolIsSilent)
                        {
                            [[FMS_Utility sharedFMSUtility] logOutForNavigationControl];
                            [FMS_Utility  showAlert:responseObject[@"message"]];
                        }
                    }
                }
                else
                {
                    completionBlock((NSMutableDictionary *)responseObject);
                }
            }
            else
            {
                completionBlock((NSMutableDictionary *)responseObject);
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
            
            if(!boolIsSilent)
            {
                NSLog(@"error===%@",error.description);
                [ProgressHUD dismiss];
                failureBlock(error);
                [FMS_Utility  showAlert:@"Some problem occured,please try again later."];
            }
        }];
    }
    else
    {
        if(!boolIsSilent)
        {
            [ProgressHUD dismiss];
            
            [FMS_Utility  showAlert:@"Please check your internet connection."];
        }
    }
}


-(void)callWebserviceToUploadImageWithURL:(NSString *)aStrURL withSilentCall:(BOOL)boolIsSilent withParams:(NSMutableDictionary *)aDict forViewController:(UIViewController*)aVCObj withCompletionBlock:(void(^)(NSDictionary * responseData))completionBlock withFailureBlock:(void(^)(NSError * error))failureBlock
{
    NSLog(@"callWebserviceWithURL called");
    NSLog(@"aStrURL===%@",aStrURL);
    NSLog(@"aDict===%@",aDict);
    
    
    if([[FMS_Utility sharedFMSUtility] checkNetworkStatus])
    {
        if(!boolIsSilent)
            [ProgressHUD show:@"Please wait" Interaction:TRUE];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSData *imageData1;
        NSString *aStrParamName1;
        if (aDict[@"Image1"] != nil)
        {
            UIImage *aImage =aDict[@"Image1"];
            imageData1= UIImageJPEGRepresentation(aImage, 0.3);
            aStrParamName1 = aDict[@"ParamName1"];
            [aDict removeObjectForKey:@"ParamName1"];
            [aDict removeObjectForKey:@"Image1"];
        }
        
        NSData *imageData2;
        NSString *aStrParamName2;
        if (aDict[@"Image2"] != nil)
        {
            UIImage *aImage =aDict[@"Image2"];
            imageData2 = UIImageJPEGRepresentation(aImage, 0.3);
            aStrParamName2 = aDict[@"ParamName2"];
            [aDict removeObjectForKey:@"ParamName2"];
            [aDict removeObjectForKey:@"Image2"];
        }
        
        [manager POST:aStrURL parameters:aDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            if (aStrParamName1 !=nil)
            {
                [formData appendPartWithFileData:imageData1 name:aStrParamName1 fileName:@"image1.jpg" mimeType:@"image/jpeg"];
            }
            if (aStrParamName2 !=nil)
            {
                [formData appendPartWithFileData:imageData2 name:aStrParamName2 fileName:@"image2.jpg" mimeType:@"image/jpeg"];
            }
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject===%@",responseObject);
            
            if(!boolIsSilent)
                [ProgressHUD dismiss];
            
            if([responseObject[@"status"] intValue]==0)
            {
                if([responseObject[@"code"] intValue]==101 || [responseObject[@"code"] intValue]==102)
                {
                    if(aVCObj)
                    {
                        if(!boolIsSilent)
                        {
                            [[FMS_Utility sharedFMSUtility] logOutForNavigationControl];
                            [FMS_Utility  showAlert:responseObject[@"message"]];
                        }
                    }
                }
                else
                {
                    completionBlock((NSMutableDictionary *)responseObject);
                }
            }
            else
            {
                completionBlock((NSMutableDictionary *)responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(!boolIsSilent)
            {
                NSLog(@"error===%@",error.description);
                [ProgressHUD dismiss];
                failureBlock(error);
                [FMS_Utility  showAlert:@"Some problem occured,please try again later."];
            }
            
        }];
    }
    else
    {
        if(!boolIsSilent)
        {
            [ProgressHUD dismiss];
            
            [FMS_Utility  showAlert:@"Please check your internet connection."];
        }
        
    }

}
@end
