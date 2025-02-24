//
//  SecondViewController.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/11/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "VBPieChart.h"
#import "WorkoutType.h"
#import "WorkoutBotService.h"

#define NAME  @"name"
#define VALUE @"value"
#define COLOR @"color"

@interface AnalyticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RLMNotificationToken        *realmNotificationToken;
@property (nonatomic, strong, readonly) VBPieChart        *chart;
@property (nonatomic, strong, readonly) NSArray           *chartData;
@property (nonatomic, strong, readonly) UIBarButtonItem   *playButton;
@property (nonatomic, strong, readonly) UIBarButtonItem   *pauseButton;
@property (nonatomic, strong, readonly) WorkoutBotService *workoutBot;
@property (weak, nonatomic) IBOutlet    UIView            *chartView;
@property (weak, nonatomic) IBOutlet    UITableView       *tableView;


@end

@implementation AnalyticsViewController

@synthesize chart=_chart,chartData=_chartData;
@synthesize playButton=_playButton,pauseButton=_pauseButton,workoutBot=_workoutBot;

#pragma mark - Getters

- (VBPieChart *)chart
{
    if (nil == _chart) {
        CGRect chartFrame = CGRectMake(0,
                                       0,
                                       self.chartView.frame.size.width,
                                       self.chartView.frame.size.height);
        
        _chart = [[VBPieChart alloc] initWithFrame:chartFrame];
        
        [_chart setHoleRadiusPrecent:0.3];
    }
    return _chart;
}

- (NSArray *)chartData
{
    if (nil == _chartData) {
        NSMutableArray *values = [@[] mutableCopy];
        int index = 0;
        
        for (WorkoutType *workoutType in [WorkoutType all]) {
            NSNumber *minutes = [workoutType calculateTotalMinutes];
            
            if (NO == [[NSNumber numberWithInteger:0] isEqualToNumber:minutes]) {
                [values addObject:@{
                    NAME  : workoutType.name,
                    VALUE : minutes,
                    COLOR : [self colorForIndex:index],
                }];
                
                index++;
            }
        }
        
        _chartData = [values copy];
    }
    return _chartData;
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

# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.allowsSelection = NO;
    
    [self.chartView addSubview:self.chart];
    [self updateChartData];
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chartData count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"WorkoutTypeCell" forIndexPath:indexPath];
    NSDictionary *chartDataRow = [self.chartData objectAtIndex:indexPath.row];
    
    cell.textLabel.text       = [chartDataRow objectForKey:NAME];
    cell.textLabel.textColor  = [chartDataRow objectForKey:COLOR];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ minutes", [chartDataRow objectForKey:VALUE]];
    
    return cell;
}

# pragma mark - Chart Helpers

- (void)updateChartData
{
    _chartData = nil;
    [self.chart setChartValues:self.chartData
                     animation:YES
                      duration:0.4
                       options:VBPieChartAnimationFan];
    [self.tableView reloadData];
}

- (UIColor *)colorForIndex:(int)index
{
    switch (index % 4) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor orangeColor];
        case 3:
            return [UIColor purpleColor];
        default:
            return [UIColor blackColor];
    }
}

#pragma mark - Initializers

- (void)initializeWorkoutsNotifications
{
    __weak typeof(self) weakSelf = self;
    self.realmNotificationToken = [[Workout all] addNotificationBlock:^(RLMResults<Workout *> *results, RLMCollectionChange *changes, NSError *error) {
        
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        [weakSelf updateChartData];
    }];
}

@end
