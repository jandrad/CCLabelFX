//
//  CCTexture2D+TextShadow.h
//  LabelsTest
//
//  Created by Jose Andrade on 2/17/11.
//  see LICENSE file for license terms

#import "CCTexture2D.h"


@interface CCTexture2D (TextShadow)

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
         shadowOffset:(CGSize)shadowSize
           shadowBlur:(float)shadowBlur
          shadowColor:(float[])shadowColor 
            fillColor:(float[])fillColor;

- (id) initWithString:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size
         shadowOffset:(CGSize)shadowSize
           shadowBlur:(float)shadowBlur
          shadowColor:(float[])shadowColor
            fillColor:(float[])fillColor;

@end
