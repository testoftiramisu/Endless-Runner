//
//  GameScene.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 20/02/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"
#import "Player.h"

@implementation GameScene

- (id)initWithSize:(CGSize)size
{
    self.manager = [[CMMotionManager alloc] init];
    self.manager.accelerometerUpdateInterval = 0.1;
    [self.manager startAccelerometerUpdates];
    
    [self performSelector:@selector(adjustBaseline)
               withObject:nil
               afterDelay:0.1];
    
    if (self = [super initWithSize:size]) {
        self.currentBackground = [Background generateNewBackground];
        [self addChild:self.currentBackground];
    }
    
    Player *player = [[Player alloc] init];
    player.anchorPoint = CGPointMake(0, 0);
    player.position = CGPointMake(100, 0);
    self.currentPlayer = player;
    [self addChild:player];
    
    self.score = 0;
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    self.scoreLabel.fontSize = 30;
    self.scoreLabel.color = [UIColor whiteColor];
    self.scoreLabel.position = CGPointMake(size.width - 50, 300);
    self.scoreLabel.zPosition = 100;
    [self addChild:self.scoreLabel];
    
    SKAction *tempAction = [SKAction runBlock:^{
        self.scoreLabel.text = [NSString stringWithFormat:@"%3.0f", self.score];
    }];
    
    SKAction *waitAction = [SKAction waitForDuration:0.2];
    [self.scoreLabel runAction:
     [SKAction repeatActionForever:
      [SKAction sequence:@[tempAction, waitAction]]]];
    
    return self;
}

- (void)adjustBaseline
{
    self.baseline = self.manager.accelerometerData.acceleration.x;
}

- (void)didMoveToView:(SKView *)view {
    
     UISwipeGestureRecognizer *swiperRight =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeRight:)];
    
    swiperRight.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:swiperRight];
    
    UISwipeGestureRecognizer *swiperLeft =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeLeft:)];
    swiperLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swiperLeft];
}

- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized && self.currentPlayer.selected == NO)
    {
        backgroundMoveSpeed += 50;
    }
}

- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized && backgroundMoveSpeed > 50 && self.currentPlayer.selected == NO) {
        backgroundMoveSpeed -= 50;
    }
}

- (void)willMoveFromView:(SKView *)view
{
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
    
    if (touchedNode.name == playerName) {
        Player *player = (Player *)touchedNode;
        player.selected = YES;
        return;
    }
    
    // action to move the node that runs it by vector
    // of x and y components with duration in seconds
    SKAction *moveUp = [SKAction moveBy:CGVectorMake(0, 100) duration:0.8];
    
    // same as before, but it is opposite vector to go down, and it is a bit
    // faster, since gravity accelerates you
    SKAction *moveDown = [SKAction moveBy:CGVectorMake(0, - 100) duration:0.6];
    
    // sequence action allows you to compound few actions into one
    SKAction *seq = [SKAction sequence:@[moveUp, moveDown]];
    
    // childNodeWithName: method allows you to find any node in hierarchy with
    // certain name. This is useful if you don't want to store things
    // as instance variables or properties
    // Player *player = (Player *)[self childNodeWithName:playerName];
    
    // after creating all actions we tell character to execute them
    [self.currentPlayer runAction:seq];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    Player *player = self.currentPlayer;
    
    if (player.selected) {
        player.anchorPoint = CGPointMake(0.5, 0.5);
        player.position = [touch locationInNode:self];
        
        if (player.position.y < player.size.height / 2) {
            player.position = CGPointMake(player.position.x, (player.size.height / 2) + 1 );
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    Player *player = self.currentPlayer;
    if (player.selected) {
        player.selected = NO;
    }
}

- (void)update:(CFTimeInterval)currentTime {
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;

    if (timeSinceLast > 1) {
        // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self enumerateChildNodesWithName:backgroundName
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               node.position = CGPointMake(node.position.x - backgroundMoveSpeed * timeSinceLast, node.position.y);
                               
                               if (node.position.x < -(node.frame.size.width + 100)) {
                                   // if the node went completely off screen
                                   // (with some extra pixels)
                                   // remove it
                                   [node removeFromParent];
                               }
                           }];
    
    if (self.currentBackground.position.x < 2) {
        // we create new background node and set it as current node
        Background *tempBackground = [Background generateNewBackground];
        tempBackground.position = CGPointMake(self.currentBackground.size.width, 0);
        [self addChild:tempBackground];
        self.currentBackground = tempBackground;
    }
    
    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    
}

@end
