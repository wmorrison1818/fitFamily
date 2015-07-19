//
//  FDCompareViewController.h
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDGraphViewController.h"

@interface FDCompareViewController : UIViewController

// Text fields to enter fit IDs
@property (weak, nonatomic) IBOutlet UITextField *fitbitID;
@property (weak, nonatomic) IBOutlet UITextField *fitBarkID;
// views for the graphs to subview
@property (weak, nonatomic) IBOutlet UIView *fitbitView;
@property (weak, nonatomic) IBOutlet UIView *fitBarkView;
// Statement about your activity relative to dog
@property (weak, nonatomic) IBOutlet UILabel *activityCompare;
// Data for graphs
@property (strong, nonatomic) NSDictionary *fitbitResults;
@property (strong, nonatomic) NSDictionary *fitBarkResults;
// Graph views
@property (strong, nonatomic) FDGraphViewController *fitbitGraph;
@property (strong, nonatomic) FDGraphViewController *fitBarkGraph;
// Submit request to retrieve fitbit/FitBark activity
- (IBAction)fitbitSubmit:(id)sender;
- (IBAction)fitBarkSubmit:(id)sender;

@end

