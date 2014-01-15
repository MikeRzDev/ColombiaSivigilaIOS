//
//  sel_nomeven_viewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/4/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "sel_nom_even_viewController.h"
#import "CoreDataManager.h"
#import "EventoSalud.h"
#import "menuEvento_viewController.h"
#import "multideviceAttribMeasures.h"







@interface sel_nom_even_viewController () <UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *ElementosSubgrupo;
@property (nonatomic,strong) NSArray *ElementosNombre;


@end

@implementation sel_nom_even_viewController

@synthesize ElementosSubgrupo, ElementosNombre,eventoSeleccionado, t_nombreEvento,tv_listaEventos,
pck_listaSubgrupos;

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
    
    
    

    //LINEA NECESARIA PARA LOGRAR LA TRANSPARENCIA EN TableView
    tv_listaEventos.backgroundColor = [UIColor clearColor];
    
    
    [self textFieldSetup];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;

    ElementosSubgrupo = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorGrupo" claseFiltro:eventoSeleccionado];
    self.eventoSeleccionado.nomsubgru = ElementosSubgrupo[0] [@"nomsubgru"];
    ElementosNombre = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorSubgrupo" claseFiltro:eventoSeleccionado];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) textFieldSetup
{
    t_nombreEvento.delegate=self;
   // t_nombreEvento.backgroundColor = [UIColor colorWithRed:0.506 green:0.561 blue:0.596 alpha:0.6];

}

//metodos del picker

//metodo para implementar picker, devuelve cuantos campos de informacion suministrara el picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//metodo para implementar picker, especifica cuantas filas poseera el picker
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [ElementosSubgrupo count];
}

//metodo delegado interno que comunica el mutablearray con la vista del picker (lo llama el sistema automaticamente)
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    //esta notacion se emplea debido a que el tipo de dato retornado es un NSDictonary necesario para realizar el distinct en la busqueda
    return ElementosSubgrupo[row] [@"nomsubgru"];
}


//metodo de definicion de la accion del picker
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component{
    {
       
        self.eventoSeleccionado.nomsubgru=ElementosSubgrupo[row] [@"nomsubgru"];
        ElementosNombre = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorSubgrupo" claseFiltro:eventoSeleccionado];
        [tv_listaEventos reloadData];
    }

    
}


//metodos del tableview

//devuelve el numero de filas en el tableview
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
    
    //configuracion del background de la celda
    cell.contentView.backgroundColor = [UIColor colorWithRed:147/255.0f green:159/255.0f blue:194/255.0f alpha:0.3];
    cell.backgroundColor = [UIColor colorWithRed:147/255.0f green:159/255.0f blue:194/255.0f alpha:0.4];
    
    //configuracion del texto de la celda
    cell.textLabel.text = [[ElementosNombre objectAtIndex:indexPath.row] nomeven];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:size];
    cell.selectionStyle= UITableViewCellSelectionStyleBlue;
    
    
    return cell;
    }

//en caso de requerir otro color
/*
//cambia el color de la celda seleccionada, metodo para ios6, es necesario en el segue repintar la tabla
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor colorWithRed:0.239 green:0.271 blue:0.298 alpha:0.7]];
  
    
}
*/



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
    ElementosNombre = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorSubgrupoBusqRapida" claseFiltro:eventoSeleccionado];
    [tv_listaEventos reloadData];
    
   
    
}

//NO SE USA EN IOS6 POR BUG, es necesario referenciar con un outlet y usar prepareForSegue
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.eventoSeleccionado.nomeven = [[ElementosNombre objectAtIndex:indexPath.row] nomeven];
      NSLog(@"%@ en sel_nom er$$", self.eventoSeleccionado.nomeven);
}
*/

//eliminar separadores en blanco
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"verEventoSegue"]) {
        
        NSIndexPath *path = [tv_listaEventos indexPathForSelectedRow];
        
        //traer el indice de la celda seleccionado en tableview
        self.eventoSeleccionado.nomeven = [[ElementosNombre objectAtIndex:path.row] nomeven];

        
        menuEvento_viewController *destViewController = segue.destinationViewController;
        destViewController.eventoSeleccionado = self.eventoSeleccionado;

        
        
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
     NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    UILabel *label= [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    //[label setTextColor:[UIColor blueColor]];
    [label setFont:[UIFont boldSystemFontOfSize:size]];
    [label setText:ElementosSubgrupo[row] [@"nomsubgru"]];
    
    return label;
}





@end
