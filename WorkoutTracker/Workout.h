//
//  Workout.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <Realm/Realm.h>
#import "ApplicationModel.h"

@class WorkoutType;

NS_ASSUME_NONNULL_BEGIN

@interface Workout : ApplicationModel

@property WorkoutType *type;
@property NSDate      *startedAt;
@property NSDate      *endedAt;

@property (nonatomic, readonly) NSInteger minutes;

@end

RLM_ARRAY_TYPE(Workout)

NS_ASSUME_NONNULL_END
