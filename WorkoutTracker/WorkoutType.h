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

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutType : RLMObject <XLFormOptionObject>

@property RLMObjectId *_id;
@property NSString    *name;
@property RLMArray<Workout *><Workout> *workouts;

+ (RLMResults *)all;
+ (BOOL)hasWorkoutTypeWithName:(NSString *)name;

- (NSString *)formDisplayText;
- (id)formValue;

@end

RLM_ARRAY_TYPE(WorkoutType)

NS_ASSUME_NONNULL_END
