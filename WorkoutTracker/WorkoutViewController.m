//
//  WorkoutViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/16/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutViewController.h"
#import "XLForm.h"
#import "WorkoutType.h"

#define WORKOUT_TYPE @"workoutType"
#define STARTED_AT   @"startedAt"
#define ENDED_AT     @"endedAt"

@interface WorkoutViewController ()

@property (nonatomic) BOOL isEditing;

@property (nonatomic, strong) RLMRealm *realm;
@property (nonatomic, strong, readonly) NSArray  *workoutTypes;
@property (nonatomic, strong, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *editButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *cancelEditButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *saveButton;
@property (nonatomic, strong, readonly) XLFormRowDescriptor *workoutTypeFormRow;
@property (nonatomic, strong, readonly) XLFormRowDescriptor *startedAtFormRow;
@property (nonatomic, strong, readonly) XLFormRowDescriptor *endedAtFormRow;

@end

@implementation WorkoutViewController

@synthesize workoutTypes=_workoutTypes;
@synthesize doneButton=_doneButton,editButton=_editButton,cancelEditButton=_cancelEditButton,saveButton=_saveButton;
@synthesize workoutTypeFormRow=_workoutTypeFormRow,startedAtFormRow=_startedAtFormRow,endedAtFormRow=_endedAtFormRow;

#pragma mark - Getters/Setters

- (void)setIsEditing:(BOOL)isEditing
{
    if (_isEditing != isEditing) {
        _isEditing = isEditing;
        
        self.workoutTypeFormRow.disabled = @(!isEditing);
        self.startedAtFormRow.disabled   = @(!isEditing);
        self.endedAtFormRow.disabled     = @(!isEditing);
        
        [self.tableView reloadData];
        [self updateNavbarButtons];
    }
}

- (RLMRealm *)realm
{
    return [AppDelegate sharedAppDelegate].realm;
}

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

- (UIBarButtonItem *)doneButton
{
    if (nil == _doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self
                                                                    action:@selector(doneButtonPressed:)];
    }
    return _doneButton;
}

- (UIBarButtonItem *)editButton
{
    if (nil == _editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self
                                                                    action:@selector(editButtonPressed:)];
    }
    return _editButton;
}

- (UIBarButtonItem *)cancelEditButton
{
    if (nil == _cancelEditButton) {
        _cancelEditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(cancelEditButtonPressed:)];
    }
    return _cancelEditButton;
}

- (UIBarButtonItem *)saveButton
{
    if (nil == _saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self
                                                                    action:@selector(saveButtonPressed:)];
    }
    return _saveButton;
}

- (XLFormRowDescriptor *)workoutTypeFormRow
{
    if (nil == _workoutTypeFormRow) {
        _workoutTypeFormRow = [XLFormRowDescriptor formRowDescriptorWithTag:WORKOUT_TYPE
                                                                    rowType:XLFormRowDescriptorTypeSelectorActionSheet
                                                                      title:@"Type"];
        _workoutTypeFormRow.selectorOptions = self.workoutTypes;
    }
    return _workoutTypeFormRow;
}

- (XLFormRowDescriptor *)startedAtFormRow
{
    if (nil == _startedAtFormRow) {
        _startedAtFormRow = [XLFormRowDescriptor formRowDescriptorWithTag:STARTED_AT
                                                                  rowType:XLFormRowDescriptorTypeDateTimeInline
                                                                    title:@"Started At"];
    }
    return _startedAtFormRow;
}

- (XLFormRowDescriptor *)endedAtFormRow
{
    if (nil == _endedAtFormRow) {
        _endedAtFormRow = [XLFormRowDescriptor formRowDescriptorWithTag:ENDED_AT
                                                                rowType:XLFormRowDescriptorTypeDateTimeInline
                                                                  title:@"Ended At"];
    }
    return _endedAtFormRow;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setIsEditing:NO];
    [self initializeForm];
    [self initializeNavbar];
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonPressed:(id)sender
{
    [self setIsEditing:YES];
}

- (IBAction)cancelEditButtonPressed:(id)sender
{
    [self setIsEditing:NO];
    
    self.workoutTypeFormRow.value = self.workout.workoutType;
    self.startedAtFormRow.value   = self.workout.startedAt;
    self.endedAtFormRow.value     = self.workout.endedAt;
}

- (IBAction)saveButtonPressed:(id)sender
{
    [self setIsEditing:NO];
    
    NSDictionary *formValues = [self formValues];
    
    // FIXME only update changed values
    [self.realm transactionWithBlock:^() {
        self.workout.workoutType = [formValues objectForKey:WORKOUT_TYPE];
        self.workout.startedAt   = [formValues objectForKey:STARTED_AT];
        self.workout.endedAt     = [formValues objectForKey:ENDED_AT];
        
        [self.workout calculateMinutes];
    }];
}

#pragma mark - Initializers

- (void)initializeNavbar
{
    self.navigationItem.leftBarButtonItem  = self.doneButton;
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (void)initializeForm
{
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;

    form = [XLFormDescriptor formDescriptorWithTitle:@"Edit Workout"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    self.workoutTypeFormRow.value    = self.workout.workoutType;
    self.workoutTypeFormRow.disabled = @(YES);
    [section addFormRow:self.workoutTypeFormRow];

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    // startedAt
    self.startedAtFormRow.value    = self.workout.startedAt;
    self.startedAtFormRow.disabled = @(YES);
    [section addFormRow:self.startedAtFormRow];
    
    // endedAt
    self.endedAtFormRow.value    = self.workout.endedAt;
    self.endedAtFormRow.disabled = @(YES);
    [section addFormRow:self.endedAtFormRow];
  
    self.form = form;
}

#pragma mark - View Helpers

- (void)updateNavbarButtons
{
    if (YES == self.isEditing) {
        self.navigationItem.leftBarButtonItem  = self.cancelEditButton;
        self.navigationItem.rightBarButtonItem = self.saveButton;
    } else {
        self.navigationItem.leftBarButtonItem  = self.doneButton;
        self.navigationItem.rightBarButtonItem = self.editButton;
    }
}

@end
