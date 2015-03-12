//
//  GameOverScene.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 12/03/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        SKLabelNode *node = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        node.text = @"Game Over";
        node.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        node.fontSize = 35;
        node.color = [UIColor whiteColor];
        [self addChild:node];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(newGame:)];
  
    [view addGestureRecognizer:tap];
    
}

- (void)newGame:(UITapGestureRecognizer *)recognizer
{
    GameScene *newScene = [[GameScene alloc] initWithSize:self.size];
    
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:newScene transition:transition];
}

@end
