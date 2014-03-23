//
//  MinMapData.h
//  MinMap
//
//  Created by Lori Hill on 3/22/14.
//  Copyright (c) 2014 Lori Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MinMapData : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) BOOL neededProvided;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *formattedDateString;

+ (instancetype) sharedInstance;

@end
