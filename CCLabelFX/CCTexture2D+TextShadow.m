//
//  CCTexture2D+TextShadow.m
//  LabelsTest
//
//  Created by Jose Andrade on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCTexture2D+TextShadow.h"

#import "ccMacros.h"
#import "ccUtils.h"

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && CC_FONT_LABEL_SUPPORT
// FontLabel support
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#endif// CC_FONT_LABEL_SUPPORT

float addedPixels =0.0;

@implementation CCTexture2D (TextShadow)

- (CGSize)transformDimensions:(CGSize)dimensions offset:(CGSize)offset blur:(float)blur
{
    addedPixels = 0.0;
    if (blur >= 1)
        addedPixels = 13*log(blur)+blur*0.14;
    
    float newDimHeight = dimensions.height + fabs(offset.height) + addedPixels;
    float newDimWidth = dimensions.width + fabs(offset.width) + addedPixels;
    
    return CGSizeMake(newDimWidth, newDimHeight);
}

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment font:(id)uifont shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur shadowColor:(float[])shadowColor fillColor:(float[])fillColor
{
	NSAssert( uifont, @"Invalid font");
	
	NSUInteger POTWide = ccNextPOT(dimensions.width);
	NSUInteger POTHigh = ccNextPOT(dimensions.height);
	unsigned char*			data;
	
	CGContextRef			context;
	CGColorSpaceRef			colorSpace;
    
	colorSpace = CGColorSpaceCreateDeviceRGB();
	data = calloc(POTHigh, POTWide * 4);
	context = CGBitmapContextCreate(data, POTWide, POTHigh, 8, 4 * POTWide, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);		
    
	CGColorSpaceRelease(colorSpace);
	
	if( ! context ) 
    {
		free(data);
		[self release];
		return nil;
	}
    
    CGContextSetRGBFillColor(context, fillColor[0], fillColor[1], fillColor[2] , fillColor[3]);
	CGContextTranslateCTM(context, 0.0f, POTHigh);
	CGContextScaleCTM(context, 1.0f, -1.0f); //NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
    
    if(shadowColor)
    {
        CGColorRef color = CGColorCreate(CGColorSpaceCreateDeviceRGB(),shadowColor);
        CGContextSetShadowWithColor (context,shadowSize,shadowBlur,color);
        CGColorRelease(color);
    }
    
	UIGraphicsPushContext(context);
    
    CGRect stringRect = CGRectMake(-shadowSize.width*0.5, 0.5*(fabs(shadowSize.height) + shadowSize.height + addedPixels) , dimensions.width, dimensions.height);
    
	// normal fonts
	if( [uifont isKindOfClass:[UIFont class] ] )
		[string drawInRect:stringRect withFont:uifont lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
	
#if CC_FONT_LABEL_SUPPORT
	else // ZFont class 
		[string drawInRect:stringRect withZFont:uifont lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
#endif
	
	UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:POTWide pixelsHigh:POTHigh contentSize:dimensions];
    
	CGContextRelease(context);
	[self releaseData:data];
    
	return self;
}

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment attributedString:(NSAttributedString*)stringWithAttributes shadowOffset:(CGSize)shadowSize
           shadowBlur:(float)shadowBlur shadowColor:(float[])shadowColor fillColor:(float[])fillColor
{				
	NSAssert( stringWithAttributes, @"Invalid stringWithAttributes");
    
	NSUInteger POTWide = ccNextPOT(dimensions.width);
	NSUInteger POTHigh = ccNextPOT(dimensions.height);
	unsigned char*			data;
	
	NSSize realDimensions = [stringWithAttributes size];
    
	//Alignment
	float xPadding = 0;
	
	// Mac crashes if the width or height is 0
	if( realDimensions.width > 0 && realDimensions.height > 0 ) {
		switch (alignment) {
			case CCTextAlignmentLeft: xPadding = 0; break;
			case CCTextAlignmentCenter: xPadding = (dimensions.width-realDimensions.width)/2.0f; break;
			case CCTextAlignmentRight: xPadding = dimensions.width-realDimensions.width; break;
			default: break;
		}
		
		//Disable antialias
		[[NSGraphicsContext currentContext] setShouldAntialias:NO];	
		
		NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(POTWide, POTHigh)];
		[image lockFocus];	
		
        [stringWithAttributes drawInRect:NSMakeRect(xPadding -shadowSize.width*0.5, -0.5*(fabs(shadowSize.height) + shadowSize.height), POTWide, POTHigh)];
		
		NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect (0.0f, 0.0f, POTWide, POTHigh)];
		[image unlockFocus];
		
		data = (unsigned char*) [bitmap bitmapData];  //Use the same buffer to improve the performance.
		
		NSUInteger textureSize = POTWide*POTHigh;
		//for(int i = 0; i<textureSize; i++) //Convert RGBA8888 to A8
		//	data[i] = data[i*4+3];
		
		data = [self keepData:data length:textureSize];
		self = [self initWithData:data pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:POTWide pixelsHigh:POTHigh contentSize:dimensions];
		
		[bitmap release];
		[image release]; 
        
	} else {
		[self release];
		return nil;
	}
	
	return self;
}
#endif // __MAC_OS_X_VERSION_MAX_ALLOWED

