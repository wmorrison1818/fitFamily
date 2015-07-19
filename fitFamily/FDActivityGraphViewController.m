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
@property (nonatomic, copy) NSArray *orderedDates;
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

- (void)setActivityPoints:(NSDictionary *)dataPoints {
    _activityPoints = dataPoints;
    
    [self.chartView reloadData];
}

- (void)setActivity:(NSArray *)activity {
    _activity = activity;
    
    [self.chartView reloadData];
}

- (IBAction)segmentChanged:(id)sender {
    [self.chartView reloadData];
}

- (NSUInteger)selectedSegmentRange {
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
    return [self selectedSegmentRange];
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

#pragma mark - Helpers

- (BOOL)isSameDay:(NSDate *)date1 :(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *date1Components = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *date2Components = [calendar components:unitFlags fromDate:date2];
    
    return [date1Components day] == [date2Components day] &&
    [date1Components month] == [date2Components month] &&
    [date1Components year] == [date2Components year];
}

- (NSUInteger)arrayIndexFromHorizontalIndex:(NSUInteger)horizontalIndex {
    return [self selectedSegmentRange] - horizontalIndex - 1;
}

@end
