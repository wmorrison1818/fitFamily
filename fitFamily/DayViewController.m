//
//  DayViewController.m
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "DayViewController.h"
#import "FDCompareViewController.h"
#import <JBChartView/JBBarChartView.h>
#import "FDDailyActivity.h"
#import "FDDayViewFooterViewController.h"
#import "AppDelegate.h"

@interface DayViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *notificationsArray;

// Day bar graph view
@property (nonatomic, weak) IBOutlet JBBarChartView *barChartView;
@end


@implementation DayViewController

- (void)dealloc {
    self.barChartView.delegate = nil;
    self.barChartView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNotifications];
    
    self.barChartView.translatesAutoresizingMaskIntoConstraints = YES;
    self.barChartView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
//    self.barChartView.footerView = [[[FDDayViewFooterViewController alloc] initWithNibName:nil bundle:nil] view];
    [self.barChartView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.barChartView.frame = CGRectMake(self.barChartView.frame.origin.x, self.barChartView.frame.origin.y, self.tableView.frame.size.width, self.barChartView.frame.size.height);
    [self.barChartView reloadData];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notification" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notification"];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [self.notificationsArray objectAtIndex:indexPath.row]; //objectatindexPath.row];
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notificationsArray count];
}

#pragma mark Core Data

-(void)loadNotifications
{
    //added in
    //NSArray *objects = [[NSArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithValue:YES];//loads all things w/ a value
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSMutableArray *testerArray;
    testerArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    self.notificationsArray = [[NSMutableArray alloc] init];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (NSInteger i = ([objects count]-1); i >= 0; i--)//should reverse
        {
            //saved data
            
            matches = objects[i];
            
            [self.notificationsArray addObject: [matches valueForKey:@"notificationBody"]];
            
        }
    }
    
}

- (IBAction)actionA:(id)sender
{
    //save info
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newNotification;
    newNotification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    int num1 = arc4random()%6;
    switch (num1)
    {
        case 1:
            [newNotification setValue:[NSString stringWithFormat:@"%@ has more activity than you today!", appDelegate.dogName ?: @"Your dog"] forKey:@"notificationBody"];
            break;
        case 2:
            [newNotification setValue:[NSString stringWithFormat:@"%@ is lagging behind!!", appDelegate.dogName ?: @"Your dog"] forKey:@"notificationBody"];
            break;
        case 3:
            [newNotification setValue:[NSString stringWithFormat:@"You should sync your fitBit"] forKey:@"notificationBody"];
            break;
        case 4:
            [newNotification setValue:[NSString stringWithFormat:@"You should sync your fitBark"] forKey:@"notificationBody"];
            break;
        case 5:
            [newNotification setValue:[NSString stringWithFormat:@"Congratulations on both reaching your goals today!"] forKey:@"notificationBody"];
            break;
        case 0:
            [newNotification setValue:[NSString stringWithFormat:@"None of you have reached your goals yet!"] forKey:@"notificationBody"];
            break;
            
        default:
            [newNotification setValue:[NSString stringWithFormat:@"Time to go for a walk!"] forKey:@"notificationBody"];
            break;
    }
    
    NSError *error;
    [context save:&error];
    
    if (error) {
        NSLog(@"Error saving notification %@", error);
    }
    
    [self.tableView reloadData];
}

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return 6;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index {
    switch ((index + 1) / 3) {
        case 0:
            if ((index + 1) % 2 == 0) {
                return [self.userActivity.minRest floatValue];
            }
            else {
                return [self.dogActivity.minRest floatValue];
            }
            break;
        case 1:
            if ((index + 1) % 2 == 0) {
                return [self.userActivity.minActive floatValue];
            }
            else {
                return [self.dogActivity.minActive floatValue];
            }
            break;
        case 2:
        default:
            if ((index + 1) % 2 == 0) {
                return [self.userActivity.minPlay floatValue];
            }
            else {
                return [self.dogActivity.minPlay floatValue];
            }
            break;
    }
    return 0;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

@end
