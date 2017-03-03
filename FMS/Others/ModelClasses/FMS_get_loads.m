//
//  FMS_get_loads.m
//
//  Created by   on 24/08/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FMS_get_loads.h"


NSString *const kFMS_get_loadsDriverId = @"driver_id";
NSString *const kFMS_get_loadsToLocation = @"to_location";
NSString *const kFMS_get_loadsOrderId = @"order_id";
NSString *const kFMS_get_loadsFromLocation = @"from_location";
NSString *const kFMS_get_loadsPrice = @"price";
NSString *const kFMS_get_loadsDate = @"date";
NSString *const kFMS_get_loadsLoadId = @"load_id";
NSString *const kFMS_get_loadsCommodity = @"commodity";
NSString *const kFMS_get_loadsDriverName = @"driver_name";
NSString *const kFMS_get_loadsEarning = @"earning";
NSString *const kFMS_get_loadsOrderModified = @"order_modified";
NSString *const kFMS_get_loadsLoadCount = @"load_count";
NSString *const kFMS_get_loadsMissedReason = @"missed_reason";
NSString *const kFMS_get_loadsTicketNo = @"ticket_no";
NSString *const kFMS_get_loadsQuantity = @"quantity";
NSString *const kFMS_get_loadsUnit = @"unit";
NSString *const kFMS_get_loadsToCity = @"to_city";
NSString *const kFMS_get_loadsFromCity = @"from_city";
NSString *const kFMS_get_loadsAdminVerified= @"admin_verified";
NSString *const kFMS_get_loadsStatus= @"status";


NSString *const kFMS_get_loadsMile= @"mile";
NSString *const kFMS_get_loadsTotal_earning= @"total_earning";
NSString *const kFMS_get_loadsSTotal_miles= @"total_miles";



//mile;
//total_earning
//total_miles;

@interface FMS_get_loads ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FMS_get_loads

@synthesize driverId = _driverId;
@synthesize toLocation = _toLocation;
@synthesize orderId = _orderId;
@synthesize fromLocation = _fromLocation;
@synthesize price = _price;
@synthesize date = _date;
@synthesize loadId = _loadId;
@synthesize commodity = _commodity;
@synthesize driverName = _driverName;
@synthesize earning = _earning;
@synthesize orderModified = _orderModified;
@synthesize loadCount = _loadCount;
@synthesize missedReason = _missedReason;
@synthesize ticketNo = _ticketNo;
@synthesize unit = _unit;
@synthesize quantity = _quantity;
@synthesize toCity = _toCity;
@synthesize fromCity = _fromCity;
@synthesize adminVerified = _adminVerified;
@synthesize status = _status;

@synthesize mile = _mile;
@synthesize totalEarning = _totalEarning;
@synthesize totalMiles = _totalMiles;


