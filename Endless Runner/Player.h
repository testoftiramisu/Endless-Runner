//
//  Player.h
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

typedef enum playerState {
    playerStateRunning = 0,
    playerStateJumping,
    playerStateInAir
} playerState;

@property (assign) BOOL selected;
@property (assign, nonatomic) BOOL accelerating;
@property (assign, nonatomic) playerState animationState;
@property (strong, nonatomic) NSMutableArray *runFrames;
@property (strong, nonatomic) NSMutableArray *jumpFrames;

@property (strong, nonatomic) NSMutableArray *shieldOnFrames;
@property (strong, nonatomic) NSMutableArray *shieldOffFrames;
@property (strong, nonatomic) SKSpriteNode *shield;
@property (assign, nonatomic) BOOL shielded;

@property (strong, nonatomic) SKEmitterNode *engineEmitter;

- (void)takeDamage;

@end
