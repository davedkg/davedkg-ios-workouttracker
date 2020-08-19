//
//  WorkoutBotService.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/18/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutBotService.h"
#import "RandomUtils.h"
#import "Workout.h"
#import "WorkoutType.h"

#define LOWER_TIMER_INTERVAL  1.0
#define UPPER_TIMER_INTERVAL  3.0
#define WORKOUT_TIME_INTERVAL 60 * 30

@interface WorkoutBotService()

@property (nonatomic, readonly) RLMRealm *realm;
@property (nonatomic, strong)   NSTimer  *timer;

@end

@implementation WorkoutBotService

#pragma mark - Getters

- (RLMRealm *)realm
{
    return [AppDelegate sharedAppDelegate].realm;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        unsigned seed = 100;
        [RandomUtils setSeed:seed];
    }
    return self;
}

#pragma mark - Public Methods

- (void)startWorkoutBot
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[self randomTimerInterval]
                                                  target:self
                                                selector:@selector(generateRandomWorkout)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopWorkoutBot
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Private Methods

- (void)generateRandomWorkout
{
    NSDate *startedAt        = [self generateRandomDateWithinDaysBeforeToday:2];
    NSDate *endedAt          = [startedAt dateByAddingTimeInterval:WORKOUT_TIME_INTERVAL];
    WorkoutType *workoutType = [self randomWorkoutType];
    Workout *workout         = [[Workout alloc] initWithObjectId];
    
    workout.workoutType = workoutType;
    workout.startedAt   = startedAt;
    workout.endedAt     = endedAt;
    
    [workout calculateMinutes];
    
    [self.realm transactionWithBlock:^() {
        [self.realm addObject:workout];
    }];
}

- (NSDate *)generateRandomDateWithinDaysBeforeToday:(NSUInteger)daysBack {
    NSUInteger day = arc4random_uniform((u_int32_t)daysBack);  // explisit cast
    NSUInteger hour = arc4random_uniform(23);
    NSUInteger minute = arc4random_uniform(59);

    NSDate *today = [NSDate new];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:(day * -1)];
    [offsetComponents setHour:hour];
    [offsetComponents setMinute:minute];

    NSDate *randomDate = [gregorian dateByAddingComponents:offsetComponents
                                                    toDate:today
                                                   options:0];

    return randomDate;
}

- (WorkoutType *)randomWorkoutType
{
    NSInteger numWorkoutTypes        = [[WorkoutType all] count];
    NSInteger randomWorkoutTypeIndex = [RandomUtils randomIntBetweenMin:0
                                                                 andMax:(int)numWorkoutTypes - 1
                                                                useSeed:YES];
    
    return [[WorkoutType all] objectAtIndex:randomWorkoutTypeIndex];
}

- (int)randomTimerInterval
{
    return [RandomUtils randomIntBetweenMin:LOWER_TIMER_INTERVAL
                                     andMax:UPPER_TIMER_INTERVAL
                                    useSeed:YES];
}

@end
