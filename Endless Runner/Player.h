//
//  Player.h
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (assign) BOOL selected;
@property (assign) BOOL accelerating;
@property (strong, nonatomic) NSMutableArray *runFrames;


@end
