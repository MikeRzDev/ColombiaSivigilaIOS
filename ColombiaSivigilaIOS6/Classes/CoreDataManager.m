//
//  CoreDataManager.m
//  VigiaTuSalud
//
//  Created by Mike on 11/14/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//  CoreDataManager Created by Natasha Murashev on 6/7/13. URL= http://natashatherobot.com/ios-core-data-singleton-example/
//

#import "CoreDataManager.h"
#import "Constants.h"
#import "EventoSalud.h"
#import "FiltroEvento.h"
#import "DirectorioEntidades.h"
#import "GeneralidadesSivigila.h"
#import "FiltroGenSiv.h"



@interface CoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSArray *listaEventos;

- (void)setupManagedObjectContext;


@end

@implementation CoreDataManager

@synthesize listaEventos;

static CoreDataManager *coreDataManager;

+ (CoreDataManager *)sharedManager
{
    if (!coreDataManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            coreDataManager = [[CoreDataManager alloc] init];
        });
        
    }
    
    return coreDataManager;
}

#pragma mark - setup

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setupManagedObjectContext];
    }
    
    return self;
}

- (void)setupManagedObjectContext
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    //LA DATA DEBE IR EN CACHE JAMAS EN DOCUMENTS! APPSTORE REJECTS!
    NSURL *documentDirectoryURL = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask][0];
    
    NSURL *persistentURL = [documentDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", sProjectName]];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:sProjectName withExtension:@"momd"];
    
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    NSPersistentStore *persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                       configuration:nil
                                                                                                 URL:persistentURL
                                                                                             options:nil
                                                                                               error:&error];
    if (persistentStore) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    } else {
        NSLog(@"ERROR: %@", error.description);
    }
}



- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock
{
    NSError *saveError = nil;
    savedBlock([self.managedObjectContext save:&saveError], saveError);
}

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate

{
    NSFetchedResultsController *fetchedResultsController;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:className
                                              inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:sectionNameKeypath
                                                                              cacheName:nil];
    
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        NSLog(@"fetchManagedObjectsWithClassName ERROR: %@", error.description);
    }
    
    return fetchedResultsController;
}

- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary
{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:className
                                                            inManagedObjectContext:self.managedObjectContext];
    [attributesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        [entity setValue:obj forKey:key];
        
    }];
    
    return entity;
}




- (void)deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
                                                                            sortDescriptors:sortDescriptors
                                                                         sectionNameKeyPath:nil
                                                                                  predicate:predicate];
    
    return fetchedResultsController.fetchedObjects.count == 0;
}


/**************************************************************
 *     __  __ _       __  __      _            _              *
 *    |  \/  (_)___  |  \/  | ___| |_ ___   __| | ___  ___    *
 *    | |\/| | / __| | |\/| |/ _ \ __/ _ \ / _` |/ _ \/ __|   *
 *    | |  | | \__ \ | |  | |  __/ || (_) | (_| | (_) \__ \   *
 *    |_|  |_|_|___/ |_|  |_|\___|\__\___/ \__,_|\___/|___/   *
 *                                                            *
 **************************************************************/

-(void)updateDB_GeneralidadesSivigilaFromWebJSON:(NSData *)rawHttpData error:(NSError **)error
{
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:[NSEntityDescription entityForName:@"GeneralidadesSivigila" inManagedObjectContext:self.managedObjectContext]];
    [allEntities setIncludesPropertyValues:NO];
    
    NSError * errore = nil;
    NSArray * entitiesList = [self.managedObjectContext executeFetchRequest:allEntities error:&errore];
    
    //error handling goes here
    for (NSManagedObject * item in entitiesList) {
        [self.managedObjectContext deleteObject:item];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
    [self loadDb_GeneralidadesSivigilaFromWebJSON:rawHttpData error:error];
}

- (void)loadDb_GeneralidadesSivigilaFromWebJSON:(NSData *)rawHttpData error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:rawHttpData options:0 error:&localError];
    if (localError != nil) {
        *error = localError;
    }
    
    NSArray *results = [parsedObject valueForKey:@"d"];
    NSLog(@"Count Generalidades %lu", (unsigned long)results.count);
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"GeneralidadesSivigila"
                                              inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *entityAttribs = [entityDescription propertiesByName];
    
    for (NSDictionary *jsonDataDic in results)
    {
        GeneralidadesSivigila *item =  [NSEntityDescription insertNewObjectForEntityForName:@"GeneralidadesSivigila"
                                                             inManagedObjectContext:self.managedObjectContext];
        
        
        for (NSString *key in jsonDataDic)
        {
            if ([entityAttribs objectForKey:key] != nil)
            {
                [item setValue:[jsonDataDic valueForKey:key] forKey:key];
            }
        }
        
    }
    
    NSError *errorr;
    if (![self.managedObjectContext save:&errorr]) {
        NSLog(@"Whoops, couldn't save: %@", [errorr localizedDescription]);
    }
}

