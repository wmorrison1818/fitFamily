//
//  FDGraphViewController.m
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "FDActivityGraphViewController.h"
#import <JBChartView/JBLineChartView.h>
#import "FDDailyActivity.h"

#define FDActivityLineIndex 0
#define FDTargetLineIndex 1
#define WEEK_SEGMENT_INDEX 0
#define WEEK_RANGE 7
#define MONTH_RANGE 30

@interface FDActivityGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>
@property (nonatomic, strong) JBLineChartView *chartView;
@end

@implementation FDActivityGraphViewController

- (void)dealloc {
    self.chartView.delegate = nil;
    self.chartView.dataSource = nil;
}

- (void)viewDidLoad {
    // Allow resize
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    
    self.activityPlot.translatesAutoresizingMaskIntoConstraints = YES;
    self.activityPlot.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    // Add chart view to activityPlot subview
    self.chartView = [[JBLineChartView alloc] init];
    self.chartView.translatesAutoresizingMaskIntoConstraints = YES;
    self.chartView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.chartView.frame = self.activityPlot.bounds;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    [self.activityPlot addSubview:self.chartView];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    self.view.frame = self.view.superview.bounds;
}

- (void)setActivity:(NSArray *)activity {
    _activity = activity;
    
    [self.chartView reloadData];
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    if (loading) {
        [self.spinner startAnimating];
    }
    else {
        [self.spinner stopAnimating];
    }
}

- (IBAction)segmentChanged:(id)sender {
    [self.chartView reloadData];
}

- (NSUInteger)lookbackLength {
    return self.activityRange.selectedSegmentIndex == WEEK_SEGMENT_INDEX ? WEEK_RANGE : MONTH_RANGE;
}

#pragma mark - JBLineChartViewDataSource

/**
 * One line if activity points are all that are set, two lines if target points are set as well
 */
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return self.activity ? 2 : 1;
}

/**
 * Return number of data points per line
 */
- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return [self lookbackLength];
}

/**
 * Show dots for activity line, but not target line
 */
- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex {
    switch (lineIndex) {
        case FDActivityLineIndex:
            return YES;
            break;
        case FDTargetLineIndex:
        default:
            return NO;
            break;
    }
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView
              lineStyleForLineAtLineIndex:(NSUInteger)lineIndex {
    switch (lineIndex) {
        case FDActivityLineIndex:
            return JBLineChartViewLineStyleSolid;
            break;
        case FDTargetLineIndex:
        default:
            return JBLineChartViewLineStyleDashed;
            break;
    }
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex {
    horizontalIndex = [self arrayIndexFromHorizontalIndex:horizontalIndex];
    if (!self.activity.count) {
        return 0;
    }
    switch (lineIndex) {
        case FDActivityLineIndex:
            if (self.activity.count <= horizontalIndex) {
                return 0;
            }
            return [[(FDDailyActivity *)[self.activity objectAtIndex:horizontalIndex] activity] floatValue];
            break;
        case FDTargetLineIndex:
        default:
            if (self.activity.count <= horizontalIndex) {
                // Target shouldn't change day-to-day
                return [[(FDDailyActivity *)[self.activity objectAtIndex:0] target] floatValue];
            }
            return [[(FDDailyActivity *)[self.activity objectAtIndex:horizontalIndex] target] floatValue];
            break;
    }
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex
               atLineIndex:(NSUInteger)lineIndex
{
    switch (lineIndex) {
        case FDActivityLineIndex:
            return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            break;
        case FDTargetLineIndex:
        default:
            return nil;
            break;
    }
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 8.0f;
}

- (CGFloat)averagePercentDoneForLookbackLength:(NSUInteger)lookbackLength
{
    CGFloat total = 0.0f;
    
    for (NSInteger x = 0; x < lookbackLength && x < self.activity.count; x++) {
        total += [[(FDDailyActivity *)self.activity[x] percentDone] floatValue];
    }
    return total/MIN(lookbackLength, self.activity.count);
}

#pragma mark - Helpers

- (NSUInteger)arrayIndexFromHorizontalIndex:(NSUInteger)horizontalIndex {
    return [self lookbackLength] - horizontalIndex - 1;
}

@end
