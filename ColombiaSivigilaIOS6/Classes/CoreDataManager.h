//
//  CoreDataManager.h
//  VigiaTuSalud
//
//  Created by Mike on 11/14/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FiltroEvento.h"
#import "FiltroGenSiv.h"

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate;

- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary;
- (void)deleteEntity:(NSManagedObject *)entity;
- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue;


//mis metodos para cargar datos

- (NSArray *) getGeneralidadesSivigilaWithCriteria:(NSString *) filtro
                                       claseFiltro:(FiltroGenSiv *) filtroGenSiv;
- (void)loadDb_EventoSaludFromWebJSON:(NSData *)rawHttpData error:(NSError **)error;
- (void)loadDb_GeneralidadesSivigilaFromWebJSON:(NSData *)rawHttpData error:(NSError **)error;
- (void)loadDb_DirectorioEntidadesFromFileJSON;
- (NSInteger) countEventoSaludEntities;
- (NSInteger) countDirectorioEntidadesEntities;
- (NSInteger) countListaGeneralidadesSivigilaEntities;
- (void)testDB;
- (NSArray *) getContactosDirectorioSegunDepartamento:(NSString *) locacion;
- (NSArray *) getEntitiesWithCriteria:(NSString *) filtro
                          claseFiltro:(FiltroEvento *) filtroEvento;
-(void)updateDB_EventoSaludFromWebJSON:(NSData *)rawHttpData error:(NSError **)error;
-(void)updateDB_GeneralidadesSivigilaFromWebJSON:(NSData *)rawHttpData error:(NSError **)error;
@end
