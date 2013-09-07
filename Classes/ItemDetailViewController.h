//
//  ItemDetailViewController.h
//  Homeowner
//
//  Created by me on 2/3/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Possession.h"

@interface ItemDetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
	IBOutlet UIImageView *imageView;

	IBOutlet UITextField *nameField;
	IBOutlet UITextField *serialNumberField;
	IBOutlet UITextField *valueField;
	IBOutlet UILabel *dataLabel;
	
	Possession *editingPossession;
}
- (void)setEditingPossession:(Possession *)possession;



@end
