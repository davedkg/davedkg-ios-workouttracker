//
//  WorkoutsTableViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/16/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutsTableViewController.h"
#import "Workout.h"
#import "WorkoutType.h"

@interface WorkoutsTableViewController ()

@property (nonatomic, strong) RLMNotificationToken *realmNotificationToken;
@property (nonatomic, strong, readonly) RLMResults *workouts;

@end

@implementation WorkoutsTableViewController

#pragma mark - Getters

- (RLMResults *)workouts
{
    return [[Workout all] sortedResultsUsingKeyPath:@"startedAt" ascending:NO];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeWorkoutsNotifications];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc
{
    [self.realmNotificationToken invalidate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    Workout *workout      = [self.workouts objectAtIndex:indexPath.row];
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@", workout.type.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld minutes", (long)workout.minutes];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Initializers

- (void)initializeWorkoutsNotifications
{
    // Observe collection notifications. Retain the token to keep observing.
    __weak typeof(self) weakSelf = self;
    self.realmNotificationToken = [self.workouts addNotificationBlock:^(RLMResults<Workout *> *results, RLMCollectionChange *changes, NSError *error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }

        UITableView *tableView = weakSelf.tableView;
        // Initial run of the query will pass nil for the change information
        if (!changes) {
            [tableView reloadData];
            return;
        }

        // Query results have changed, so apply them to the UITableView
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[changes deletionsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView insertRowsAtIndexPaths:[changes insertionsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:[changes modificationsInSection:0]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }];
}

@end
