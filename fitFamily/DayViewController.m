//
//  DayViewController.m
//  fitFamily
//
//  Created by William Morrison on 7/18/15.
//  Copyright (c) 2015 William Morrison. All rights reserved.
//

#import "DayViewController.h"
#import "FDCompareViewController.h"

#import "AppDelegate.h"

@interface DayViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *notificationsArray;
@end


@implementation DayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNotifications];
    
    // Do any additional setup after loading the view.
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
    [newNotification setValue:[NSString stringWithFormat:@"%@ has more activity than you today!", appDelegate.dogName ?: @"Your dog"] forKey:@"notificationBody"];
    NSError *error;
    [context save:&error];
    
    if (error) {
        NSLog(@"Error saving notification %@", error);
    }
    
    [self.tableView reloadData];
}

@end
