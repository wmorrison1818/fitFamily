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
@property (strong, nonatomic) NSMutableArray *notifcationsArray;
@end


@implementation DayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNotifications];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI Table View
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notification" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notification"];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [self.notifcationsArray objectAtIndex:indexPath.row]; //objectatindexPath.row];
    
    
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
    return [self.notifcationsArray count];
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
    
    self.notifcationsArray = [[NSMutableArray alloc] init];
    
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        for (int i = ((int)[objects count]-1); i >= 0; i--)//should reverse
        {
            //saved data
            
            matches = objects[i];
            
            [self.notifcationsArray addObject: [matches valueForKey:@"notificationBody"]];
            
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
    [newNotification setValue: @"hello" forKey:@"notificationBody"];
    NSError *error;
    [context save:&error];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
