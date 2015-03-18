//
//  CityModel.m
//  LeftShiftsOpenweather
//
//  Created by AshU on 3/19/15.
//  Copyright (c) 2015 Ashish Khobragade. All rights reserved.
//

#import "CityModel.h"
#import "CityDataModel.h"

@implementation CityModel

- (NSDictionary *)jsonMapping {
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"cityId",@"id",
            @"cityName",@"name",nil];
    
}



+ (CityModel *)cityModelFromDictionary:(NSDictionary *)dictionary {
    
    
    CityModel *cityModel = [[CityModel alloc] init];
    
    
    for (NSString *attribute in [dictionary allKeys]) {
        
        if ([attribute isEqualToString:@"city"]) {
            
            NSDictionary *mapping = [cityModel jsonMapping];
          
            NSDictionary *city =[dictionary  valueForKey:attribute];
            
            for (NSString *subAttribute in [mapping allKeys]) {
                
                NSString *classProperty = [mapping objectForKey:subAttribute];
                
                NSString *attributeValue = [city objectForKey:subAttribute];
                
                if (attributeValue!=nil&&!([attributeValue isKindOfClass:[NSNull class]])) {
                    
                    [cityModel setValue:attributeValue forKeyPath:classProperty];
                    
                }
            }
        }
        else if ([attribute isEqualToString:@"list"]){
            
         cityModel.cityTemperatureDetailsArray=[[NSMutableArray alloc] init];
            
            NSMutableArray *list =[dictionary objectForKey:attribute];
            
            for (int i=0; i< [list count];i++) {
                
                 NSDictionary *listDict =[list objectAtIndex:i];
                
                CityDataModel*cityDataModel =[[CityDataModel alloc] init];
                cityDataModel.date = [listDict valueForKey:@"dt"];
                cityDataModel.maxTemp =[[listDict valueForKey:@"temp"] valueForKey:@"max"];
                 cityDataModel.minTemp =[[listDict valueForKey:@"temp"] valueForKey:@"min"];
                
                [cityModel.cityTemperatureDetailsArray addObject:cityDataModel];
            }
        }
    }
    
    return cityModel;
    
}

@end
