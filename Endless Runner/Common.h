//
//  Common.h
//  Endless Runner
//
//  Created by Denys Khlivnyy on 2/20/15.
//  Copyright (c) 2015 Denys Khlivnyy. All rights reserved.
//

#ifndef Endless_Runner_Common_h
#define Endless_Runner_Common_h

static NSString *backgroundName = @"background";
static NSInteger backgroundMoveSpeed = 60;
static NSString *playerName = @"player";
static NSInteger accelerometerMultiplier = 15;
static NSInteger playerMass = 50;
static NSInteger playerCollisionBitmask = 1;
static NSInteger playerJumpForce = 8000000;
static NSInteger globalGravity = -2.8;
static NSString *parallaxName = @"parallax";
static NSInteger paralaxMoveSpeed = 10;

const static int playerBitmask = 1;
const static int enemyBitmask = 2;
const static int shieldPowerBitmask = 4;
const static int groundBitmask = 8;
const static NSInteger maximumEnemies = 3;
const static NSInteger maximumPowerups = 1;

#endif
