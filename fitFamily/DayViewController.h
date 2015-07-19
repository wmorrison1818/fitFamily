//
//  DayViewController.h
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FDDailyActivity.h"


@interface DayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *testReceive;

// Activity for today to compare
@property (strong, nonatomic) FDDailyActivity *userActivity;
@property (strong, nonatomic) FDDailyActivity *dogActivity;

@end
