//
//  busqRapidaPalabrasClav_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/23/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "busqRapidaPalabrasClav_ViewController.h"
#import "multideviceAttribMeasures.h"
#import "CoreDataManager.h"
#import "FiltroGenSiv.h"
#import "GeneralidadesSivigila.h"

@interface busqRapidaPalabrasClav_ViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) FiltroGenSiv *filtroGen;
@property (strong, nonatomic) NSArray *generalidadesArray;
@end

@implementation busqRapidaPalabrasClav_ViewController
@synthesize  textv_nombreGenSiv,generalidadesArray,filtroGen,tablev_respBusq,txt_descripcion,lbl_significado;

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
    
     tablev_respBusq.backgroundColor = [UIColor clearColor];
    txt_descripcion.hidden=true;
    filtroGen = [FiltroGenSiv new];
    generalidadesArray = [NSArray new];
    lbl_significado.hidden = true;
    
    
    [self textFieldSetup];
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
    textv_nombreGenSiv.delegate=self;
    textv_nombreGenSiv.backgroundColor = [UIColor colorWithRed:0.506 green:0.561 blue:0.596 alpha:0.6];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [generalidadesArray count];
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
    
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:147/255.0f green:159/255.0f blue:194/255.0f alpha:0.3];
    //configuracion del texto de la celda
    cell.textLabel.text = [[generalidadesArray objectAtIndex:indexPath.row] subtem];
    cell.textLabel.textColor = [UIColor blackColor];
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
    
    filtroGen.dominf = @"CONCEPTOS CLAVES";
    filtroGen.subtem = textField.text;
    
    
    generalidadesArray =  [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"busqRapidaPalabraClave" claseFiltro:filtroGen];
    

    [tablev_respBusq reloadData];
    
    
    
    
}

//cambia el color de la celda seleccionada, metodo para ios6, es necesario en el segue repintar la tabla


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [tableView reloadData];
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor colorWithRed:0.239 green:0.271 blue:0.298 alpha:0.7]];
*/
    txt_descripcion.hidden=false;
    lbl_significado.hidden = false;
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    txt_descripcion.text = [[generalidadesArray objectAtIndex:indexPath.row] descrip];
    [txt_descripcion setFont:[UIFont systemFontOfSize:size]];
}



//eliminar separadores en blanco
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

@end
