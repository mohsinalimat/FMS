//
//  FMS_DeliveredVC.h
//  FMS
//
//  Created by indianic on 06/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMS_DeliveredVC : UIViewController
{
    NSString *strCurrentType;
    NSMutableArray *mutArrData;
    int intMaxPageNumber;
    int intPageNumber;
    NSMutableDictionary *mutDictFilter;
    int intSelectedIndex;
    __weak IBOutlet UILabel *lblTotalEarning;
    
    __weak IBOutlet UILabel *lblTotalMiles;
    __weak IBOutlet UILabel *lblNoData;
    __weak IBOutlet UITextField *txtFldDateFrom;
    __weak IBOutlet UITextField *txtFldDateTo;
    
    CGRect rectTableFrame;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tblVWLoads;
- (IBAction)btnFilterClick:(UIButton *)sender;
@end
