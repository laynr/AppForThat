//
//  TouchDrawViewController.m
//  TouchTracker
//
//  Created by me on 2/4/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "TouchDrawViewController.h"
#import "TouchDrawView.h"


@implementation TouchDrawViewController
@synthesize button, buttons, plist, drawnRectangle, target, action, label, titleOfTargetAlertAction , backgroundImage, imagePicked;

- (id) init
{
	//
	buttons = [[NSMutableArray alloc] init];
	plist = [[NSMutableDictionary alloc] init];
	
	//Call the superclass's designated initializer
	[super initWithNibName:nil bundle:nil];
	
	//Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	//Give it a label
	[tbi setTitle:@"Design"];
	
	//Create a UIImage from a file
	UIImage *i = [UIImage imageNamed:@"Design.png"];
	
	//Put the image on the bar
	[tbi setImage:i];
	
	//background
	//[[self view] setBackgroundColor:[UIColor orangeColor]];
	
	//Set the title of the nav bar
	[[self navigationItem] setTitle:@"Make App For That"];
	
	return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {	
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!self.imagePicked) {
		// Get document path.
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:@"Background.png"];
		
		// Get app bundle path.
		NSString *appBundleFilePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
		
		// Get pointer to file manager.
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		[fileManager removeItemAtPath:documentFilePath error:nil];
		
		// Copy the app bundle file to the document directory.
		[fileManager copyItemAtPath:appBundleFilePath toPath:documentFilePath error:nil];
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Background" message:@"Select a background image to use." delegate:self cancelButtonTitle:@"Default" otherButtonTitles:@"Library", @"Camera", nil];
			[actionAlert setTag:6];
			[actionAlert show];
			[actionAlert release];
		} else {
			UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Background" message:@"Select a background image to use." delegate:self cancelButtonTitle:@"Default" otherButtonTitles:@"Library", nil];
			[actionAlert setTag:6];
			[actionAlert show];
			[actionAlert release];
		}
		
		
		TouchDrawView *tdv = [[TouchDrawView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[tdv setBackgroundImage:[UIImage imageWithContentsOfFile:documentFilePath]];
		[tdv setDelegate:self];
		//[tdv setBackgroundColor:[UIColor orangeColor]];
		[self setView:tdv];
	} else {
		// Get document path.
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:@"Background.png"];
		
		TouchDrawView *tdv = [[TouchDrawView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[tdv setBackgroundImage:[UIImage imageWithContentsOfFile:documentFilePath]];
		[tdv setDelegate:self];
		//[tdv setBackgroundColor:[UIColor orangeColor]];
		[self setView:tdv];
	}
	
	[super viewWillAppear:animated];
	[(TouchDrawView *)[self view] clearAll];
	
}

- (void)writePlist
{
	NSLog(@"writePlist Called");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"scoutic.a4t"];
	
	plist = [NSMutableDictionary dictionaryWithObjectsAndKeys: buttons, @"buttons", nil];
	
	[plist writeToFile:filePath atomically:YES];
	
}



-(void) buildButton
{

	NSNumber *x = [NSNumber numberWithFloat:drawnRectangle.origin.x];
	NSNumber *y = [NSNumber numberWithFloat:drawnRectangle.origin.y];
	NSNumber *h = [NSNumber numberWithFloat:drawnRectangle.size.height];
	NSNumber *w = [NSNumber numberWithFloat:drawnRectangle.size.width];
	NSLog(@"action=%@",self.action);
	NSLog(@"target=%@", self.target);
	NSLog(@"label=%@", self.label);

	
	
	button = [NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", w, @"width", h, @"height", self.action, @"action", self.target, @"target", self.label, @"label", nil];
	
	//[button setObject:target forKey:@"label"];
	[buttons addObject:button];
	[self writePlist];
}

-(void) getLabel
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button Label" message:@"this gets covered!" delegate:self cancelButtonTitle:@"No Label" otherButtonTitles:@"Set Label", nil];
	labelText = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
	[alert setTransform:myTransform];
	[labelText setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:labelText];
	[alert setTag:9];
	[alert show];
	[alert release];
}
-(void) getTarget
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.titleOfTargetAlertAction  message:@"this gets covered!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
	targetText = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
	[alert setTransform:myTransform];
	[targetText setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:targetText];
	[alert setTag:2];
	[alert show];
	[alert release];
}

-(void) getSound
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.titleOfTargetAlertAction  message:@"Record a sound to be played when this button is pressed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Start Recording", nil];
	[alert setTag:7];
	[alert show];
	[alert release];
}