-(void)updateDB_EventoSaludFromWebJSON:(NSData *)rawHttpData error:(NSError **)error
{
    NSFetchRequest * allEntities = [[NSFetchRequest alloc] init];
    [allEntities setEntity:[NSEntityDescription entityForName:@"EventoSalud" inManagedObjectContext:self.managedObjectContext]];
    [allEntities setIncludesPropertyValues:NO];
    
    NSError * errore = nil;
    NSArray * listaEventoSalud = [self.managedObjectContext executeFetchRequest:allEntities error:&errore];

    //error handling goes here
    for (NSManagedObject * evento in listaEventoSalud) {
        [self.managedObjectContext deleteObject:evento];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];

    [self loadDb_EventoSaludFromWebJSON:rawHttpData error:error];
}

- (void)loadDb_EventoSaludFromWebJSON:(NSData *)rawHttpData error:(NSError **)error
{
   
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:rawHttpData options:0 error:&localError];
    if (localError != nil) {
        *error = localError;
    }

    NSArray *results = [parsedObject valueForKey:@"d"];
    NSLog(@"Count Eventos %lu", (unsigned long)results.count);
    
    NSEntityDescription *eventoSaludEntity = [NSEntityDescription
                                   entityForName:@"EventoSalud"
                                   inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *atributosEntidad = [eventoSaludEntity propertiesByName];

    for (NSDictionary *eventosDic in results)
    {
        EventoSalud *evento =  [NSEntityDescription insertNewObjectForEntityForName:@"EventoSalud"
                                                             inManagedObjectContext:self.managedObjectContext];
      
        
        for (NSString *key in eventosDic)
        {
            if ([atributosEntidad objectForKey:key] != nil)
            {
                [evento setValue:[eventosDic valueForKey:key] forKey:key];
            }
        }
        
    }
    
    NSError *errorr;
    if (![self.managedObjectContext save:&errorr]) {
        NSLog(@"Whoops, couldn't save: %@", [errorr localizedDescription]);
    }
    
    
    
}

- (void)loadDb_DirectorioEntidadesFromFileJSON
{
    [[self loadFileJson_DirectorioEntidades] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DirectorioEntidades *nuevoContacto = [NSEntityDescription insertNewObjectForEntityForName:@"DirectorioEntidades"
                                                                           inManagedObjectContext:self.managedObjectContext];
        NSEntityDescription *directorioContactosEntity = [NSEntityDescription
                                                          entityForName:@"DirectorioEntidades"
                                                          inManagedObjectContext:self.managedObjectContext];
        
        NSDictionary *entityAttribs = [directorioContactosEntity propertiesByName];
        
        for (NSString *key in entityAttribs)
        {
            [nuevoContacto setValue:[obj objectForKey:key] forKey:key ];
        }
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
}



- (NSArray *)loadFileJson_EventoSalud
{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:FileNameJSON ofType:@"json"];
    NSArray* dataArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
    return dataArray;
    
}

- (NSArray *)loadFileJson_DirectorioEntidades
{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:DirectorioRegionalJSON ofType:@"json"];
    NSArray* dataArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
    return dataArray;
    
}



- (NSInteger) countEventoSaludEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventoSalud" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];

    return count;
}

- (NSInteger) countDirectorioEntidadesEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DirectorioEntidades" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
     NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    return count;
}

- (NSInteger) countListaGeneralidadesSivigilaEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GeneralidadesSivigila" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    return count;
}



- (void)testDB
{
    
    FiltroEvento *fe = [[FiltroEvento alloc]init];
    fe.nomsubgru=@"MATERNO PERINATAL";
    fe.nomgrup=@"TRANSMISIBLES";
    
    NSArray *fetchedObjects = [self getEntitiesWithCriteria:@"TraerPorSubgrupo" claseFiltro:fe];
    
    
    for (EventoSalud *data in fetchedObjects) {
        NSLog(@"nombre: %@", data.nomeven);
        NSLog(@"subgrupo: %@", data.nomsubgru);
    }
    
    NSLog(@"datos vector mahuunche: %@", [[fetchedObjects objectAtIndex:0] nomsubgru] );
}

