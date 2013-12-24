//
//  dirTelef_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/18/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "dirTelef_ViewController.h"
#import "DirectorioEntidades.h"
#import "CoreDataManager.h"
#import "multideviceAttribMeasures.h"

@interface dirTelef_ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) NSArray *dirEntidades;
@property (nonatomic,strong) DirectorioEntidades *contactoSeleccionado;
@end

@implementation dirTelef_ViewController
@synthesize dirEntidades,contactoSeleccionado,textView;

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
    
    dirEntidades = [[CoreDataManager sharedManager] getContactosDirectorioSegunDepartamento:@"Todos"];
    [self mostrarContactoinicial];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//metodo para implementar picker, especifica cuantas filas poseera el picker
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [dirEntidades count];
}

//metodo delegado interno que comunica el mutablearray con la vista del picker (lo llama el sistema automaticamente)
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    return [dirEntidades[row] departamento];
}


//metodo de definicion de la accion del picker
-(void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
        contactoSeleccionado =dirEntidades[row];
        [self llenarInfoContacto:contactoSeleccionado.departamento];
    
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    UILabel *label= [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:size]];
    [label setText:[dirEntidades[row] departamento]];
    
    return label;
}

-(void) mostrarContactoinicial
{
    contactoSeleccionado =dirEntidades[0];
    [self llenarInfoContacto:contactoSeleccionado.departamento];
}

-(void) llenarInfoContacto:(NSString *) departamento
{
    NSArray *parrafos = @[
                            contactoSeleccionado.ciudad,
                            contactoSeleccionado.entidad,
                            contactoSeleccionado.direccion,
                            contactoSeleccionado.email,
                            contactoSeleccionado.telefono
                          ];
    NSArray *titulos = @[
                         @"Ciudad",
                         @"Nombre de la Entidad",
                         @"Dirección",
                         @"Correo Electrónico",
                         @"Teléfono"
                         
                         ];
    
    
    
    NSMutableString *bufferTexto = [NSMutableString stringWithString:@""];
    
    
    for ( int i = 0; i < [titulos count]; i++)
    {
        if (![parrafos[i] isEqualToString: @""])
        {
            [bufferTexto appendString: titulos[i]];
            [bufferTexto appendString: @"\n"];
            [bufferTexto appendString: parrafos[i]];
            [bufferTexto appendString: @"\n\n"];
        }
    }
    
    
    
    
    NSString *textoEvento=[NSString stringWithString:bufferTexto];
    
    NSMutableAttributedString *textoModif = [self highlightTitlesInText:textoEvento titles:titulos];
    textoModif = [self justifyParagraphs:textoModif paragraphs:parrafos];
    
    
    [self.textView setAttributedText:textoModif];

}

-(NSMutableAttributedString *) highlightTitlesInText: (NSString *) initialText
                                              titles: (NSArray *) titles
{
    
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getBigTextMeasures];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:initialText];
    
    //NSRange me muestra la posicion de la primera concidencia de una palabra en un array asi como su longitud
    //NSMakeRange me permite crear un rango desde el inicio de la palabra hasta el fin
    
    for (NSString *word in titles)
    {
        NSRange range=[initialText rangeOfString:word];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithRed:0.439 green:0.745 blue:0.804 alpha:1]
                       range:NSMakeRange(range.location, range.length)];
        [string addAttribute:NSFontAttributeName
                       value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:size]
                       range:NSMakeRange(range.location, range.length)];
        
    }
    
    return string;
}

-(NSMutableAttributedString *) justifyParagraphs: (NSMutableAttributedString *) attribText
                                      paragraphs: (NSArray *) paragraphs
{
    NSMutableAttributedString * string = attribText;
    NSString *initialText = [attribText string];
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    for(NSString *pargraph in paragraphs)
    {
        
        if ([pargraph isEqualToString:@"" ]== false)
        {
            NSRange range=[initialText rangeOfString:pargraph];
            [string addAttribute:NSParagraphStyleAttributeName
                           value:paragraphStyle
                           range:NSMakeRange(range.location, range.length)];
            [string addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:NSMakeRange(range.location, range.length)];
            [string addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:size]
                           range:NSMakeRange(range.location, range.length)];
        }
    }
    
    return string;
    
}
    
    



@end
