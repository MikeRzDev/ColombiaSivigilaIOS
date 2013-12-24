//
//  generalidadesSivigila_viewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/23/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "generalidadesSivigila_viewController.h"
#import "genSivigila_ViewController.h"
#import "FiltroGenSiv.h"


@interface generalidadesSivigila_viewController ()

@end

@implementation generalidadesSivigila_viewController
@synthesize  btn_actYresp,btn_flujoinf,btn_generalidades,btn_palClave;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;
    [self configButtonsColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) configButtonsColor
{
    
    btn_generalidades.hue = (CGFloat)0.576389;
    btn_flujoinf.hue = (CGFloat)0.094907;
    btn_actYresp.hue = (CGFloat)0.293981;
    btn_palClave.hue = (CGFloat)0.965278;
    btn_palClave.brightness = btn_generalidades.brightness = btn_actYresp.brightness = btn_flujoinf.brightness = (CGFloat)0.641204;
    btn_palClave.saturation = btn_generalidades.saturation = btn_actYresp.saturation = btn_flujoinf.saturation = (CGFloat)1;
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    FiltroGenSiv *filtroGeneralidades = [FiltroGenSiv new];
    
    if ([segue.identifier isEqualToString:@"verGeneralidadesSegue"]) {
        
        genSivigila_ViewController *destViewController = segue.destinationViewController;
       
        [filtroGeneralidades setDominf:@"GENERALIDADES"];
        destViewController.filtroGen = filtroGeneralidades;
        destViewController.tituloVista=@"Generalidades";
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"actoresYrespSegue"]) {
        
        genSivigila_ViewController *destViewController = segue.destinationViewController;
        
        [filtroGeneralidades setDominf:@"ACTORES Y RESPONSABLES"];
        destViewController.filtroGen = filtroGeneralidades;
         destViewController.tituloVista=@"Actores y Responsables";
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"flujoControlSegue"]) {
        
        genSivigila_ViewController *destViewController = segue.destinationViewController;
        
        [filtroGeneralidades setDominf:@"FLUJO DE INFORMACIÓN"];
        destViewController.filtroGen = filtroGeneralidades;
         destViewController.tituloVista=@"Flujo de Informacion";
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"conceptosClaveSegue"]) {
        
        genSivigila_ViewController *destViewController = segue.destinationViewController;
        
        [filtroGeneralidades setDominf:@"CONCEPTOS CLAVES"];
        destViewController.filtroGen = filtroGeneralidades;
         destViewController.tituloVista=@"Conceptos Claves";
        
        
    }

    
    
    
}



@end
