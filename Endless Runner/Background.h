//
//  Background.h
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Background : SKSpriteNode

+ (Background *)generateNewBackground:(CGSize)size;
+ (Background *)generateNewParallax;

@end
