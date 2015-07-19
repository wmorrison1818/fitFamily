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

@interface FDCompareViewController ()

@end

@implementation FDCompareViewController

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"daySegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[DayViewController class]])
        {
            //load in data to the next view here
            DayViewController *dvc = (DayViewController *)segue.destinationViewController;
            NSString *test = @"tester";
            dvc.testReceive = [[NSString alloc] init];
            dvc.testReceive = test;
            
        }
    }
    
    
}


#pragma mark - Your Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
    }
}

- (IBAction)buttonPressed:(id)sender {
    // Create new UILocalNotification object.
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // Set the date and time of the notification.
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    // Set the message body of the notification.
    localNotification.alertBody = @"Your dog is reaching his goal before you!!";
    
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
    __weak FDCompareViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://aqueous-mountain-6591.herokuapp.com/fitbit" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.userActivity.text = [NSString stringWithFormat:@"%@'s activity", [responseObject[0] objectForKey:@"name"]];
            id log = [responseObject[0] objectForKey:@"log"];
            if ([log isKindOfClass:[NSArray class]]) {
                weakSelf.fitbitGraph.activity = [weakSelf mapActivityArrayFromResponse:log];
            }
        }
        else {
            NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf presentRequestFailedAlert];
        NSLog(@"Error: %@", error);
    }];
}

- (void)fitBarkSubmit:(id)sender {    
    __weak FDCompareViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://aqueous-mountain-6591.herokuapp.com/fitbark/29deef75ecf5b43d012d05bec21b43acba0c20215350930e9ac9890e966d5ceb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.dogActivity.text = [NSString stringWithFormat:@"%@'s activity", [responseObject[0] objectForKey:@"name"]];
            id log = [responseObject[0] objectForKey:@"log"];
            if ([log isKindOfClass:[NSArray class]]) {
                weakSelf.fitBarkGraph.activity = [weakSelf mapActivityArrayFromResponse:log];
            }
        }
        else {
            NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf presentRequestFailedAlert];
        NSLog(@"Error: %@", error);
    }];
}

/**
 * Show alert indicating the network request failed
 */
- (void)presentRequestFailedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network error" message:@"Request failed" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray *)mapActivityArrayFromResponse:(NSArray *)response {
    NSMutableArray *activity = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in response) {
        [activity addObject:[FDDailyActivity activityFromDictionary:dict]];
    }
    
    return activity;
}

@end
