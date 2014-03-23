//
//  MinMapData.m
//  MinMap
//
//  Created by Lori Hill on 3/22/14.
//  Copyright (c) 2014 Lori Hill. All rights reserved.
//

#import "MinMapData.h"

@implementation MinMapData

+ (instancetype) sharedInstance
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
		});
		return sharedInstance;
}
@end
