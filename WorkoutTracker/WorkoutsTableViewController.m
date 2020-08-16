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
@property (nonatomic, strong, readonly) RLMRealm   *realm;

@end

@implementation WorkoutsTableViewController

#pragma mark - Getters

- (RLMResults *)workouts
{
    return [[Workout all] sortedResultsUsingKeyPath:@"startedAt" ascending:NO];
}

- (RLMRealm *)realm
{
    return [AppDelegate sharedAppDelegate].realm;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeWorkoutsNotifications];
}

- (void)dealloc
{
    [self.realmNotificationToken invalidate];
    self.realmNotificationToken = nil;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    Workout *workout      = [self.workouts objectAtIndex:indexPath.row];
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@", workout.type.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld minutes", (long)workout.minutes];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Workout *workout = [self.workouts objectAtIndex:indexPath.row];
        
        [self.realm transactionWithBlock:^() {
            [self.realm deleteObject:workout];
        }];
    }
}

#pragma mark - Initializers

- (void)initializeWorkoutsNotifications
{
    __weak typeof(self) weakSelf = self;
    self.realmNotificationToken = [self.workouts addNotificationBlock:^(RLMResults<Workout *> *results, RLMCollectionChange *changes, NSError *error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }

        UITableView *tableView = weakSelf.tableView;
        if (!changes) {
            [tableView reloadData];
            return;
        }

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
