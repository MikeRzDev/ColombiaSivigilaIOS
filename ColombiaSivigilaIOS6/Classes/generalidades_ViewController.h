//
//  generalidades_ViewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroEvento.h"



@interface generalidades_ViewController : UIViewController

@property (strong, nonatomic) FiltroEvento *eventoSeleccionado;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tituloEvento;

@end