//
//  FDGraphViewController.h
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 Wray,Brendan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDGraphViewController : UIViewController
// <NSDate *, NSNumber *>
@property (strong, nonatomic) NSDictionary *dataPoints;
// How many days the graph displays
@property (nonatomic) NSUInteger lookbackLength;
@end
