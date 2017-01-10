//
//  ViewController.m
//  Sprinkler Controller
//
//  Created by Nikhil Narang on 4/8/16.
//  Copyright © 2016 Nikhil Narang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

const uint8_t zoneOnCommands[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
const uint8_t zoneOffCommands[] = {0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18};

@interface ViewController () {
  AppDelegate *appDelegate;
  NSArray *_zonePickerData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  // socket open success notification
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleSocketOpenSuccess)
                                               name:SOCKET_OPEN_SUCCESS
                                             object:nil];
  
  // store zone picker data
  _zonePickerData = @[@"Zone 1", @"Zone 2", @"Zone 3", @"Zone 4", @"Zone 5", @"Zone 6", @"Zone 7", @"Zone 8"];
  
  
  // set data source and delegate
  self.zonePicker.dataSource = self;
  self.zonePicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

/** 
 * Alert the user a socket has been opened successfully
 */
- (void)handleSocketOpenSuccess {
  // create success alert
  UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Success!"
                                        message:@"You are now connected to your device."
                                 preferredStyle:UIAlertControllerStyleAlert];
  
  // create ok action
  UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                           }];
  
  // add ok action to alert
  [alert addAction:ok];
  
  // display alert
  [self presentViewController:alert animated:YES completion:nil];
}

/**
 * Set user IP address and initialize network communication
 * @param {id} sender - object that sent message to selector
 */
- (IBAction)setIP:(id)sender {
  NSString *userIPAddr = _IPField.text;
  appDelegate.userIPAddrBuf = userIPAddr;
  [appDelegate setUserIP:userIPAddr];
  [appDelegate initNetworkConnection];
}

/**
 * Return the number of columns of data for the picker
 * @param {UIPickerView *} pickerView - 
 * @return {NSInteger} - number of columns of data
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

/**
 * return the number of rows of data for the picker
 * @param {UIPickerView *} pickerView - 
 * @param {NSInteger} component -
 * @return {NSInteger} - number of rows of data
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return _zonePickerData.count;
}

/** 
 * The data to return for the row and component (column) that's being passed in
 * @param {UIPickerView *} pickerView -
 * @param {NSInteger} row -
 * @param {NSInteger} component -
 * @return {NSString *} -
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return _zonePickerData[row];
}

- (void)handleMessages:(NSNotification *)notification {
    
}

- (IBAction)updateZoneSetting:(id)sender {
  NSLog(@"Zone Selected");
  // TODO: DISABLE SEGMENTED CONTROL UNTIL DATA RECEIVED
}

- (IBAction)toggleZone:(UISegmentedControl *)sender {
  
  @try {
    // selected zone
    NSInteger zone = [_zonePicker selectedRowInComponent:0] + 1;
    
    // selected setting
    NSString *setting = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    uint8_t zoneCommand;
    
    if ([setting  isEqual: @"ON"]) {
      zoneCommand = (uint8_t) zoneOnCommands[zone - 1];
    } else if ([setting  isEqual: @"OFF"]) {
      zoneCommand = (uint8_t) zoneOffCommands[zone - 1];
    }
    
    // response message (format - TYPE : ZONE_NUMBER : SETTING/0)
    // NSString *response = [NSString stringWithFormat:@"POST : %ld : %@\r\n",(long)zone,setting];
    uint8_t UpdateZoneCommand[2];
    UpdateZoneCommand[0] = 0x21; // '!'
    UpdateZoneCommand[1] = zoneCommand;
    
    // NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    NSData *data = [NSData dataWithBytes:UpdateZoneCommand length:2];
    [appDelegate.outputStream write:[data bytes] maxLength:[data length]];
  }
  @catch (NSException *exception) {
    NSLog(@"%@",[exception debugDescription]);
  }
}

/**
 * Hide status bar
 * @returns {BOOL} - status bar display preference
 */
- (BOOL)preferStatusBarHidden {
  return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
  NSLog(@"Application Entered Foreground");
  appDelegate.userIPAddrBuf = [appDelegate getUserIP];
  [appDelegate initNetworkConnection];
}

@end