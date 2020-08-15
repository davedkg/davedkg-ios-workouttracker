//
//  WorkoutType.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutType : RLMObject

@property NSString *name;

+ (RLMResults *)workoutTypes;
+ (BOOL)hasWorkoutTypeWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