- (void) getAction
{	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:@"What do you want this button to do?"
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:nil
								 //otherButtonTitles:@"Open Safari", @"Text Message", @"Make Call", @"Open Maps", @"Open Contacts", @"Open App Store", @"Take Picture", @"Play UTube Video", nil];
								 otherButtonTitles:@"Open Safari", @"Text Message", @"Make Call", @"Open Maps", @"Open Contacts", @"Play Sound", nil]; //], @"Open App Store", @"Pick Picture", @"Play UTube Video", nil];
	
	
	//popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	[popupQuery release];
	
}

- (void) paintingViewDidFinishDrawing:(TouchDrawView *)paintingView withCGRect:(CGRect)rectangle
{
	if ((rectangle.size.width <10) || (rectangle.size.height < 10)) {
		UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Object too Small" message:@"The drawing is too small to be usable.  Please draw a larger rectangle" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[actionAlert setTag:3];
		[actionAlert show];
		[actionAlert release];
	} else {
		drawnRectangle = rectangle;
		[self getAction];
	}				   
}
- (void)deviceAlert {
	// open a alert
	UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Unsupported Device" message:@"The device you are on does not support this action. If you continue you may enter a label the button will not respond when pushed." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
	[actionAlert setTag:5];
	[actionAlert show];
	[actionAlert release];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"cleanUp buttons");
	[buttons removeAllObjects];
}

-(BOOL)canSendTextMessage
{
	UIApplication* app = [UIApplication sharedApplication];
	return [app canOpenURL:[NSURL URLWithString:@"sms:12345"]];
}

-(BOOL)canMakePhoneCall
{
	UIApplication* app = [UIApplication sharedApplication];
	return [app canOpenURL:[NSURL URLWithString:@"tel:12345"]];
}

