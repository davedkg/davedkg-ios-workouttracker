//
//  Workout.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "Workout.h"

@implementation Workout

#pragma mark - Getters

- (NSInteger)minutes
{
    return [self.endedAt timeIntervalSinceDate:self.startedAt] / 60;
}

#pragma mark - Realm

+ (NSArray *)requiredProperties
{
    NSMutableArray *requiredProperties = [[super requiredProperties] mutableCopy];
    
    [requiredProperties addObject:@"startedAt"];
    [requiredProperties addObject:@"endedAt"];
    [requiredProperties addObject:@"workout"];
    
    return [requiredProperties copy];
}

@end
