CCLabelFX
==================

CCLabelTTF subclass for Cocos2d with blurred shadow support.

![](http://img51.imageshack.us/img51/7784/img0845.png)


Usage
-----------------------

Add the CCLabelFX folder to your project. Import "CCLabelFX.h" where needed.

Example:

	ccColor4B shadowColor = ccc4(255,0,0,255);
	 ccColor4B fillColor = ccc4(0,0,255,255);
        
	CCLabelFX *label1 = [CCLabelFX labelWithString:@"Testing Labels with shadows" 
                                              fontName:@"Marker Felt" 
                                              fontSize:30 
                                          shadowOffset:CGSizeMake(-2,-2) 
                                            shadowBlur:2.0f 
                                           shadowColor:shadowColor 
                                             fillColor:fillColor];

See CCLabelFX.h ways to create a CClabelFX, also check out the sample project.

Warnings
-----------------------

   * Since CCLabelFX is a subclass of CCLabelTTF it is expensive to create. 
   * Setting the shadow color, fill color and string is as expensive as creating a new one.
   * When using large text with wrapping, make sure you don't use too much blur or a big shadow offset. It will generate unexpected results.
   * Don't handle the CCLabelFX color with the color property. Instead, set the fill color.

That's it, I hope you find it useful. Suggestions and corrections are always welcome.






