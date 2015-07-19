//
//  FDDailyActivity.m
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "FDDailyActivity.h"

@implementation FDDailyActivity

+ (instancetype)activityFromDictionary:(NSDictionary *)dictionary {
    FDDailyActivity *activity = [[FDDailyActivity alloc] init];
    
    activity.activity = [dictionary objectForKey:@"activity"];
    activity.percentDone = [dictionary objectForKey:@"percent_done"];
    activity.minActive = [dictionary objectForKey:@"min_active"];
    activity.minPlay = [dictionary objectForKey:@"min_play"];
    activity.minRest = [dictionary objectForKey:@"min_rest"];
    activity.target = [dictionary objectForKey:@"target"];
    activity.date = [dictionary objectForKey:@"date"];
    
    return activity;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ activity %@ percentDone %@ minActive %@ minPlay %@ minRest %@ target %@ date %@ %@", [super description], self.activity, self.percentDone, self.minActive, self.minPlay, self.minRest, self.target, [self.date class], self.date];
}

@end
