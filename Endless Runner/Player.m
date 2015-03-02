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
        
        self.engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"jet"
                                                              ofType:@"sks"]];
        self.engineEmitter.position = CGPointMake(-55, -45);
        self.engineEmitter.name = @"jetEmitter";
        [self addChild:self.engineEmitter];
        self.engineEmitter.hidden = YES;
        self.engineEmitter.zPosition = 8;
        
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
    
    self.shieldOnFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOnAtlas = [SKTextureAtlas atlasNamed:@"shield"];
    
    for (int i = 0; i < [shieldOnAtlas.textureNames count]; ++i) {
        NSString *tempName = [NSString stringWithFormat:@"shield%.3d", i];
        SKTexture *tempTexture = [shieldOnAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOnFrames addObject:tempTexture];
        }
    }
    
    self.shieldOffFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOffAtlas = [SKTextureAtlas atlasNamed:@"delete"];
    
    for (int i = 0; i < [shieldOffAtlas.textureNames count]; ++i) {
        NSString *tempName = [NSString stringWithFormat:@"delete%.3d", i];
        SKTexture *tempTexture = [shieldOffAtlas textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOffFrames addObject:tempTexture];
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
    self.shielded = NO;
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
    
    self.shielded = YES;
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

- (void)setShielded:(BOOL)shielded
{
    if (shielded) {
        if (![self.shield actionForKey:@"shieldOn"]) {
            [self.shield runAction:[SKAction repeatActionForever:
                                    [SKAction animateWithTextures:self.shieldOnFrames
                                                     timePerFrame:0.1
                                                           resize:YES
                                                          restore:NO]]
                           withKey:@"shieldOn"];
        }
    } else if (_shielded){
        [self blinkRed];
        [self.shield removeActionForKey:@"shieldOn"];
        [self.shield runAction:[SKAction animateWithTextures:self.shieldOffFrames
                                                timePerFrame:0.1
                                                      resize:YES
                                                     restore:NO]
                       withKey:@"shieldOff"];
        
    }
    _shielded = shielded;
}

- (void)blinkRed
{
    SKAction *blinkRed = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor redColor]
                                                         colorBlendFactor:1.0
                                                                 duration:0.2],
                                              [SKAction waitForDuration:0.1],
                                              [SKAction colorizeWithColorBlendFactor:0.0
                                                                            duration:0.2]]];
    [self runAction:blinkRed];
}

- (void)setAccelerating:(BOOL)accelerating
{
    if (accelerating) {
        if (self.engineEmitter.hidden) {
            self.engineEmitter.hidden = NO;
        }
    } else {
            self.engineEmitter.hidden = YES;
    }
    _accelerating = accelerating;
}

@end
