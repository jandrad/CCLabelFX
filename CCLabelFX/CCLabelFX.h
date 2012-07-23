//
//  CCLabelFX.h
//  LabelsTest
//
//  Created by Jose Andrade on 2/17/11.
//  see LICENSE file for license terms
//

#import "CCLabelTTF.h"

/** CCLabelFX is a subclass of CCLabelTTF that knows how to render text labels
 *
 * All features from CCLabelTTF are valid in CCLabelFX
 *
 * CCLabelFX objects are slower than CCLabelTTF.
 */

@interface CCLabelFX : CCLabelTTF
{
    CGSize          shadowOffset_;
    float           shadowBlur_;
	ccColor4B       shadowColor_;
    ccColor4B       fillColor_;
}

/** creates a CCLabel from a fontname, alignment, dimension in points, font size in points, shadow offset in points, shadow blur in points, shadow color and fill color*/
+ (id) labelWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
          shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur shadowColor:(ccColor4B)sColor  fillColor:(ccColor4B)fColor;

/** creates a CCLabel from a fontname, font size in points, shadow offset in points, shadow blur in points, shadow color and fill color*/
+ (id) labelWithString:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size 
          shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur shadowColor:(ccColor4B)sColor fillColor:(ccColor4B)fColor;

/** creates a CCLabel from a fontname, alignment, dimension in points, font size in points, shadow offset in points, shadow blur in points, black shadow color and white fill color*/
+ (id) labelWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
          shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur;

/** creates a CCLabel from a fontname, font size in points, shadow offset in points, shadow blur in points, black shadow color and white fill color*/
+ (id) labelWithString:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size 
          shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur;

/** initializes the CCLabel from a fontname, alignment, dimension in points, font size in points, shadow offset in points, shadow blur in points, shadow color and fill color*/
- (id) initWithNSString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
         shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur shadowColor:(ccColor4B)sColor fillColor:(ccColor4B)fColor;

/** initializes the CCLabel from a fontname, font size in points, shadow offset in points, shadow blur in points, shadow color and fill color*/
- (id) initWithNSString:(NSString*)string  fontName:(NSString*)name fontSize:(CGFloat)size shadowOffset:(CGSize)shadowSize 
             shadowBlur:(float)shadowBlur shadowColor:(ccColor4B)sColor fillColor:(ccColor4B)fColor;

 /** initializes the CCLabel from a fontname, alignment, dimension in points, font size in points, shadow offset in points, shadow blur in points, black shadow color and white fill colot*/
- (id) initWithNSString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
           shadowOffset:(CGSize)shadowSize shadowBlur:(float)shadowBlur;

 /** initializes the CCLabel from a fontname, font size in points, shadow offset in points, shadow blur in points, black shadow color and white fill color*/
- (id) initWithNSString:(NSString*)string  fontName:(NSString*)name fontSize:(CGFloat)size shadowOffset:(CGSize)shadowSize
             shadowBlur:(float)shadowBlur;

/** Texture fill color, setting the fill color is as expensive as creating a new CCLabelFX */
@property (nonatomic,readwrite) ccColor4B fillColor;
/**  Texture shadow color, setting the shadow color is as expensive as creating a new CCLabelFX */
@property (nonatomic,readwrite) ccColor4B shadowColor;

@end
