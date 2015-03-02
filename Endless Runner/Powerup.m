//
//  Powerup.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 3/2/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup

- (void)setup
{
    self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                   [[NSBundle mainBundle] pathForResource:@"powerup"
                                                   ofType:@"sks"]];
    self.emitter.name = @"shildedEmitter";
    self.emitter.zPosition = 50;
    [self addChild:self.emitter];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.contactTestBitMask = playerBitmask;
    self.physicsBody.categoryBitMask = shieldPowerBitmask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = NO;
}

@end
