//
//  EventoSalud.h
//  VigiaTuSalud
//
//  Created by Mike on 11/22/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventoSalud : NSManagedObject

@property (nonatomic, retain) NSString * acccolec;
@property (nonatomic, retain) NSString * accind;
@property (nonatomic, retain) NSString * apolab;
@property (nonatomic, retain) NSString * casconf;
@property (nonatomic, retain) NSString * casprob;
@property (nonatomic, retain) NSString * cassosp;
@property (nonatomic, retain) NSString * descrevent;
@property (nonatomic, retain) NSString * diagdif;
@property (nonatomic, retain) NSString * fichnotif;
@property (nonatomic, retain) NSString * linkurl;
@property (nonatomic, retain) NSString * nomeven;
@property (nonatomic, retain) NSString * nomgrup;
@property (nonatomic, retain) NSString * nomsubgru;
@property (nonatomic, retain) NSString * otrapoyo;
@property (nonatomic, retain) NSString * tiemnotif;

@end
