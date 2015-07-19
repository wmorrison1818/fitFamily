//
//  ViewController.m
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "FDCompareViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DayViewController.h"

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
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (FDGraphViewController *)fitbitGraph {
    if (!_fitbitGraph) {
        _fitbitGraph = [[FDGraphViewController alloc] init];
        [self.fitbitView addSubview:_fitbitGraph.view];
    }
    return _fitbitGraph;
}

- (FDGraphViewController *)fitBarkGraph {
    if (!_fitBarkGraph) {
        _fitBarkGraph = [[FDGraphViewController alloc] init];
        [self.fitBarkView addSubview:_fitBarkGraph.view];
    }
    return _fitBarkGraph;
}

- (void)fitbitSubmit:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SampleFitBit" ofType:@"json"];
    NSData *sampleData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:sampleData options:0 error:&error];
    self.fitbitGraph.dataPoints = dataDict;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://aqueous-mountain-6591.herokuapp.com/fitbark/29deef75ecf5b43d012d05bec21b43acba0c20215350930e9ac9890e966d5ceb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (void)fitBarkSubmit:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SampleFitBit" ofType:@"json"];
    NSData *sampleData = [NSData dataWithContentsOfFile:path];
    NSError *error;
    
    self.fitBarkResults = [NSJSONSerialization JSONObjectWithData:sampleData options:0 error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://aqueous-mountain-6591.herokuapp.com/fitbark/29deef75ecf5b43d012d05bec21b43acba0c20215350930e9ac9890e966d5ceb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON object %@: %@", [responseObject class], responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
