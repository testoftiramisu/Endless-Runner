//
//  Player.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)init
{
    self = [super initWithImageNamed:@"character_idle"];
    {
        self.name = playerName;
        self.zPosition = 10;
        self.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.mass = playerMass;
        self.physicsBody.collisionBitMask = (unsigned)playerCollisionBitmask;
        self.physicsBody.allowsRotation = NO;
    }
    return self;
}

@end
