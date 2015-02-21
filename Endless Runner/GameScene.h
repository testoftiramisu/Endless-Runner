//
//  GameScene.h
//  Endless Runner
//

//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Background;
@interface GameScene : SKScene

@property (strong, nonatomic)Background *currentBackground;
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (assign) double score;

@end
