//
//  FDDailyActivity.h
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Object representing daily activity breakdown, total, and target
 */
@interface FDDailyActivity : NSObject
// Activity for the day
@property (nonatomic, strong) NSNumber *activity;
// activity/target * 100
@property (nonatomic, strong) NSNumber *percentDone;
// Min active (light/fair activity) during the day
@property (nonatomic, strong) NSNumber *minActive;
// Min at play (strenuous activity) during the day
@property (nonatomic, strong) NSNumber *minPlay;
// Min rest in the day
@property (nonatomic, strong) NSNumber *minRest;
// Target for daily activity
@property (nonatomic, strong) NSNumber *target;
// Date activity occurred
@property (nonatomic, strong) NSDate *date;
/* Dictionary with the following properties will populate the model object
 * {
 *   "activity": 9195,
 *   "percent_done": 91.95,
 *   "min_active": 311,
 *   "min_play": 5,
 *   "target": 10000,
 *   "date": "2015-06-18",
 *   "min_rest": 703
 * }
 */
+ (instancetype)activityFromDictionary:(NSDictionary *)dictionary;
@end
