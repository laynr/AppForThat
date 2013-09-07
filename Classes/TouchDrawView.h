//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by me on 2/4/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchDrawViewDelegate;


@interface TouchDrawView : UIView {
	NSMutableDictionary *linesInProcess;
	NSMutableArray *completeLines;
	UIImage *backgroundImage;
	float minX;
	float maxX;
	float minY;
	float maxY;
	
	id <TouchDrawViewDelegate> delegate;

}
@property (nonatomic, assign) id <TouchDrawViewDelegate> delegate;

@property(nonatomic, retain) UIImage *backgroundImage;
@property float minX;
@property float maxX;
@property float minY;
@property float maxY;

- (void) endTouches:(NSSet *)touches;
- (void) clearAll;
- (void) clearLast;


@end

// PROTOCOL

@protocol TouchDrawViewDelegate <NSObject>

- (void) paintingViewDidFinishDrawing:(TouchDrawView *)paintingView withCGRect:(CGRect)rectangle;

@end
