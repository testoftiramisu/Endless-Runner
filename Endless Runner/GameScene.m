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
        self.currentBackground = [Background generateNewBackground:size];
        [self addChild:self.currentBackground];
    }
    
    self.physicsWorld.gravity = CGVectorMake(0, globalGravity);
    
    Player *player = [[Player alloc] init];
    player.position = CGPointMake(150, (player.size.height / 2) + 1);
    self.currentPlayer = player;
    [self addChild:player];
    
    self.score = 0;
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
    self.scoreLabel.fontSize = 30;
    self.scoreLabel.color = [UIColor whiteColor];
    self.scoreLabel.position = CGPointMake(size.width - 50, 280);
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
    
    // Long tap
    UILongPressGestureRecognizer *tapper =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(tappedScreen:)];
    tapper.minimumPressDuration = 0.1;
    [view addGestureRecognizer:tapper];
}

- (void)handleSwipeRight:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized && self.currentPlayer.selected == NO){
        // disabled for now
        // backgroundMoveSpeed += 50;
    }
}

- (void)handleSwipeLeft:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized && backgroundMoveSpeed > 50 && self.currentPlayer.selected == NO) {
        // disabled for now
        // backgroundMoveSpeed -= 50;
    }
}

- (void)tappedScreen:(UITapGestureRecognizer *)recognizer
{
    Player *player = self.currentPlayer;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        player.accelerating = YES;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        player.accelerating = NO;
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    Player *player = self.currentPlayer;
    
    if (player.selected) {
        // player.anchorPoint = CGPointMake(0.5, 0.5);
        // player.position = [touch locationInNode:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.currentPlayer.selected) {
        self.currentPlayer.selected = NO;
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

    // Moving of the background
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
        Background *tempBackground = [Background generateNewBackground:self.size];
        tempBackground.position = CGPointMake(self.currentBackground.size.width, 0);
        [self addChild:tempBackground];
        self.currentBackground = tempBackground;
    }
    
//    Player *player = self.currentPlayer;
//    float delta =
//    (self.manager.accelerometerData.acceleration.x - self.baseline) * accelerometerMultiplier;
//    
//    // Player position
//    player.position = CGPointMake(player.position.x, player.position.y - delta);
    
    // Score update
    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    [self enumerateChildNodesWithName:@"player"
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               Player *enumeratedPlayer = (Player *)node;
                               if (enumeratedPlayer.accelerating) {
                                   [enumeratedPlayer.physicsBody
                                    applyForce:CGVectorMake(0, playerJumpForce * timeSinceLast)];
                                   enumeratedPlayer .animationState = playerStateJumping;
                               } else if (enumeratedPlayer.position.y < (self.currentPlayer.size.height / 2) + 1){
                                   enumeratedPlayer.animationState = playerStateRunning;
                               }
                           }
     ];
}

@end
