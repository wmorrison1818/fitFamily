//
//  FDGraphViewController.m
//  fitFamily
//
//  Created by Wray,Brendan on 7/18/15.
//  Copyright (c) 2015 Wray,Brendan. All rights reserved.
//

#import "FDGraphViewController.h"
#import <JBChartView/JBLineChartView.h>

@interface FDGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>
@property (nonatomic, strong) JBLineChartView *chartView;
@property (nonatomic, copy) NSArray *orderedDates;
@end

@implementation FDGraphViewController

- (void)dealloc
{
    self.chartView.delegate = nil;
    self.chartView.dataSource = nil;
}

- (void)viewDidLoad
{
    self.lookbackLength = 7;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.frame = CGRectMake(0, 0, 343, 140);
    self.chartView = [[JBLineChartView alloc] init];
    self.chartView.frame = self.view.frame;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
    
    [self.view addSubview:self.chartView];
}

- (void)setDataPoints:(NSDictionary *)dataPoints
{
    _dataPoints = dataPoints;
    
    [self.chartView reloadData];
}

- (void)setLookbackLength:(NSUInteger)lookbackLength
{
    _lookbackLength = lookbackLength;
    
    [self.chartView reloadData];
}

#pragma mark - JBLineChartViewDataSource

/**
 *  Returns the number of lines for the line chart.
 *
 *  @param lineChartView    The line chart object requesting this information.
 *
 *  @return The number of lines in the line chart.
 */
- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    NSLog(@"numLines = %ld", self.dataPoints.count);
    return 1;
}

/**
 *  Returns the number of vertical values for a particular line at lineIndex within the chart.
 *
 *  @param lineChartView    The line chart object requesting this information.
 *  @param lineIndex        An index number identifying a line in the chart.
 *
 *  @return The number of vertical values for a given line in the line chart.
 */
- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return self.dataPoints.count;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return YES;
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex
{
    NSLog(@"Called for vertValue HorizIndex %ld lineIndex %ld", horizontalIndex, lineIndex);
    CGFloat value = [[self.dataPoints objectForKey:[self.orderedDates objectAtIndex:horizontalIndex]] floatValue];
    NSLog(@"This value is %f", value);
    return value;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex
               atLineIndex:(NSUInteger)lineIndex
{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

@end
