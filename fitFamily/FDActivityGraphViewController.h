//
//  FDGraphViewController.h
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDActivityGraphViewControllerDelegate;


@interface FDActivityGraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *activityRange;
@property (weak, nonatomic) IBOutlet UIView *activityPlot;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
// <FDDailyActivity *>
@property (copy, nonatomic) NSArray *activity;
// How many days the graph is displaying
@property (nonatomic, readonly) NSUInteger lookbackLength;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, weak) id <FDActivityGraphViewControllerDelegate>delegate;

// Average percent activity of target per day
- (CGFloat)averagePercentDoneForLookbackLength:(NSUInteger)lookbackLength;
@end


@protocol FDActivityGraphViewControllerDelegate <NSObject>

// Fired when lookbackLength changed
- (void)lookbackLengthDidChange:(FDActivityGraphViewController *)graphViewController;

@end