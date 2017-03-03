//
//  FMS_DeliveredCell.h
//  FMS
//
//  Created by indianic on 12/08/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMS_DeliveredCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSourceLoc;
@property (weak, nonatomic) IBOutlet UILabel *lblDestLoc;
@property (weak, nonatomic) IBOutlet UILabel *lblLoads;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UILabel *lblEarning;
@property (weak, nonatomic) IBOutlet UILabel *lblLoadTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketNo;
@property (weak, nonatomic) IBOutlet UILabel *lblUnitName;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;
@property (weak, nonatomic) IBOutlet UIImageView *imgVWTruck;
@property (weak, nonatomic) IBOutlet UILabel *lblDriverName;
@property (weak, nonatomic) IBOutlet UILabel *lblMiles;


@end
