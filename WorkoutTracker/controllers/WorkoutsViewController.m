//
//  WorkoutsTableViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/16/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutsViewController.h"
#import "Workout.h"
#import "WorkoutType.h"
#import "WorkoutViewController.h"
#import "WorkoutBotService.h"

@interface WorkoutsViewController ()

@property (nonatomic, strong) RLMNotificationToken        *realmNotificationToken;
@property (nonatomic, strong, readonly) RLMResults        *workouts;
@property (nonatomic, strong, readonly) RLMRealm          *realm;
@property (nonatomic, strong, readonly) UIBarButtonItem   *playButton;
@property (nonatomic, strong, readonly) UIBarButtonItem   *pauseButton;
@property (nonatomic, strong, readonly) WorkoutBotService *workoutBot;

@end

@implementation WorkoutsViewController

#pragma mark - Getters

@synthesize playButton=_playButton,pauseButton=_pauseButton,workoutBot=_workoutBot;

- (RLMResults *)workouts
{
    return [[Workout all] sortedResultsUsingKeyPath:@"startedAt" ascending:NO];
}

- (RLMRealm *)realm
{
    return [AppDelegate sharedAppDelegate].realm;
}

- (UIBarButtonItem *)playButton
{
    if (nil == _playButton) {
        _playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                    target:self
                                                                    action:@selector(playButtonPressed)];
    }
    return _playButton;
}

- (UIBarButtonItem *)pauseButton
{
    if (nil == _pauseButton) {
        _pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                     target:self
                                                                     action:@selector(pauseButtonPressed)];
    }
    return _pauseButton;
}

- (WorkoutBotService *)workoutBot
{
    if (nil == _workoutBot) {
        _workoutBot = [[WorkoutBotService alloc] init];
    }
    return _workoutBot;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.playButton;
    [self initializeWorkoutsNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationItem.leftBarButtonItem == self.pauseButton) {
        [self pauseButtonPressed];
    }
}

- (void)dealloc
{
    [self.realmNotificationToken invalidate];
    self.realmNotificationToken = nil;
}

#pragma mark - Actions

- (void)playButtonPressed
{
    [self.workoutBot startWorkoutBot];
    self.navigationItem.leftBarButtonItem = self.pauseButton;
}

- (void)pauseButtonPressed
{
    [self.workoutBot stopWorkoutBot];
    self.navigationItem.leftBarButtonItem = self.playButton;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell" forIndexPath:indexPath];
    Workout *workout         = [self.workouts objectAtIndex:indexPath.row];
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@", workout.workoutType.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", workout.startedAt];
    
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"ShowWorkout" isEqualToString:segue.identifier]) {
        WorkoutViewController *workoutViewController = [[(UINavigationController *)segue.destinationViewController viewControllers] firstObject];
        Workout *workout                             = [self.workouts objectAtIndex:[self.tableView indexPathForCell:sender].row];
        
        workoutViewController.workout = workout;
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
