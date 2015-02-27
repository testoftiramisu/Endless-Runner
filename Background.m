//
//  Background.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "Background.h"

@implementation Background

+ (Background *)generateNewBackground:(CGSize)screenSize
{
    Background *background = [[Background alloc] initWithImageNamed:@"background"];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = backgroundName;
    background.position = CGPointMake(0, 0);
    background.zPosition = 1;
    
    // background buttom edge
    background.physicsBody =
    [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 15) toPoint:CGPointMake(background.size.width, 15)];
    background.physicsBody.collisionBitMask = (unsigned)playerCollisionBitmask;
    
    // Background top edge
    SKNode *topCollider = [SKNode node];
    topCollider.position = CGPointMake(0, 0);
    topCollider.physicsBody =
    [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, screenSize.height)
                                 toPoint:CGPointMake(background.size.width, screenSize.height)];
    topCollider.physicsBody.collisionBitMask =  1;
    
    [background addChild:topCollider];
    return background;
}

@end
