//
//  ViewController.h
//  Sprinkler Controller
//
//  Created by Nikhil Narang on 4/8/16.
//  Copyright © 2016 Nikhil Narang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIAlertViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,weak) IBOutlet UIPickerView *zonePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *zoneControl;
@property (nonatomic,strong) IBOutlet UITextField *IPField;
@property (nonatomic,weak) IBOutlet UIView *IPView;

- (IBAction)toggleZone:(id)sender;
- (IBAction)setIP:(id)sender;

@end