-(BOOL) canRecordAudio
{
	return [[AVAudioSession sharedInstance] inputIsAvailable];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex+1) {
		case kCancel: //Cancell
			[(TouchDrawView *)[self view] clearLast];
			break;
		case kSafari: //Safari
			self.action = ([NSNumber numberWithInt:kSafari]);
			self.titleOfTargetAlertAction  = @"Enter Web Address";
			[self getTarget];
			break;
		case kSMS: //text message
			self.action = ([NSNumber numberWithInt:kSMS]);
			self.titleOfTargetAlertAction  = @"Enter Text Number";
			
			if([self canSendTextMessage]){
				[self getTarget];
			}
			else{
				[self deviceAlert];
			}
			
			break;
		case kCall: //Make Call
			self.action = ([NSNumber numberWithInt:kCall]);
			self.titleOfTargetAlertAction  = @"Enter Phone Number";
			
			if([self canMakePhoneCall]){
				[self getTarget];
			}
			else{
				[self deviceAlert];
			}
			break;
		case kMaps: //Map
			self.action = ([NSNumber numberWithInt:kMaps]);
			self.titleOfTargetAlertAction = @"Enter Address";
			[self getTarget];
			break;
		case kContacts: //Contacts
			self.action = ([NSNumber numberWithInt:kContacts]);
			self.target = @"Open Contacts";
			[self getLabel];
			break;
		case kSound: //play sound
			self.action = ([NSNumber numberWithInt:kSound]);
			self.titleOfTargetAlertAction  = @"Record Sound";
			if([self canRecordAudio]){
				[self getSound];
			}
			else{
				[self deviceAlert];
			}
			break;
			/*			case kStore: //Store
			 self.action = ([NSNumber numberWithInt:kStore]);
			 self.titleOfTargetAlertAction  = @"Enter App ID";
			 [self getTarget];
			 break;
			 case kPicture: //Picture
			 self.action = ([NSNumber numberWithInt:kPicture]);
			 self.target = @"Pick Picture";
			 [self getLabel];
			 break;
			 case kYouTube: //Utube
			 self.action = ([NSNumber numberWithInt:kYouTube]);
			 self.titleOfTargetAlertAction  = @"Enter YouTube ID";
			 [self getTarget];
			 break;
			 */
		default:
			[(TouchDrawView *)[self view] clearLast];
			break;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch ([alertView tag]) {
		case 0:  //picking background image
			if (buttonIndex == 0) {
				//Reset first load
				break;
			}
			break;
			
		case 2: //typing in button target
			if (buttonIndex == 0) {
				if (targetText.text) {
					self.target = targetText.text;
					NSLog(@"target = %@", self.target);
					[self getLabel];
				} else {
					UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Input Required" message:@"The object requires input.  Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
					[actionAlert setTag:4];
					[actionAlert show];
					[actionAlert release];
				}
			}
			break;
		case 3: //Object too Small
			[(TouchDrawView *)[self view] clearLast];
			break;
		case 4: //Input Required
			[(TouchDrawView *)[self view] clearLast];
			break;
		case 5: //Unsupported Device
			switch (buttonIndex) {
				case 0:
					[(TouchDrawView *)[self view] clearLast];
					break;
				case 1:
					//[self getTarget];
					self.target = @"unsupportedDevice";
					[self getLabel];
					break;
			}
			break;
		case 6: //pick background
			if (buttonIndex == 0) //default background
			{
				//UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Create View" message:@"Select a background image to use and then start drawing the buttons on the screen with your finger and then follow the prompts.  When done select the top left button to return to the app you built!" delegate:self cancelButtonTitle:@"Default Background" otherButtonTitles:@"Choose Background", nil];
				UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Create App" message:@"Start drawing the buttons on the screen with your finger and then follow the prompts.  When done select the top left button to return to the app you built!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[actionAlert setTag:0];
				[actionAlert show];
				[actionAlert release];
			} 
			else if (buttonIndex == 1)  // libary
			{
				//take phoot
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				
				//set sourse to library
				[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
				
				// image picker need a delegate so we can respond to its messages
				[imagePicker setDelegate:self];
				
				//Place image picker on the screen
				[self presentModalViewController:imagePicker animated:YES];
				
				//The image picker will be retained by ItemDeailViewController until dismissed
				[imagePicker release];
			}
			else if (buttonIndex == 2) //camera
			{
				//take phoot
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				
				//if camer use it else pick a photo
				[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
				
				// image picker need a delegate so we can respond to its messages
				[imagePicker setDelegate:self];
				
				//Place image picker on the screen
				[self presentModalViewController:imagePicker animated:YES];
				
				//The image picker will be retained by ItemDeailViewController until dismissed
				[imagePicker release];
				
			}
			break;
			
		case 7: //start recording
			if (buttonIndex == 0) //default background
			{
				NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
				[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
				[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
				[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
				
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				self.target = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"];
				NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:self.target];
			
				soundFile = [NSURL fileURLWithPath:documentFilePath];
				NSLog(@"Using File called: %@",soundFile);

				recorder = [[ AVAudioRecorder alloc] initWithURL:soundFile settings:recordSetting error:&error];
				[recorder setDelegate:self];
				[recorder prepareToRecord];
				[recorder record];
				
				UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Recording" message:@"The device is recording sound, press stop recording when done." delegate:self cancelButtonTitle:@"Stop Recording" otherButtonTitles:nil];
				[actionAlert setTag:8];
				[actionAlert show];
				[actionAlert release];
	
			break;
			}
		case 8: //stop recording
			[recorder stop];
			[self getLabel];
			break;
		case 9: //label picker
			if (buttonIndex == 0) //default background
			{
				NSLog(@"no lable");
				self.label = @"scoutic.a4t";
				[self buildButton];
			} 
			if (buttonIndex == 1){
				self.label = labelText.text;
				NSLog(@"lable=%@",self.label);
				[self buildButton];
			}
			break;
	}
}



/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
/*
- (void)viewDidUnload {

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/

- (void)dealloc {
    [picker release];
    [super dealloc];
}

- (void) picker
{
	//PickerViewController
	picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	
	//self.view = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:picker];	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pic
{
	[pic dismissModalViewControllerAnimated:YES];
}

#pragma mark UIPickerViewDelegate methods

- (NSString*)pickerView:(UIPickerView*)pv titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%d",row];
}

#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pv
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pv numberOfRowsInComponent:(NSInteger)component
{
	return kCount;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	self.imagePicked = YES;
	
	//Get picked image from info dictionary
	sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	UIImage* image = [self imageByScalingToSize:[[UIScreen mainScreen] bounds].size];
	
	//Save Image
	 NSArray *ipaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *idocumentsDirectory = [ipaths objectAtIndex:0];
	 NSString *imagePath = [idocumentsDirectory stringByAppendingPathComponent:@"Background.png"];
	 NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
	 [imageData writeToFile:imagePath atomically:YES];

	
	//Take image picker off the screen
	//if you impement this method, you must call this dismiss method
	[self dismissModalViewControllerAnimated:YES];
	
	//UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Create View" message:@"Select a background image to use and then start drawing the buttons on the screen with your finger and then follow the prompts.  When done select the top left button to return to the app you built!" delegate:self cancelButtonTitle:@"Default Background" otherButtonTitles:@"Choose Background", nil];
	UIAlertView *actionAlert = [[UIAlertView alloc] initWithTitle:@"Create App" message:@"Start drawing the buttons on the screen with your finger and then follow the prompts.  When done select the top left button to return to the app you built!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[actionAlert setTag:0];
	[actionAlert show];
	[actionAlert release];
	
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

-(UIImage*)imageByScalingToSize:(CGSize)targetSize 
{
	//UIImage* sourceImage = self; 
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
	
	CGContextRef bitmap;
	
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
	}       
	
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return newImage; 
}


@end
