//
//  AppDelegate.m
//  WorkoutTracker
//
//  Created by David Guilfoyle on 8/11/20.
//  Copyright © 2020 David Guilfoyle. All rights reserved.
//

#import "AppDelegate.h"
#import "WorkoutType.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize realm=_realm;

#pragma mark - Getters/Setters

- (RLMRealm *)realm
{
    if (nil == _realm) {
        _realm = [RLMRealm realmWithConfiguration:[self realmConfig] error:nil];
    }
    
    return _realm;
}

//https://realm.io/blog/realm-objc-swift-0-95/
- (RLMRealmConfiguration *)realmConfig
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    config.schemaVersion  = 2;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 2) {
            [migration enumerateObjects:WorkoutType.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                newObject[@"_id"] = [RLMObjectId objectId];
            }];
        }
    };

    config.objectClasses = @[WorkoutType.class];
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    return config;
}

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


# pragma mark - Lifecycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self seedWorkoutTypes];
    
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - Private Methods

- (void)seedWorkoutTypes
{
    WorkoutType *workoutType;
    NSArray *workoutTypeNames = @[@"Biking", @"Running", @"Yoga"];
    
    for (NSString *workoutTypeName in workoutTypeNames) {
        if (NO == [WorkoutType hasWorkoutTypeWithName:workoutTypeName]) {
               workoutType = [[WorkoutType alloc] init];
               
               workoutType.name = workoutTypeName;
            
               [self.realm transactionWithBlock:^() {
                   [self.realm addObject:workoutType];
               }];
        }
    }
    
//    for (WorkoutType *workoutType in [WorkoutType workoutTypes]) {
//        NSLog(@"WorkoutType: %@", workoutType);
//    }
}


@end