//mile;
//totalEarning
//totalMiles;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.driverId = [self objectOrNilForKey:kFMS_get_loadsDriverId fromDictionary:dict];
            self.toLocation = [self objectOrNilForKey:kFMS_get_loadsToLocation fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kFMS_get_loadsOrderId fromDictionary:dict];
            self.fromLocation = [self objectOrNilForKey:kFMS_get_loadsFromLocation fromDictionary:dict];
            self.price = [self objectOrNilForKey:kFMS_get_loadsPrice fromDictionary:dict];
            self.date = [self objectOrNilForKey:kFMS_get_loadsDate fromDictionary:dict];
            self.loadId = [self objectOrNilForKey:kFMS_get_loadsLoadId fromDictionary:dict];
            self.commodity = [self objectOrNilForKey:kFMS_get_loadsCommodity fromDictionary:dict];
            self.driverName = [self objectOrNilForKey:kFMS_get_loadsDriverName fromDictionary:dict];
            self.earning = [self objectOrNilForKey:kFMS_get_loadsEarning fromDictionary:dict];
            self.orderModified = [self objectOrNilForKey:kFMS_get_loadsOrderModified fromDictionary:dict];
            self.loadCount = [self objectOrNilForKey:kFMS_get_loadsLoadCount fromDictionary:dict];
            self.missedReason = [self objectOrNilForKey:kFMS_get_loadsMissedReason fromDictionary:dict];
            self.ticketNo = [self objectOrNilForKey:kFMS_get_loadsTicketNo fromDictionary:dict];
            self.quantity = [self objectOrNilForKey:kFMS_get_loadsQuantity fromDictionary:dict];
            self.unit = [self objectOrNilForKey:kFMS_get_loadsUnit fromDictionary:dict];
            self.toCity = [self objectOrNilForKey:kFMS_get_loadsToCity fromDictionary:dict];
            self.fromCity = [self objectOrNilForKey:kFMS_get_loadsFromCity fromDictionary:dict];
            self.adminVerified = [self objectOrNilForKey:kFMS_get_loadsAdminVerified fromDictionary:dict];
            self.status = [self objectOrNilForKey:kFMS_get_loadsStatus fromDictionary:dict];
        
        
        
        self.mile = [self objectOrNilForKey:kFMS_get_loadsMile fromDictionary:dict];
        self.totalEarning = [self objectOrNilForKey:kFMS_get_loadsTotal_earning fromDictionary:dict];
        self.totalMiles = [self objectOrNilForKey:kFMS_get_loadsSTotal_miles fromDictionary:dict];

        
      
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.driverId forKey:kFMS_get_loadsDriverId];
    [mutableDict setValue:self.toLocation forKey:kFMS_get_loadsToLocation];
    [mutableDict setValue:self.orderId forKey:kFMS_get_loadsOrderId];
    [mutableDict setValue:self.fromLocation forKey:kFMS_get_loadsFromLocation];
    [mutableDict setValue:self.price forKey:kFMS_get_loadsPrice];
    [mutableDict setValue:self.date forKey:kFMS_get_loadsDate];
    [mutableDict setValue:self.loadId forKey:kFMS_get_loadsLoadId];
    [mutableDict setValue:self.commodity forKey:kFMS_get_loadsCommodity];
    [mutableDict setValue:self.driverName forKey:kFMS_get_loadsDriverName];
    [mutableDict setValue:self.earning forKey:kFMS_get_loadsEarning];
    [mutableDict setValue:self.orderModified forKey:kFMS_get_loadsOrderModified];
    [mutableDict setValue:self.loadCount forKey:kFMS_get_loadsLoadCount];
    [mutableDict setValue:self.missedReason forKey:kFMS_get_loadsMissedReason];
    [mutableDict setValue:self.ticketNo forKey:kFMS_get_loadsTicketNo];
    [mutableDict setValue:self.quantity forKey:kFMS_get_loadsQuantity];
    [mutableDict setValue:self.unit forKey:kFMS_get_loadsUnit];
    [mutableDict setValue:self.toCity forKey:kFMS_get_loadsToCity];
    [mutableDict setValue:self.fromCity forKey:kFMS_get_loadsFromCity];
    [mutableDict setValue:self.adminVerified forKey:kFMS_get_loadsAdminVerified];
    [mutableDict setValue:self.status forKey:kFMS_get_loadsStatus];
    
    
    [mutableDict setValue:self.mile forKey:kFMS_get_loadsMile];
    [mutableDict setValue:self.totalEarning forKey:kFMS_get_loadsTotal_earning];
    [mutableDict setValue:self.totalMiles forKey:kFMS_get_loadsSTotal_miles];
    

  
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.driverId = [aDecoder decodeObjectForKey:kFMS_get_loadsDriverId];
    self.toLocation = [aDecoder decodeObjectForKey:kFMS_get_loadsToLocation];
    self.orderId = [aDecoder decodeObjectForKey:kFMS_get_loadsOrderId];
    self.fromLocation = [aDecoder decodeObjectForKey:kFMS_get_loadsFromLocation];
    self.price = [aDecoder decodeObjectForKey:kFMS_get_loadsPrice];
    self.date = [aDecoder decodeObjectForKey:kFMS_get_loadsDate];
    self.loadId = [aDecoder decodeObjectForKey:kFMS_get_loadsLoadId];
    self.commodity = [aDecoder decodeObjectForKey:kFMS_get_loadsCommodity];
    self.driverName = [aDecoder decodeObjectForKey:kFMS_get_loadsDriverName];
    self.earning = [aDecoder decodeObjectForKey:kFMS_get_loadsEarning];
    self.orderModified = [aDecoder decodeObjectForKey:kFMS_get_loadsOrderModified];
    self.loadCount = [aDecoder decodeObjectForKey:kFMS_get_loadsLoadCount];
    self.missedReason = [aDecoder decodeObjectForKey:kFMS_get_loadsMissedReason];
    self.ticketNo = [aDecoder decodeObjectForKey:kFMS_get_loadsTicketNo];
    self.quantity = [aDecoder decodeObjectForKey:kFMS_get_loadsQuantity];
    self.unit = [aDecoder decodeObjectForKey:kFMS_get_loadsUnit];
    self.toCity = [aDecoder decodeObjectForKey:kFMS_get_loadsToCity];
    self.fromCity = [aDecoder decodeObjectForKey:kFMS_get_loadsFromCity];
    self.adminVerified = [aDecoder decodeObjectForKey:kFMS_get_loadsAdminVerified];
    self.status = [aDecoder decodeObjectForKey:kFMS_get_loadsStatus];
    
    
    self.mile = [aDecoder decodeObjectForKey:kFMS_get_loadsMile];
    self.totalEarning = [aDecoder decodeObjectForKey:kFMS_get_loadsTotal_earning];
    self.totalMiles = [aDecoder decodeObjectForKey:kFMS_get_loadsSTotal_miles];
    
    
   
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_driverId forKey:kFMS_get_loadsDriverId];
    [aCoder encodeObject:_toLocation forKey:kFMS_get_loadsToLocation];
    [aCoder encodeObject:_orderId forKey:kFMS_get_loadsOrderId];
    [aCoder encodeObject:_fromLocation forKey:kFMS_get_loadsFromLocation];
    [aCoder encodeObject:_price forKey:kFMS_get_loadsPrice];
    [aCoder encodeObject:_date forKey:kFMS_get_loadsDate];
    [aCoder encodeObject:_loadId forKey:kFMS_get_loadsLoadId];
    [aCoder encodeObject:_commodity forKey:kFMS_get_loadsCommodity];
    [aCoder encodeObject:_driverName forKey:kFMS_get_loadsDriverName];
    [aCoder encodeObject:_earning forKey:kFMS_get_loadsEarning];
    [aCoder encodeObject:_orderModified forKey:kFMS_get_loadsOrderModified];
    [aCoder encodeObject:_loadCount forKey:kFMS_get_loadsLoadCount];
    [aCoder encodeObject:_missedReason forKey:kFMS_get_loadsMissedReason];
    [aCoder encodeObject:_ticketNo forKey:kFMS_get_loadsTicketNo];
    [aCoder encodeObject:_quantity forKey:kFMS_get_loadsQuantity];
    [aCoder encodeObject:_unit forKey:kFMS_get_loadsUnit];
    [aCoder encodeObject:_toCity forKey:kFMS_get_loadsToCity];
    [aCoder encodeObject:_fromCity forKey:kFMS_get_loadsFromCity];
    [aCoder encodeObject:_adminVerified forKey:kFMS_get_loadsAdminVerified];
    [aCoder encodeObject:_status forKey:kFMS_get_loadsStatus];
    
    [aCoder encodeObject:_mile forKey:kFMS_get_loadsMile];
    [aCoder encodeObject:_totalEarning forKey:kFMS_get_loadsTotal_earning];
    [aCoder encodeObject:_totalMiles forKey:kFMS_get_loadsSTotal_miles];
    

}

