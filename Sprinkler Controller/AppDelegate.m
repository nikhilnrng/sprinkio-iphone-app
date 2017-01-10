//
//  AppDelegate.m
//  Sprinkler Controller
//
//  Created by Nikhil Narang on 4/8/16.
//  Copyright © 2016 Nikhil Narang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

/**
 * Set a default user IP address
 * @param {NSString *} userIPAddr - ip address to be set
 */
- (void)setUserIP:(NSString *)userIPAddr {
  // access user preferences
  NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
  
  // set user IP address
  [prefs setObject:userIPAddr forKey:@"UserIPAddress"];
  
  // sync in memory cache with user's default database
  [[NSUserDefaults standardUserDefaults] synchronize];
}

/** 
 * Get the default user IP address
 */
- (NSString*)getUserIP {
  // access user preferences
  NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
  return [prefs objectForKey:@"UserIPAddress"];
}

/** 
 * Initializes readable and writeable streams connected to the TCP/IP port
 */
- (void)initNetworkConnection {
  // construct read/write stream classes
  CFReadStreamRef readStream;
  CFWriteStreamRef writeStream;
  
  // create read/write streams with socket
  CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_userIPAddrBuf, PORT, &readStream, &writeStream);
  // cast read and write CFStreams to NSStreams
  _inputStream = (__bridge_transfer NSInputStream*) readStream;
  _outputStream = (__bridge_transfer NSOutputStream*) writeStream;

  // set delegate as self to receive stream:handleEvent: messages
  [_inputStream setDelegate:self];
  [_outputStream setDelegate:self];

  // schedule streams to receive data on a run loop
  [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
    forMode:NSDefaultRunLoopMode];
  [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
    forMode:NSDefaultRunLoopMode];

  // open socket streams
  [_inputStream open];
  [_outputStream open];
}

/**
 * The delegate receives this message when a given event has occurred on a given stream.
 * @param {NSStream *} stream - The stream on which streamEvent occurred.
 * @param {NSStreamEvent} eventCode - The stream event that occurred.
 */
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
  // handle various stream events
  switch (eventCode) {
    // stream opened successfully
    case NSStreamEventOpenCompleted: 
      NSLog(@"Stream opened for %@",_userIPAddrBuf);
      [[NSNotificationCenter defaultCenter] postNotificationName:SOCKET_OPEN_SUCCESS
                                            object:self
                                            userInfo:nil];
      break;
      
    // stream has received bytes
    // TODO: HANDLE LONG MESSAGES
    case NSStreamEventHasBytesAvailable:
      if(stream == _outputStream) return;
      uint8_t buf[1024];
      long len = 0;
      len = (long)[(NSInputStream *)stream read:buf maxLength:1024];
      while([(NSInputStream *)stream hasBytesAvailable]) {
        len = (long)[(NSInputStream *)stream read:buf maxLength:sizeof(buf)];
        if(len > 0) {
          NSString *output = [[NSString alloc] initWithBytes:buf length:len encoding:NSASCIIStringEncoding];
          if(output != nil) {
            NSLog(@"Server message received: %@",output);
            
          } else {
            NSLog(@"no buffer!");
          }
        }
      }
      if(len) {
        [_inputStreamData appendBytes:(const void *)buf length:len];
      } else {
        NSLog(@"no buffer!");
      }
      break;
      
    // stream event error
    // TODO: ADD RESPONSE
    case NSStreamEventErrorOccurred:
      NSLog(@"Failed to connect to host");
      break;
      
    // end stream socket
    case NSStreamEventEndEncountered:
      NSLog(@"Closing stream...");
      // close socket streams
      [stream close];
      // remove schedule run loop
      [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
        forMode:NSDefaultRunLoopMode];
      // stream is ivar to reinitialize it in the future
      stream = nil;
      break;
      
    default:
      NSLog(@"%lu event logged",(unsigned long)eventCode);
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
