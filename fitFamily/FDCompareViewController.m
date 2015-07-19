//
//  FDCompareViewController.m
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "FDCompareViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DayViewController.h"
#import "FDDailyActivity.h"
#import "AppDelegate.h"

@interface FDCompareViewController ()
{
    int ranNum;
}

@end

@implementation FDCompareViewController

+ (FDDailyActivity *)activityForToday:(NSArray *)activity {
    for (FDDailyActivity *dailyActivity in activity) {
        if ([[NSCalendar autoupdatingCurrentCalendar] isDate:[NSDate date] inSameDayAsDate:dailyActivity.date]) {
            return dailyActivity;
        }
    }
    return nil;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"daySegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DayViewController class]]) {
            //load in data to the next view here
            DayViewController *dvc = (DayViewController *)segue.destinationViewController;
            NSString *test = @"tester";
            dvc.testReceive = [[NSString alloc] init];
            dvc.testReceive = test;
            
            dvc.userActivity = [FDCompareViewController activityForToday:self.fitbitGraph.activity];
            dvc.dogActivity = [FDCompareViewController activityForToday:self.fitBarkGraph.activity];
        }
    }
}


#pragma mark - Your Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityCompare.text = @"";
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
    }
    ranNum = arc4random()%6;
    
    [self fitbitGraph];
    [self fitBarkGraph];
}

- (void) saveNotification
{
    //save info
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newNotification;
    newNotification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    //int num1 = arc4random()%6;
    switch (ranNum)
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
}

- (IBAction)buttonPressed:(id)sender {
    // Create new UILocalNotification object.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // Set the date and time of the notification.
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    // Set the message body of the notification.
    
    NSString *notify = [[NSString alloc] init];
    
    switch (ranNum)
    {
        case 1:
            notify = [NSString stringWithFormat:@"%@ has more activity than you today!", appDelegate.dogName ?: @"Your dog"];
            break;
        case 2:
            notify = [NSString stringWithFormat:@"%@ is lagging behind!!", appDelegate.dogName ?: @"Your dog"];
            break;
        case 3:
            notify = [NSString stringWithFormat:@"You should sync your fitBit"];
            break;
        case 4:
            notify = [NSString stringWithFormat:@"You should sync your fitBark"];
            break;
        case 5:
            notify = [NSString stringWithFormat:@"Congratulations on both reaching your goals today!"];
            break;
        case 0:
            notify = [NSString stringWithFormat:@"None of you have reached your goals yet!"];
            break;
            
        default:
            notify = [NSString stringWithFormat:@"Time to go for a walk!"];
            break;
    }
    
    [self saveNotification];
    
    localNotification.alertBody = notify;
    
    // Set the time zone of the notification.
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    // Perform the notification.
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (FDActivityGraphViewController *)fitbitGraph {
    if (!_fitbitGraph) {
        _fitbitGraph = [[FDActivityGraphViewController alloc] init];
        [_fitbitGraph willMoveToParentViewController:self];
        [self addChildViewController:_fitbitGraph];
        [self.fitbitView addSubview:_fitbitGraph.view];
        [_fitbitGraph didMoveToParentViewController:self];
    }
    return _fitbitGraph;
}

- (FDActivityGraphViewController *)fitBarkGraph {
    if (!_fitBarkGraph) {
        _fitBarkGraph = [[FDActivityGraphViewController alloc] init];
        [_fitBarkGraph willMoveToParentViewController:self];
        [self addChildViewController:_fitBarkGraph];
        [self.fitBarkView addSubview:_fitBarkGraph.view];
        [_fitBarkGraph didMoveToParentViewController:self];
    }
    return _fitBarkGraph;
}

- (void)fitbitSubmit:(id)sender {
    self.fitbitGraph.loading = YES;
    __weak FDCompareViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://aqueous-mountain-6591.herokuapp.com/fitbit" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.userActivity.text = [NSString stringWithFormat:@"%@'s activity", [responseObject[0] objectForKey:@"name"]];
            id log = [responseObject[0] objectForKey:@"log"];
            if ([log isKindOfClass:[NSArray class]]) {
                weakSelf.fitbitGraph.activity = [weakSelf mapActivityArrayFromResponse:log];
                weakSelf.fitbitGraph.loading = NO;
            }
        }
        else {
            NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
        }
        
        [self updateActivityCompareMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf presentRequestFailedAlert];
        weakSelf.fitBarkGraph.loading = NO;
        NSLog(@"Error: %@", error);
    }];
}

- (void)fitBarkSubmit:(id)sender {
    self.fitBarkGraph.loading = YES;
    __weak FDCompareViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://aqueous-mountain-6591.herokuapp.com/fitbark/29deef75ecf5b43d012d05bec21b43acba0c20215350930e9ac9890e966d5ceb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.dogName = [responseObject[0] objectForKey:@"name"];
            self.dogActivity.text = [NSString stringWithFormat:@"%@'s activity", appDelegate.dogName];
            id log = [responseObject[0] objectForKey:@"log"];
            if ([log isKindOfClass:[NSArray class]]) {
                weakSelf.fitBarkGraph.activity = [weakSelf mapActivityArrayFromResponse:log];
                weakSelf.fitBarkGraph.loading = NO;
            }
        }
        else {
            NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
        }
        
        [self updateActivityCompareMessage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf presentRequestFailedAlert];
        weakSelf.fitBarkGraph.loading = NO;
        NSLog(@"Error: %@", error);
    }];
}

- (void)refreshGraphs {
    [self fitbitSubmit:nil];
    [self fitBarkSubmit:nil];
}

/**
 * Show alert indicating the network request failed
 */
- (void)presentRequestFailedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network error" message:@"Request failed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/* 
 * Map response JSON to an array of activity model objects
 */
- (NSArray *)mapActivityArrayFromResponse:(NSArray *)response {
    NSMutableArray *activity = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in response) {
        [activity addObject:[FDDailyActivity activityFromDictionary:dict]];
    }
    
    return activity;
}

/**
 * Update the activity compare label if both dog and human activity loaded
 */
- (void)updateActivityCompareMessage {
    if (self.fitBarkGraph.activity && self.fitbitGraph.activity) {
        NSUInteger range = self.fitbitGraph.lookbackLength;
        CGFloat dogAdvantage = [self.fitBarkGraph averagePercentDoneForLookbackLength:range] - [self.fitbitGraph averagePercentDoneForLookbackLength:range];
        if (dogAdvantage > 0.0f) {
            self.activityCompare.text = [NSString stringWithFormat:@"On average, your dog has been %.2f%@ more active than you have over the last %ld days.", dogAdvantage, @"%", range];
        }
        else if (dogAdvantage < 0.0f) {
            self.activityCompare.text = [NSString stringWithFormat:@"On average, you have been %.2f%@ more active than your dog over the last %ld days. C'mon man, take your dog when you go for a walk.", -dogAdvantage, @"%", range];
        }
    }
}

@end
