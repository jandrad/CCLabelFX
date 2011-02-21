//
//  HelloWorld.m
//  LabelsTest
//
//  Created by Jose Andrade on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorld.h"
#import "CCLabelFX.h"


@implementation HelloWorld

+ (id)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) 
	{
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        ccColor4B shadowColor = ccc4(255,0,0,255);
        ccColor4B fillColor = ccc4(0,0,255,255);
        
        CCLabelFX *label1 = [CCLabelFX labelWithString:@"Testing Labels with shadows" 
                                              fontName:@"Marker Felt" 
                                              fontSize:30 
                                          shadowOffset:CGSizeMake(-2,-2) 
                                            shadowBlur:2.0f 
                                           shadowColor:shadowColor 
                                             fillColor:fillColor];
        
        CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:label1 target:self selector:@selector(test:)];
        CCMenu *menu = [CCMenu menuWithItems:item1, nil];
        menu.position = ccp(size.width*0.5, size.height*0.85);
        [self addChild:menu];
        
        CCLabelFX *label2 = [CCLabelFX labelWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque orci enim, laoreet ac varius et, hendrerit nec lacus. Pellentesque tincidunt blandit ante sit amet lobortis." 
                                            dimensions:CGSizeMake(350, 100) 
                                             alignment:CCTextAlignmentCenter 
                                              fontName:@"Marker Felt" 
                                              fontSize:20 
                                          shadowOffset:CGSizeMake(-1.5, -1.5) 
                                            shadowBlur:1.0f];
        
        label2.position = ccp(size.width*0.5, size.height*0.5);
        label2.fillColor = ccc4(255,255,0,255); 
        
        CCLabelFX *label3 = [CCLabelFX labelWithString:@"Custom TTF Label" 
                                              fontName:@"DomesticManners.ttf" 
                                              fontSize:30 
                                          shadowOffset:CGSizeMake(-1.5,-1.5) 
                                            shadowBlur:1.0f];
        
        label3.position = ccp(size.width*0.5, size.height*0.25);
         
        [self addChild:label2];
        [self addChild:label3];
        
        
	}
	return self;
}

- (void)test:(id)sender
{
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