- (id)copyWithZone:(NSZone *)zone
{
    FMS_get_loads *copy = [[FMS_get_loads alloc] init];
    
    if (copy) {

        copy.driverId = [self.driverId copyWithZone:zone];
        copy.toLocation = [self.toLocation copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.fromLocation = [self.fromLocation copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.date = [self.date copyWithZone:zone];
        copy.loadId = [self.loadId copyWithZone:zone];
        copy.commodity = [self.commodity copyWithZone:zone];
        copy.driverName = [self.driverName copyWithZone:zone];
        copy.earning = [self.earning copyWithZone:zone];
        copy.orderModified = [self.orderModified copyWithZone:zone];
        copy.loadCount = [self.loadCount copyWithZone:zone];
        copy.missedReason = [self.missedReason copyWithZone:zone];
        copy.ticketNo = [self.ticketNo copyWithZone:zone];
        copy.quantity = [self.quantity copyWithZone:zone];
        copy.unit = [self.unit copyWithZone:zone];
        copy.toCity = [self.toCity copyWithZone:zone];
        copy.fromCity = [self.fromCity copyWithZone:zone];
        copy.adminVerified = [self.adminVerified copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        
        
        copy.mile = [self.mile copyWithZone:zone];
        copy.totalEarning = [self.totalEarning copyWithZone:zone];
        copy.totalMiles = [self.totalMiles copyWithZone:zone];
        
        //mile;
        //totalEarning
        //totalMiles;
    }
    
    return copy;
}


@end
