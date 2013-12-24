//
//  multideviceAttribMeasures.m
//  VigiaTuSalud
//
//  Created by Mike on 11/20/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "multideviceAttribMeasures.h"
#import "attribMeasures.h"
#define ipadDevice 1
#define iphoneDevice 2

@implementation multideviceAttribMeasures

static NSInteger deviceType;

static multideviceAttribMeasures *_multideviceAttribMeasures;

+ (multideviceAttribMeasures *)sharedMeasures
{
    if (!_multideviceAttribMeasures) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _multideviceAttribMeasures = [[multideviceAttribMeasures alloc] init];
        });
        
    }
    
    return _multideviceAttribMeasures;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self getDeviceType];
    }
    
    return self;
}



-(void) getDeviceType
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        deviceType = ipadDevice;
    }
    else
    {
        deviceType = iphoneDevice;
    }
}

-(NSInteger) getSmallTextMeasures
{
    NSInteger value = 0;
    if (deviceType == iphoneDevice)
    {
        value = iphone_smallText;
    }
    else
    {
        value = ipad_smallText;
    }
    
    return value;
}


-(NSInteger) getBigTextMeasures
{
    NSInteger value = 0;
    if (deviceType == iphoneDevice)
    {
        value = iphone_bigText;
    }
    else
    {
        value = ipad_bigText;
    }
    
    return value;
}

-(NSInteger) getComboboxHeight
{
    NSInteger value = 0;
    if (deviceType == iphoneDevice)
    {
        value = iphone_comboboxHeight;
    }
    else
    {
        value = ipad_comboboxHeight;
    }
    
    return value;

}

-(NSInteger) getComboboxWidth
{
    NSInteger value = 0;
    if (deviceType == iphoneDevice)
    {
        value = iphone_comboboxWidth;
    }
    else
    {
        value = ipad_comboboxWidth;
    }
    
    return value;
    
}




@end
