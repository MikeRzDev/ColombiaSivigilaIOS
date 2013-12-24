//
//  busqRapidaPalabrasClav_ViewController.h
//  VigiaTuSalud
//
//  Created by Mike on 11/23/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface busqRapidaPalabrasClav_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textv_nombreGenSiv;
@property (weak, nonatomic) IBOutlet UITextView *txt_descripcion;
@property (weak, nonatomic) IBOutlet UILabel *lbl_significado;

@property (weak, nonatomic) IBOutlet UITableView *tablev_respBusq;

@end
