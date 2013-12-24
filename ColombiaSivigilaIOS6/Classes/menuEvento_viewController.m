//
//  menuEvento_viewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "menuEvento_viewController.h"
#import "generalidades_ViewController.h"
#import "completo_ViewController.h"
#import "apoyoDiag_ViewController.h"
#import "accionesControl_ViewController.h"
#import "diagDiferencial_ViewController.h"
#import "FiltroEvento.h"

@interface menuEvento_viewController ()

@end

@implementation menuEvento_viewController
@synthesize eventoSeleccionado, t_nomEvento;

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
    t_nomEvento.text = eventoSeleccionado.nomeven;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"verGeneralidadesSegue"]) {
        
        generalidades_ViewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
    }
    if ([segue.identifier isEqualToString:@"accControlSegue"]) {
        
        accionesControl_ViewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
    }
    if ([segue.identifier isEqualToString:@"apoyoDiagSegue"]) {
        
        apoyoDiag_ViewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
    }
    if ([segue.identifier isEqualToString:@"diagDiferencialSegue"]) {
        
        diagDiferencial_ViewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
    }
    if ([segue.identifier isEqualToString:@"infCompletaSegue"]) {
        
        completo_ViewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
    }
}

@end
