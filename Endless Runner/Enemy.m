//
//  Enemy.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 3/2/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void) setup
{
    self.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                    [[NSBundle mainBundle] pathForResource:@"enemy"
                                                    ofType:@"sks"]];
    self.emitter.name = @"enemyEmitter";
    self.emitter.zPosition = 50;
    [self addChild:self.emitter];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    self.physicsBody.contactTestBitMask = playerBitmask;
    self.physicsBody.categoryBitMask = enemyBitmask;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = NO;
}

@end
