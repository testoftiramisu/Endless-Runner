//
//  GameScene.h
//  Endless Runner
//

//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import CoreMotion;
@import AVFoundation;

@class Background;
@class Player;
@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (strong, nonatomic)Background *currentBackground;
@property (strong, nonatomic)Background *currentParallax;
@property (strong, nonatomic)Player *currentPlayer;
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (assign) double score;
@property (strong, nonatomic) CMMotionManager *manager;
@property (assign) float baseline;


@end
