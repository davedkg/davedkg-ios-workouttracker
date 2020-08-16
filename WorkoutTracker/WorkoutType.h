//
//  WorkoutType.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLForm.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutType : RLMObject <XLFormOptionObject>

@property NSString *name;

+ (RLMResults *)all;
+ (BOOL)hasWorkoutTypeWithName:(NSString *)name;

- (NSString *)formDisplayText;
- (id)formValue;

@end

NS_ASSUME_NONNULL_END
