//
//  sel_nomeven_viewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/4/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroEvento.h"

@interface sel_nom_even_viewController : UIViewController


@property (strong, nonatomic) IBOutlet UITableViewCell *tablecell;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) FiltroEvento *eventoSeleccionado;

@property (weak, nonatomic) IBOutlet UITextField *t_nombreEvento;

@property (weak, nonatomic) IBOutlet UITableView *tv_listaEventos;

@property (weak, nonatomic) IBOutlet UIPickerView *pck_listaSubgrupos;


@end
