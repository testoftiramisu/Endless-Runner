//
//  GameScene.m
//  Endless Runner
//
//  Created by Denys Khlivnyy on 20/02/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Background.h"
#import "Player.h"
#import "Enemy.h"
#import "Powerup.h"

@implementation GameScene

- (id)initWithSize:(CGSize)size
{
    // Accelerometer suport disabled for now
    // self.manager = [[CMMotionManager alloc] init];
    // self.manager.accelerometerUpdateInterval = 0.1;
    // [self.manager startAccelerometerUpdates];
    
    // [self performSelector:@selector(adjustBaseline)
    //           withObject:nil
    //           afterDelay:0.1];
    
    if (self = [super initWithSize:size]) {
        self.currentBackground = [Background generateNewBackground:size];
        [self addChild:self.currentBackground];
        self.currentParallax = [Background generateNewParallax];
        [self addChild:self.currentParallax];
    }
    
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
    
    for (int i = 0; i < maximumEnemies; ++i) {
        [self addChild:[self spawnEnemy]];
    }
    for (int i = 0; i < maximumPowerups; ++i) {
        [self addChild:[self spawnPowerup]];
    }
    
    self.physicsWorld.gravity = CGVectorMake(0, globalGravity);
    self.physicsWorld.contactDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameOver)
                                                 name:@"playerDied"
                                               object:nil];
    [self setupMusic];
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
    UIGestureRecognizer *oldGR = view.gestureRecognizers[0];
    [view removeGestureRecognizer:oldGR];
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
    __unused UITouch *touch = [touches anyObject];
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
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        node.position = CGPointMake(node.position.x - backgroundMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < -(node.frame.size.width + 100)) {
            // if the node went completely off screen
            // (with some extra pixels)
            // remove it
            [node removeFromParent];
        }
    }];
    
    // We create new background node and set it as current node
    if (self.currentBackground.position.x < 2) {
        Background *tempBackground = [Background generateNewBackground:self.size];
        tempBackground.position = CGPointMake(self.currentBackground.size.width, 0);
        [self addChild:tempBackground];
        self.currentBackground = tempBackground;
    }
    
    // Moving the Parallax background
    [self enumerateChildNodesWithName:parallaxName
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        node.position = CGPointMake(node.position.x - paralaxMoveSpeed * timeSinceLast, node.position.y);
        if (node.position.x < -(node.frame.size.width + 100)) {
            // if the node went of the screen, remove it
            [node removeFromParent];
        }
    }];
    
    if (self.currentParallax.position.x < 500) {
        Background *tempParallax = [Background generateNewParallax];
        tempParallax.position = CGPointMake(self.currentParallax.position.x + self.currentParallax.frame.size.width, 0);
        [self addChild:tempParallax];
        self.currentParallax = tempParallax;
    }
    
    // Accelerometer support is disabled:
    // Player *player = self.currentPlayer;
    // float delta =
    // (self.manager.accelerometerData.acceleration.x - self.baseline) * accelerometerMultiplier;
    
    // Player position
    // player.position = CGPointMake(player.position.x, player.position.y - delta);
    
    // Score update:
    self.score = self.score + (backgroundMoveSpeed * timeSinceLast / 100);
    
    // Jamp handling:
    [self enumerateChildNodesWithName:@"player"
                           usingBlock:^(SKNode *node, BOOL *stop) {
                               Player *enumeratedPlayer = (Player *)node;
                               if (enumeratedPlayer.accelerating) {
                                   [enumeratedPlayer.physicsBody
                                    applyForce:CGVectorMake(0, playerJumpForce * timeSinceLast)];
                                   enumeratedPlayer.animationState = playerStateJumping;
                               } else if (enumeratedPlayer.position.y < (self.currentPlayer.size.height / 2) + 1){
                                   enumeratedPlayer.animationState = playerStateRunning;
                               }
                           }
     ];
    
    // Enemy moving
    [self enumerateChildNodesWithName:@"enemy"
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        Enemy *enemy = (Enemy *)node;
        enemy.position = CGPointMake(enemy.position.x - backgroundMoveSpeed * timeSinceLast, enemy.position.y);
        if (enemy.position.x < -200) {
            enemy.position = CGPointMake(self.size.width +  arc4random() % 800, arc4random() % 240 + 40);
            enemy.hidden = NO;
        }
    }];
    
    // Moving of Shield powerup
    [self enumerateChildNodesWithName:@"shieldPowerup"
                           usingBlock:^(SKNode *node, BOOL *stop)
    {
        Powerup *shield = (Powerup *)node;
        shield.position = CGPointMake(shield.position.x - backgroundMoveSpeed *timeSinceLast, 5);
        if (shield.position.x < -200) {
            shield.position = CGPointMake(self.size.width + arc4random() % 100, 5);
            shield.hidden = NO;
        }
    }];
}

- (Enemy *)spawnEnemy
{
    Enemy *temp = [[Enemy alloc] init];
    temp.name = @"enemy";
    temp.position = CGPointMake(self.size.width + arc4random() % 800, arc4random() % 240 + 40);
    return temp;
}

- (Powerup *)spawnPowerup
{
    Powerup *temp = [[Powerup alloc] init];
    temp.name = @"shieldPowerup";
    temp.position = CGPointMake(self.size.width + arc4random() % 100, arc4random() % 240 + 40);
    return temp;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    Player *player = nil;
    
    if (contact.bodyA.categoryBitMask == playerBitmask) {
        player = (Player *)contact.bodyA.node;
        if (contact.bodyB.categoryBitMask == shieldPowerupBitmask) {
            player.shielded = YES;
            contact.bodyB.node.hidden = YES;
        }
        if (contact.bodyB.categoryBitMask == enemyBitmask) {
            [player takeDamage];
            contact.bodyB.node.hidden = YES;
        }
    }else {
        player = (Player *)contact.bodyB.node;
        if (contact.bodyA.categoryBitMask == shieldPowerupBitmask) {
            player.shielded = YES;
            contact.bodyA.node.hidden = YES;
        }
        if (contact.bodyA.categoryBitMask == enemyBitmask) {
            [player takeDamage];
            contact.bodyA.node.hidden = YES;
        }
    }
    
}

- (void)gameOver
{
    GameOverScene *newScene = [[GameOverScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:0.5];
    [self.view presentScene:newScene transition:transition];
    [self.musicPlayer stop];
}

- (void)setupMusic
{
    NSString *musicPatch =[[NSBundle mainBundle] pathForResource:@"Background"
                                                          ofType:@"mp3"];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPatch]
                                                              error:NULL];
    self.musicPlayer.numberOfLoops = -1;
    self.musicPlayer.volume = 1.0;
    [self.musicPlayer play];
}

@end
