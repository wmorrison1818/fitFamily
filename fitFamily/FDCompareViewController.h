//
//  FDCompareViewController.h
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FDActivityGraphViewController.h"

@interface FDCompareViewController : UIViewController

// views for the graphs to subview
@property (weak, nonatomic) IBOutlet UIView *fitbitView;
@property (weak, nonatomic) IBOutlet UIView *fitBarkView;
// Statement about your activity relative to dog
@property (weak, nonatomic) IBOutlet UILabel *activityCompare;
@property (weak, nonatomic) IBOutlet UILabel *userActivity;
@property (weak, nonatomic) IBOutlet UILabel *dogActivity;
// Data for graphs
@property (strong, nonatomic) NSDictionary *fitbitResults;
@property (strong, nonatomic) NSDictionary *fitBarkResults;
// Graph views
@property (strong, nonatomic) FDActivityGraphViewController *fitbitGraph;
@property (strong, nonatomic) FDActivityGraphViewController *fitBarkGraph;
// Submit request to retrieve fitbit/FitBark activity
- (IBAction)fitbitSubmit:(id)sender;
- (IBAction)fitBarkSubmit:(id)sender;
// Refresh fitbit/fitBark graphs if logged in
- (void)refreshGraphs;

@end