- (NSArray *) getContactosDirectorioSegunDepartamento:(NSString *) locacion
{
    
    
    NSPredicate *predicate=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DirectorioEntidades" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    if (![locacion isEqualToString:@"Todos"])
    {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" departamento == '%@' ", locacion]];
        [fetchRequest setPredicate:predicate];

    }

   
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error! %@", error);
    }
    
    
    return fetchedObjects;

}

- (NSArray *) getEntitiesWithCriteria:(NSString *) filtro
                         claseFiltro:(FiltroEvento *) filtroEvento
{
    NSPredicate *predicate=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EventoSalud" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
   
    
   
    //@"campo LIKE[cd] '*busqueda*' " -> cd es case insesitve y tambien anti tildes y el * es wildcard para todo tipo
    
    
    if ([filtro isEqualToString:@"TraerPorGrupo"])
    {
        
       [fetchRequest setPropertiesToFetch:@[@"nomsubgru"]];
        
        [fetchRequest setReturnsDistinctResults:YES];
        [fetchRequest setResultType: NSDictionaryResultType];
        
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" nomgrup == '%@' ", filtroEvento.nomgrup]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"nomsubgru" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    else if ([filtro isEqualToString:@"TraerPorSubgrupo"])
    {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" nomgrup == '%@' AND nomsubgru == '%@' ", filtroEvento.nomgrup,filtroEvento.nomsubgru]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"nomeven" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    else if ([filtro isEqualToString:@"TraerPorSubgrupoBusqRapida"])
    {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" nomgrup == '%@' AND nomsubgru == '%@' AND nomeven LIKE[cd] '*%@*'", filtroEvento.nomgrup,filtroEvento.nomsubgru,filtroEvento.nomeven]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"nomeven" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    
    else if ([filtro isEqualToString:@"TraerPorNombreSolo"])
    {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" nomeven == '%@' ",filtroEvento.nomeven]];
    }
    
    else if ([filtro isEqualToString:@"TraerPorBusqRapida"])
    {
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" nomeven beginswith[cd] '%@' ",filtroEvento.nomeven]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"nomeven" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
    }
    
    
    
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (fetchedObjects == nil) {
        NSLog(@"Error! %@", error);
    }
    
    
    return fetchedObjects;
}

- (NSArray *) getGeneralidadesSivigilaWithCriteria:(NSString *) filtro
                          claseFiltro:(FiltroGenSiv *) filtroGenSiv
{
    NSPredicate *predicate=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GeneralidadesSivigila" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    
    
    //@"campo LIKE[cd] '*busqueda*' " -> cd es case insesitve y anti tildes respectivamente, el * es wildcard para todo caracter
    
    
    if ([filtro isEqualToString:@"TraerTemasPorDominio"])
    {
        
        [fetchRequest setPropertiesToFetch:@[@"tem"]];
        
        [fetchRequest setReturnsDistinctResults:YES];
        [fetchRequest setResultType: NSDictionaryResultType];
        
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" dominf == '%@' ", filtroGenSiv.dominf]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"tem" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
    }
    
    else if ([filtro isEqualToString:@"TraerSubtemasPorTema"])
    {
        [fetchRequest setPropertiesToFetch:@[@"subtem"]];
        [fetchRequest setResultType: NSDictionaryResultType];
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" dominf == '%@' AND tem == '%@' ", filtroGenSiv.dominf,filtroGenSiv.tem]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            
                                            initWithKey:@"subtem" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];

    }
    else if ([filtro isEqualToString:@"TraerDescripcionPorTema"])
    {
        [fetchRequest setPropertiesToFetch:@[@"descrip"]];
        [fetchRequest setResultType: NSDictionaryResultType];
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" dominf == '%@' AND tem == '%@' ", filtroGenSiv.dominf, filtroGenSiv.tem]];
       
        
    }
    else if ([filtro isEqualToString:@"TraerDescripcionPorSubtema"])
    {
        [fetchRequest setPropertiesToFetch:@[@"descrip"]];
        [fetchRequest setResultType: NSDictionaryResultType];
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" dominf == '%@' AND tem == '%@' AND subtem = '%@' ", filtroGenSiv.dominf, filtroGenSiv.tem,filtroGenSiv.subtem]];
        
        
    }
    else if ([filtro isEqualToString:@"busqRapidaPalabraClave"])
    {
       
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" dominf == '%@' AND subtem beginswith[cd] '%@' ", filtroGenSiv.dominf,filtroGenSiv.subtem]];
        
    }


    
    
    
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Error! %@", error);
    }
    
    
    return fetchedObjects;
}
@end
