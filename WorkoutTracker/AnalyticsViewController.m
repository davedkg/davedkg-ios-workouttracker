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

@interface AnalyticsViewController ()

@property (nonatomic, strong, readwrite) VBPieChart *chart;
@property (weak, nonatomic) IBOutlet UIView *chartView;

@end

@implementation AnalyticsViewController

@synthesize chart=_chart;

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

# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initChart];
}

# pragma mark - Initializers

- (void)initChart
{
    [self.chartView addSubview:self.chart];
    [self.chart setChartValues:[self chartData]
                     animation:YES
                      duration:0.4
                       options:VBPieChartAnimationFan];
}

# pragma mark - Chart Helpers

- (NSArray *)chartData
{
    NSMutableArray *values = [@[] mutableCopy];
    int index = 0;
    
    for (WorkoutType *workoutType in [WorkoutType all]) {
        NSNumber *minutes = [workoutType calculateTotalMinutes];
        
        if (NO == [[NSNumber numberWithInteger:0] isEqualToNumber:minutes]) {
            [values addObject:@{
                @"name"  : workoutType.name,
                @"value" : minutes,
                @"color" : [self colorForIndex:index],
            }];
            
            index++;
        }
    }
    
    return [values copy];
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
