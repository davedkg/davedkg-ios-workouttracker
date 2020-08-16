//
//  WorkoutType.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"
#import "Workout.h"
#import "ApplicationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutType : ApplicationModel <XLFormOptionObject>

@property NSString    *name;
@property RLMArray<Workout *><Workout> *workouts;

+ (BOOL)hasWorkoutTypeWithName:(NSString *)name;

- (NSString *)formDisplayText;
- (id)formValue;

@end

RLM_ARRAY_TYPE(WorkoutType)

NS_ASSUME_NONNULL_END
