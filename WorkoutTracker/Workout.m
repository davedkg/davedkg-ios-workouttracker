//
//  Workout.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "Workout.h"
#import "WorkoutType.h"

#define STARTED_AT @"startedAt"
#define ENDED_AT   @"endedAt"
#define MINUTES    @"minutes"

@implementation Workout

#pragma mark - Realm

+ (NSArray *)requiredProperties
{
    NSMutableArray *requiredProperties = [[super requiredProperties] mutableCopy];
    
    [requiredProperties addObject:STARTED_AT];
    [requiredProperties addObject:ENDED_AT];
    [requiredProperties addObject:MINUTES];
    
    return [requiredProperties copy];
}

#pragma mark - Helpers

// FIXME move me into a beforeSave callback
- (void)calculateMinutes
{
    self.minutes = [NSNumber numberWithInteger:([self.endedAt timeIntervalSinceDate:self.startedAt] / 60)];
}

@end
