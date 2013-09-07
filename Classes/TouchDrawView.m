//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by me on 2/4/10.
//  Copyright 2010 Scoutic LLC. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"


@implementation TouchDrawView
@synthesize backgroundImage;
@synthesize minX, maxX, minY, maxY;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        linesInProcess = [[NSMutableDictionary alloc] init];
		completeLines = [[NSMutableArray alloc] init];
		[self setMultipleTouchEnabled:NO];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {	
	[backgroundImage drawInRect:[self bounds]];
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 10.0);
	CGContextSetLineCap(context, kCGLineCapRound);
	
	//Draw complete lines in black  ///look at CGContextAddRect
	[[UIColor whiteColor] set];
	for (Line *line in completeLines) {
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		//CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextAddRect(context, CGRectMake([line begin].x,[line begin].y,(([line end].x) - ([line begin].x)),(([line end].y) - ([line begin].y))));
		CGContextStrokePath(context);
	}
	
	//Draw lines in process Red  ///look at CGContextAddRect
	[[UIColor blackColor] set];
	for (NSValue *v in linesInProcess) {
		Line *line = [linesInProcess objectForKey:v];
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		//CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextAddRect(context, CGRectMake([line begin].x,[line begin].y,(([line end].x) - ([line begin].x)),(([line end].y) - ([line begin].y))));
		CGContextStrokePath(context);
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches) {
		//Is this a double-tap
		if ([touch tapCount] > 1) {
			//[self clearAll];
			return;
		}
		// Use the touch object (packed in an NSValue) as the key
		NSValue *key = [NSValue valueWithPointer:touch];
			
		// Create a line for the value
		CGPoint loc = [touch locationInView:self];
		Line *newLine = [[Line alloc] init];
		[newLine setBegin:loc];
		[newLine setEnd:loc];
		
		//Put pair in dictionary
		[linesInProcess setObject:newLine forKey:key];
		
		//Memory Stuff
		[newLine release];
		
		//Start finding orgin and bounds
		CGRect bounds = [self bounds];
		NSLog(@"touchesBegan");
		minX = bounds.size.width;
		maxX = 0;
		minY = bounds.size.height;
		maxY = 0;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Update currentLocations
	for (UITouch *touch in touches) {
		NSValue *key = [NSValue valueWithPointer:touch];
		
		// Find the line for this touch
		Line *line = [linesInProcess objectForKey:key];
		
		//Update the line
		CGPoint loc = [touch locationInView:self];
		[line setEnd:loc];
		
		//NSLog(@"X = %f and Y = %f",loc.x, loc.y);
		if (minX > loc.x){
			minX = loc.x;
		}
		if (maxX < loc.x){
			maxX = loc.x;
		}
		if (minY > loc.y){
			minY = loc.y;
		}
		if (maxY < loc.y){
			maxY = loc.y;
		}
	}
	// Redraw
	[self setNeedsDisplay];
	

}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

- (void)endTouches:(NSSet *)touches
{
	//Remove ending touches from dictionary
	for (UITouch *touch in touches) {
		NSValue *key = [NSValue valueWithPointer:touch];
		Line *line = [linesInProcess objectForKey:key];
		
		//If this is a double-tap, line will be nil
		if (line) {
			[completeLines addObject:line];
			[linesInProcess removeObjectForKey:key];
		}
	}
	
	//Redraw
	[self setNeedsDisplay];
	
	CGRect myRect = CGRectMake(minX,minY,(maxX - minX),(maxY - minY));
	
	if ([delegate respondsToSelector:@selector(paintingViewDidFinishDrawing: withCGRect:)])
	{
		[delegate paintingViewDidFinishDrawing:self withCGRect:myRect];
	}
}



- (void)clearAll
{
	[linesInProcess removeAllObjects];
	[completeLines removeAllObjects];
	
	//Redraw
	[self setNeedsDisplay];
}

- (void) clearLast
{
	[completeLines removeLastObject];
	
	//Redraw
	[self setNeedsDisplay];
}

- (void)dealloc {
	[linesInProcess release];
	[completeLines release];
    [super dealloc];
}


@end
