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

#define NAME  @"name"
#define VALUE @"value"
#define COLOR @"color"

@interface AnalyticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) VBPieChart *chart;
@property (nonatomic, strong, readonly) NSArray    *chartData;

@property (weak, nonatomic) IBOutlet UIView      *chartView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AnalyticsViewController

@synthesize chart=_chart,chartData=_chartData;

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

# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.allowsSelection = NO;
    
    [self.chartView addSubview:self.chart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateChartData];
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

@end
