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
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:self.runFrames
                                          timePerFrame:0.07
                                                resize:YES
                                               restore:NO]]
                withKey:@"running"];
        self.shield = [[SKSpriteNode alloc] init];
        self.shield.blendMode = SKBlendModeAdd;
        [self addChild:self.shield];
    }
    return self;
}

- (void)setupAnimations
{
    self.runFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *runAtlas = [SKTextureAtlas atlasNamed:@"run"];
    
    for (int i = 0; i < [runAtlas.textureNames count]; ++i) {
        NSString *tempName = [NSString stringWithFormat:@"Run__%.3d", i];
        SKTexture *tempTexture = [runAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.runFrames addObject:tempTexture];
        }
    }
    
    self.jumpFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *jumpAtlas = [SKTextureAtlas atlasNamed:@"jump"];
    
    for (int i = 0; i < [jumpAtlas.textureNames count]; ++i) {
        NSString *tempName = [NSString stringWithFormat:@"Jump__%.3d", i];
        SKTexture *tempTexture = [jumpAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.jumpFrames addObject:tempTexture];
        }
    }
}

- (void)startRunningAnimation
{
    if (![self actionForKey:@"running"]) {
        [self runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:self.runFrames
                                          timePerFrame:0.07
                                                resize:YES
                                               restore:NO]]
                withKey:@"running"];
         }
}

- (void)stopRunningAnimation
{
    [self removeActionForKey:@"running"];
}

-(void)startJumpingAnimation
{
    if (![self actionForKey:@"jumping"]) {
        [self runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.jumpFrames
                                                              timePerFrame:0.03
                                                                    resize:YES
                                                                   restore:NO],
                                             [SKAction runBlock:^{ self.animationState = playerStateInAir;}]]]
                withKey:@"jumping"];
    }
}

- (void)setAnimationState:(playerState)animationState
{
    switch (animationState) {
        case playerStateJumping:
            if (_animationState == playerStateRunning) {
                [self stopRunningAnimation];
                [self startJumpingAnimation];
            }
            break;
        case playerStateInAir:
            [self stopRunningAnimation];
            break;
        case playerStateRunning:
            [self startRunningAnimation];
            break;
        default:
            break;
    }
    
    _animationState = animationState;
}

@end
