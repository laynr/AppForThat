//
//  ItemsViewController.h
//  Homeowner
//
//  Created by me on 2/3/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;

@interface ItemsViewController : UITableViewController {
	ItemDetailViewController *detailViewController;
	UIView *headerView;
	NSMutableArray *possessions;

}

- (UIView *)headerView;

@end
