//
//  TouchDrawViewController.h
//  TouchTracker
//
//  Created by me on 2/4/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppStructrAppDelegate.h"
#import "TouchDrawView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface TouchDrawViewController : UIViewController <AVAudioRecorderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, TouchDrawViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	NSMutableDictionary *button;
	NSMutableArray  *buttons;
	NSMutableDictionary *plist;
	UITextField *labelText;
	UITextField *targetText;
	CGRect drawnRectangle;
	NSString *target;
	UIPickerView* picker;
	NSNumber *action;
	NSString *titleOfTargetAlertAction;
	NSString *label;
	NSString *backgroundImage;
	BOOL imagePicked;
	UIImage* sourceImage;
	NSURL * soundFile;
	AVAudioRecorder * recorder;
	NSError * error;
	
	
	
}
@property(nonatomic, retain) NSMutableDictionary *button;
@property(nonatomic, retain) NSArray  *buttons;
@property(nonatomic, retain) NSMutableDictionary *plist;
@property(nonatomic) CGRect drawnRectangle;
@property(nonatomic, retain) NSString *target;
@property(nonatomic, retain) NSString *label;
@property(nonatomic, retain) NSNumber *action;
@property(nonatomic, retain) NSString *titleOfTargetAlertAction;
@property(nonatomic, retain) NSString *backgroundImage;
@property(nonatomic) BOOL imagePicked;

-(UIImage*)imageByScalingToSize:(CGSize)targetSize;

@end
