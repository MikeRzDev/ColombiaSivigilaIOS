//
//  multideviceAttribMeasures.h
//  VigiaTuSalud
//
//  Created by Mike on 11/20/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface multideviceAttribMeasures : NSObject
+ (multideviceAttribMeasures *)sharedMeasures;
-(NSInteger) getSmallTextMeasures;
-(NSInteger) getBigTextMeasures;
-(NSInteger) getComboboxWidth;
-(NSInteger) getComboboxHeight;

@end
