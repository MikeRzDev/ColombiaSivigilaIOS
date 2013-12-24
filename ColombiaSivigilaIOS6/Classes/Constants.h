//
//  Constants.h
//  VigiaTuSalud
//
//  Created by Mike on 11/14/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *sProjectName = @"SaludVigilaDB";
//url recurso json a parsear
static NSString *UrlEventosSaludJSON = @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Ministerio_de_Salud/enosfinal?$format=json";
static NSString *UrlGeneralidadesSivigilaJSON = @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Ministerio_de_Salud/enosgeneralidades?$format=json";
static NSString *BadUrlTest = @"http://servicedatosabiertoscolombia.cloudapp.net/v1/Ministerio_de_Salud/enosfinal?$filter=json";
//direccion del recurso json a subir debe ir sin la extension
static NSString *FileNameJSON =@"dbSaludVigilaInicial";

static NSString *DirectorioRegionalJSON =@"dbDirectorioContactos";

