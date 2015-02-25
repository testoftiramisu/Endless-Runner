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
    
    background.physicsBody =
    [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 30) toPoint:CGPointMake(background.size.width, 30)];
    background.physicsBody.collisionBitMask = (unsigned)playerCollisionBitmask;
    
    SKNode *topCollider = [SKNode node];
    topCollider.position = CGPointMake(0, 0);
    topCollider.physicsBody =
    [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, background.size.height - 30)
                                 toPoint:CGPointMake(background.size.width, background.size.height - 30)];
    
    
    return background;
}

@end
