//
//  ViewController.m
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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

@end
