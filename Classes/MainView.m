//
//  MainView.m
//  App I Built
//
//  Created by me on 1/23/10.
//  Copyright Scoutic LLC 2010. All rights reserved.
//

#import "MainView.h"

@implementation MainView
@synthesize backgroundImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [backgroundImage drawInRect:[self bounds]];
}


- (void)dealloc {
    [super dealloc];
}


@end
