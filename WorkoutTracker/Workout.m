//
//  Workout.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "Workout.h"

@implementation Workout

#pragma mark - Lifecycle

- (instancetype)init {
    if ((self = [super init])) {
        self._id = [RLMObjectId objectId];
    }
    return self;
}

#pragma mark - Realm

+ (NSString *)primaryKey {
    return @"_id";
}

+ (NSArray *)requiredProperties
{
    return @[@"startedAt", @"endedAt", @"workout"];
}

@end
