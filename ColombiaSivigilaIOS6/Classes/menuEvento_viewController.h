//
//  menuEvento_viewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroEvento.h"

@interface menuEvento_viewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *t_nomEvento;
@property (strong, nonatomic) FiltroEvento *eventoSeleccionado;
@end
