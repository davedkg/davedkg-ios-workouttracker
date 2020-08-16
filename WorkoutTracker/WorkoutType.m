//
//  WorkoutType.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "WorkoutType.h"

@implementation WorkoutType

#pragma mark - Realm

+ (NSArray *)requiredProperties
{
    NSMutableArray *requiredProperties = [[super requiredProperties] mutableCopy];
    
    [requiredProperties addObject:@"name"];
    
    return [requiredProperties copy];
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

#pragma mark - Public Methods

+ (BOOL)hasWorkoutTypeWithName:(NSString *)name
{
    NSString *condition = [NSString stringWithFormat:@"name == '%@'", name];
    
    return 0 != [[[WorkoutType all] objectsWhere:condition] count];
}

@end
