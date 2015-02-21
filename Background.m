//
//  Background.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "Background.h"

@implementation Background

+ (Background *)generateNewBackground
{
    Background *background = [[Background alloc] initWithImageNamed:@"background"];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = backgroundName;
    background.position = CGPointMake(0, 0);
    background.zPosition = 1;
    return background;
}

@end
