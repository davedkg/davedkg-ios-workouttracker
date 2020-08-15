//
//  NewWorkoutViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "NewWorkoutViewController.h"

@interface NewWorkoutViewController ()

@end

@implementation NewWorkoutViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)cancelButtonPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{
    // TODO save
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
