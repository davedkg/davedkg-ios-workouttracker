//
//  ApplicationModel.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/15/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "ApplicationModel.h"

@interface ApplicationModel()

@property (nonatomic, readonly) RLMRealm *realm;

@end

@implementation ApplicationModel

#pragma mark - Getters/Setters

- (RLMRealm *)realm
{
    return [AppDelegate sharedAppDelegate].realm;
}

#pragma mark - Lifecycle

- (instancetype)initWithObjectId {
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
    return @[@"_id"];
}

+ (RLMResults *)all
{
    return [self allObjectsInRealm:[AppDelegate sharedAppDelegate].realm];
}

- (void)create
{
    [self.realm transactionWithBlock:^() {
        [self.realm addObject:self];
    }];
}

- (void)destroy
{
    [self.realm transactionWithBlock:^() {
        [self.realm deleteObject:self];
    }];
}

@end
