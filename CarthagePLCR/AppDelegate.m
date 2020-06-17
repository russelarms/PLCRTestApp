//
//  AppDelegate.m
//  CarthagePLCR
//
//  Created by Руслан Урмеев on 27.05.2020.
//  Copyright © 2020 Ruslan Urmeev. All rights reserved.
//

#import "AppDelegate.h"
@import CrashReporter;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
  NSError *error;

  // Check if we previously crashed
  if ([crashReporter hasPendingCrashReport])
      [self handleCrashReport];

  // Enable the Crash Reporter
  if (![crashReporter enableCrashReporterAndReturnError: &error])
      NSLog(@"Warning: Could not enable crash reporter: %@", error);

  return YES;
}

//
// Called to handle a pending crash report.
//
- (void) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;

    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        return;
    }

    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        return;
    }

    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
          report.signalInfo.code, report.signalInfo.address);

    // Purge the report
    [crashReporter purgePendingCrashReport];
    return;
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


@end
