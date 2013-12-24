//
//  DirectorioEntidades.h
//  VigiaTuSalud
//
//  Created by Mike on 11/21/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DirectorioEntidades : NSManagedObject

@property (nonatomic, retain) NSString * departamento;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * telefono;
@property (nonatomic, retain) NSString * entidad;
@property (nonatomic, retain) NSString * ciudad;

@end
