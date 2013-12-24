//
//  busquedaRapida_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "busquedaRapida_ViewController.h"
#import "FiltroEvento.h"
#import "CoreDataManager.h"
#import "menuEvento_viewController.h"
#import "multideviceAttribMeasures.h"


@interface busquedaRapida_ViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) FiltroEvento *eventoSeleccionado;
@property (strong, nonatomic) NSArray *ElementosNombre;

@end

@implementation busquedaRapida_ViewController
@synthesize ElementosNombre, tablev_listaEventos,eventoSeleccionado,textv_nombreEvento;
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
    
    [self textFieldSetup];
    
    tablev_listaEventos.backgroundColor = [UIColor clearColor];
    
    self.eventoSeleccionado = [[FiltroEvento alloc]init];
    
    ElementosNombre = [[NSArray alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) textFieldSetup
{
    textv_nombreEvento.delegate=self;
    textv_nombreEvento.backgroundColor = [UIColor colorWithRed:0.506 green:0.561 blue:0.596 alpha:0.6];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ElementosNombre count];
}




//delegado interno para comunicar el tableview con el datasource, el identificador de la celda hace referencia al nombre
//puesto a la tableviewcell puesta a la tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    //permite decolar las celdas viejas para poner nuevas y ahorrar espacio
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [[ElementosNombre objectAtIndex:indexPath.row] nomeven];
    
    //configuracion del texto de la celda
    cell.textLabel.text = [[ElementosNombre objectAtIndex:indexPath.row] nomeven];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:size];
    
    
        cell.selectionStyle= UITableViewCellSelectionStyleBlue;
    
    
    
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //hide the keyboard
    [textField resignFirstResponder];
    
    //return NO or YES, it doesn't matter
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // open an alert with just an OK button
    
    self.eventoSeleccionado.nomeven = textField.text;
    
    
    ElementosNombre = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorBusqRapida" claseFiltro:eventoSeleccionado];
    [tablev_listaEventos reloadData];
    
    
    
    
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.eventoSeleccionado.nomeven = [[ElementosNombre objectAtIndex:indexPath.row] nomeven];
}
 */



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"verEventoSegue"]) {
        
        NSIndexPath *path = [tablev_listaEventos indexPathForSelectedRow];
        
        //traer el indice de la celda seleccionado en tableview
        self.eventoSeleccionado.nomeven = [[ElementosNombre objectAtIndex:path.row] nomeven];
        
        menuEvento_viewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;
        
        
        
    }
}


//eliminar separadores en blanco
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


@end
