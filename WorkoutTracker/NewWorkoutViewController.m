//
//  NewWorkoutViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "NewWorkoutViewController.h"
#import "XLForm.h"
#import "WorkoutType.h"

@interface NewWorkoutViewController ()

@property (nonatomic, strong, readonly) NSArray *workoutTypes;

@end

@implementation NewWorkoutViewController

@synthesize workoutTypes=_workoutTypes;

#pragma mark - Getters/Setters

- (NSArray *)workoutTypes
{
    if (nil == _workoutTypes) {
        NSMutableArray *workoutTypes = [@[] mutableCopy];
        
        for (WorkoutType *workoutType in [WorkoutType all]) {
           [workoutTypes addObject:workoutType];
        }
        
        _workoutTypes = [workoutTypes copy];
    }
    return _workoutTypes;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeForm];
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

#pragma mark - Initializers

- (void)initializeForm {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;

    form = [XLFormDescriptor formDescriptorWithTitle:@"New Workout"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"workoutType"
                                                rowType:XLFormRowDescriptorTypeSelectorActionSheet
                                                  title:@"Type"];
    row.selectorOptions = self.workoutTypes;
    row.value = [self.workoutTypes firstObject];
    [section addFormRow:row];

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    // startedAt
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"startedAat"
                                                rowType:XLFormRowDescriptorTypeDateTimeInline
                                                  title:@"Started At"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
    
    // endedAt
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"endedAt"
                                                rowType:XLFormRowDescriptorTypeDateTimeInline
                                                  title:@"Ended At"];
    row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    [section addFormRow:row];
  
    self.form = form;
}

@end
