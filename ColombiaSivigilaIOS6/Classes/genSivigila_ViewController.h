//
//  genSivigila_ViewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/18/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltroGenSiv.h"


@interface genSivigila_ViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) FiltroGenSiv *filtroGen;
@property (strong,nonatomic) NSString *tituloVista;
@property (weak, nonatomic) IBOutlet UITextView *textv_descripcion;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subtema;
@property (weak, nonatomic) IBOutlet UIWebView *webv_imgFlujoInf;


@end