- (id) initWithString:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size shadowOffset:(CGSize)shadowSize
           shadowBlur:(float)shadowBlur shadowColor:(float[])shadowColor fillColor:(float[])fillColor
{
    CGSize dim;
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	id font;
	font = [UIFont fontWithName:name size:size];
	if( font )
		dim = [string sizeWithFont:font];
    
#if CC_FONT_LABEL_SUPPORT
	if( ! font ){
		font = [[FontManager sharedManager] zFontWithName:name pointSize:size];
		if (font)
			dim = [string sizeWithZFont:font];
	}
#endif // CC_FONT_LABEL_SUPPORT
    
	if( ! font ) {
		CCLOG(@"cocos2d: Unable to load font %@", name);
		[self release];
		return nil;
	}
    
    CGSize newDimensions = [self transformDimensions:dim offset:shadowSize blur:shadowBlur];
    
	return [self initWithString:string dimensions:newDimensions alignment:CCTextAlignmentCenter font:font shadowOffset:shadowSize 
                     shadowBlur:shadowBlur shadowColor:shadowColor fillColor:fillColor];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	{
		NSSize shadowNSSize = NSSizeFromCGSize(shadowSize);
        
        NSShadow *textShadow = [[NSShadow alloc] init];
        [textShadow setShadowColor:[NSColor colorWithDeviceRed:shadowColor[0] green:shadowColor[1] blue:shadowColor[2] alpha:shadowColor[3]]];
        [textShadow setShadowBlurRadius:shadowBlur];
        [textShadow setShadowOffset:shadowNSSize];
        
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSColor colorWithDeviceRed:fillColor[0] green:fillColor[1] blue:fillColor[2] alpha:fillColor[3]],
                                          NSForegroundColorAttributeName,
                                          textShadow, NSShadowAttributeName,
                                          [[NSFontManager sharedFontManager]
                                           fontWithFamily:name
                                           traits:NSUnboldFontMask | NSUnitalicFontMask
                                           weight:0
                                           size:size], NSFontAttributeName, nil];
        
        //String with attributes
        NSAttributedString *stringWithAttributes = [[[NSAttributedString alloc] initWithString:string attributes:stringAttributes] autorelease];
        
        [textShadow release];
        
        //dim = NSSizeToCGSize( [stringWithAttributes size] );
        dim = [self transformDimensions:[stringWithAttributes size] offset:NSSizeToCGSize(shadowSize) blur:shadowBlur];
        
		return [self initWithString:string dimensions:dim alignment:CCTextAlignmentCenter attributedString:stringWithAttributes shadowOffset:shadowSize 
                         shadowBlur:shadowBlur shadowColor:shadowColor fillColor:fillColor];
	}
#endif // __MAC_OS_X_VERSION_MAX_ALLOWED
    
}

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
         shadowOffset:(CGSize)shadowSize
           shadowBlur:(float)shadowBlur
          shadowColor:(float[])shadowColor
            fillColor:(float[])fillColor
{
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	id						uifont = nil;
    
	uifont = [UIFont fontWithName:name size:size];
    
#if CC_FONT_LABEL_SUPPORT
	if( ! uifont )
		uifont = [[FontManager sharedManager] zFontWithName:name pointSize:size];
#endif // CC_FONT_LABEL_SUPPORT
	if( ! uifont ) {
		CCLOG(@"cocos2d: Texture2d: Invalid Font: %@. Verify the .ttf name", name);
		[self release];
		return nil;
	}
	
	CGSize newDimensions = [self transformDimensions:dimensions offset:shadowSize blur:shadowBlur];
    
	return [self initWithString:string dimensions:newDimensions alignment:alignment font:uifont shadowOffset:shadowSize 
                     shadowBlur:shadowBlur shadowColor:shadowColor fillColor:fillColor];
	
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	
	NSSize shadowNSSize = NSSizeFromCGSize(shadowSize);
    
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowColor:[NSColor colorWithDeviceRed:shadowColor[0] green:shadowColor[1] blue:shadowColor[2] alpha:shadowColor[3]]];
    [textShadow setShadowBlurRadius:shadowBlur];
    [textShadow setShadowOffset:shadowNSSize];
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSColor colorWithDeviceRed:fillColor[0] green:fillColor[1] blue:fillColor[2] alpha:fillColor[3]],
                                      NSForegroundColorAttributeName,
                                      textShadow, NSShadowAttributeName,
                                      [[NSFontManager sharedFontManager]
                                       fontWithFamily:name
                                       traits:NSUnboldFontMask | NSUnitalicFontMask
                                       weight:0
                                       size:size], NSFontAttributeName, nil];
    
    //String with attributes
    NSAttributedString *stringWithAttributes = [[[NSAttributedString alloc] initWithString:string attributes:stringAttributes] autorelease];
    
    [textShadow release];
    
    CGSize dim = [self transformDimensions:dimensions offset:NSSizeToCGSize(shadowSize) blur:shadowBlur];
    
    return [self initWithString:string dimensions:dim alignment:CCTextAlignmentCenter attributedString:stringWithAttributes shadowOffset:shadowSize 
                     shadowBlur:shadowBlur shadowColor:shadowColor fillColor:fillColor];
    
#endif // Mac
    
}

@end
