//
//  WorkoutViewController.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/16/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLFormViewController.h"

@class Workout;

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutViewController : XLFormViewController

@property (nonatomic, strong) Workout *workout;

@end

NS_ASSUME_NONNULL_END
