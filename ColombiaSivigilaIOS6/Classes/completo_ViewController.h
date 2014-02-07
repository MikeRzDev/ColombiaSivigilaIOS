//
//  completo_ViewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/16/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroEvento.h"

@interface completo_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tituloEvento;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) FiltroEvento *eventoSeleccionado;
@end
