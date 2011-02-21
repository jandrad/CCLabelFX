//
//  GameConfig.h
//  LabelsTest
//
//  Created by Jose Andrade on 2/1/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//Collision Types
#define kBallCollisionType			1
#define kTrampolineCollisionType	2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationCCDirector
//#define GAME_AUTOROTATION kGameAutorotationUIViewController


#endif // __GAME_CONFIG_H
