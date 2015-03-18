//
//  CityModel.h
//  LeftShiftsOpenweather
//
//  Created by AshU on 3/19/15.
//  Copyright (c) 2015 Ashish Khobragade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property(nonatomic,strong) NSString *cityId;
@property(nonatomic,strong) NSString * cityName;
@property(nonatomic,strong) NSMutableArray * cityTemperatureDetailsArray;


+ (CityModel *)cityModelFromDictionary:(NSDictionary *)dictionary;
@end
