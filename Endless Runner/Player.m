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
        [self setupAnimations];
        [self runAction:
         [SKAction repeatActionForever: [SKAction animateWithTextures:self.runFrames
                                                         timePerFrame:0.05
                                                               resize:YES
                                                              restore:NO]] withKey:@"running"];
    }
    return self;
}

- (void)setupAnimations
{
    self.runFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"run"];
    
    for (int i = 0; i < [runAtlas.textureNames count] / 2; ++i) {
        NSString *tempName = [NSString stringWithFormat:@"Run__%.3d", i];
        SKTexture *tempTexture = [runAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.runFrames addObject:tempTexture];
        }
    }
}

@end
