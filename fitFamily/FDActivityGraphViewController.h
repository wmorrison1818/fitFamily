//
//  FDGraphViewController.h
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDActivityGraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *activityRange;
@property (weak, nonatomic) IBOutlet UIView *activityPlot;
// <FDDailyActivity *>
@property (copy, nonatomic) NSArray *activity;
// <NSDate *, NSNumber *>
@property (strong, nonatomic) NSDictionary *activityPoints;
@property (strong, nonatomic) NSDictionary *targetPoints;
// How many days the graph displays
@property (nonatomic) NSUInteger lookbackLength;
@end
