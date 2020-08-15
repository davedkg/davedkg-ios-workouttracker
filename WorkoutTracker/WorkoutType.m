//
//  WorkoutType.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutType.h"

@implementation WorkoutType

+ (NSArray *)requiredProperties
{
    return @[@"name"];
}

+ (RLMResults *)workoutTypes
{
    return [self allObjectsInRealm:[AppDelegate sharedAppDelegate].realm];
}

+ (BOOL)hasWorkoutTypeWithName:(NSString *)name
{
    NSString *condition = [NSString stringWithFormat:@"name == '%@'", name];
    
    return 0 != [[[self workoutTypes] objectsWhere:condition] count];
}

@end
