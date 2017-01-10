//
//  AppDelegate.h
//  Sprinkler Controller
//
//  Created by Nikhil Narang on 4/8/16.
//  Copyright © 2016 Nikhil Narang. All rights reserved.
//

#import <UIKit/UIKit.h>

// AppDelegate interfaces with UIResponder
//  - UIApplicationDelegate provides UI event messages
//  - NSStreamDelegate provides stream event messages
@interface AppDelegate : UIResponder <UIApplicationDelegate, NSStreamDelegate>

// methods
- (void)setUserIP:(NSString *)userIPAddr;
- (NSString*)getUserIP;
- (void)initNetworkConnection;

// properties
@property (nonatomic,strong) UIWindow *window; // co-ordinates views on the iOS device
@property (nonatomic,retain) NSString *userIPAddrBuf;
@property (nonatomic,retain) NSInputStream *inputStream;
@property (nonatomic,retain) NSOutputStream *outputStream;
@property (nonatomic,retain) NSMutableData *inputStreamData;

@end