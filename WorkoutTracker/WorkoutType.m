//
//  WorkoutType.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutType.h"

@implementation WorkoutType

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
    return @[@"name"];
}

#pragma mark - XLFormOptionObject

- (NSString *)formDisplayText
{
    return self.name;
}

- (id)formValue
{
    return self;
}

#pragma mark - Public Meethods

+ (RLMResults *)all
{
    return [self allObjectsInRealm:[AppDelegate sharedAppDelegate].realm];
}

+ (BOOL)hasWorkoutTypeWithName:(NSString *)name
{
    NSString *condition = [NSString stringWithFormat:@"name == '%@'", name];
    
    return 0 != [[[self all] objectsWhere:condition] count];
}

@end
