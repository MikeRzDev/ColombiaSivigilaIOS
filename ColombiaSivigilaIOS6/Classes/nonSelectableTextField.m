//
//  nonSelectableTextField.m
//  ColombiaSivigila
//
//  Created by Mike on 12/10/13.
//  Copyright (c) 2013 iPRO. All rights reserved.
//

#import "nonSelectableTextField.h"

@implementation nonSelectableTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    

    if (action == @selector(selectAll:))
        return NO;
    
    if (action == @selector(select:))
        return NO;
    
    if (action == @selector(cut:))
        return NO;
    
    if (action == @selector(copy:))
        return NO;
    if (action == @selector(replaceCharactersInRange:withString:))
        return NO;
    
    if (action == @selector(paste:))
        return NO;
    
    
    
    return [super canPerformAction:action withSender:sender];

}


@end
