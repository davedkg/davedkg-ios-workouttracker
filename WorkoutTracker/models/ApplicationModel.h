//
//  ApplicationModel.h
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationModel : RLMObject

@property RLMObjectId *_id;

- (instancetype)initWithObjectId;

+ (NSArray *)requiredProperties;
+ (RLMResults *)all;

- (void)create;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
