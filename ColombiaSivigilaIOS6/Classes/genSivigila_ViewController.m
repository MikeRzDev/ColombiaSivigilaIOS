//
//  genSivigila_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/18/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "genSivigila_ViewController.h"
#import "multideviceAttribMeasures.h"
#import "CoreDataManager.h"
#import "GeneralidadesSivigila.h"
#import "multideviceAttribMeasures.h"
#define TemaPicker 1
#define SubtemaPicker 2

@interface genSivigila_ViewController () <UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (nonatomic,strong) NSArray *temasDelDominio;
@property (nonatomic,strong) NSArray *subTemasDelTema;
@property (weak, nonatomic) IBOutlet UITextField *textv_tematica;
@property (weak, nonatomic) IBOutlet UITextField *textv_subtema;
@property (nonatomic,assign) NSInteger tematicaActiveRow;
@property (nonatomic,assign) NSInteger subtematicaActiveRow;
@property (nonatomic,strong) UIPickerView *pickerv_tematica;
@property (nonatomic,strong) UIPickerView *pickerv_subtema;


@end

@implementation UITextView (DisableCopyPaste)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end

@implementation genSivigila_ViewController
@synthesize filtroGen,temasDelDominio, subTemasDelTema,tituloVista,textv_descripcion,lbl_subtema,webv_imgFlujoInf,textv_subtema,textv_tematica,pickerv_subtema,pickerv_tematica,tematicaActiveRow,subtematicaActiveRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) initTextfields

{
     textv_subtema.delegate=self;
     textv_tematica.delegate=self;

    
    textv_tematica.backgroundColor = [UIColor colorWithRed:0.506 green:0.561 blue:0.596 alpha:0.6];
    textv_subtema.backgroundColor = [UIColor colorWithRed:0.506 green:0.561 blue:0.596 alpha:0.6];
    
    [textv_tematica setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textv_subtema setAutocorrectionType:UITextAutocorrectionTypeNo];
}





-(void) loadDatainPickerCombo: (NSInteger) row : (NSInteger) pickerID
{
    if (pickerID == TemaPicker)
    {
       
        textv_tematica.text = temasDelDominio[row][@"tem"];
        filtroGen.tem = temasDelDominio[row][@"tem"];
        subTemasDelTema = [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"TraerSubtemasPorTema" claseFiltro:filtroGen];
        filtroGen.subtem = subTemasDelTema[0][@"subtem"];
        if ([filtroGen.subtem isEqualToString: @""])
        {
            
            lbl_subtema.hidden = true;
            textv_subtema.hidden = true;
            NSArray *consultaDescripcion = [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"TraerDescripcionPorTema" claseFiltro:filtroGen];
            NSString *textoDescripcion = consultaDescripcion[0][@"descrip"];
            [self showDescripcionText:textoDescripcion];
        }
        else
        {
            subtematicaActiveRow=0;
            lbl_subtema.hidden = false;
            textv_subtema.hidden = false;
            textv_subtema.text = subTemasDelTema[0][@"subtem"];
            NSArray *consultaDescripcion = [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"TraerDescripcionPorSubtema" claseFiltro:filtroGen];
            NSString *textoDescripcion = consultaDescripcion[0][@"descrip"];
            [self showDescripcionText:textoDescripcion];

        }
    }
    else if (pickerID == SubtemaPicker)
    {
        lbl_subtema.hidden = false;
        textv_subtema.hidden = false;
        filtroGen.subtem = subTemasDelTema[row][@"subtem"];
        textv_subtema.text = subTemasDelTema[row][@"subtem"];
        NSArray *consultaDescripcion = [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"TraerDescripcionPorSubtema" claseFiltro:filtroGen];
        NSString *textoDescripcion = consultaDescripcion[0][@"descrip"];
        [self showDescripcionText:textoDescripcion];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    webv_imgFlujoInf.hidden=true;
   
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;
    [self initTextfields];
    tematicaActiveRow = subtematicaActiveRow = 0;
    temasDelDominio = [[CoreDataManager sharedManager] getGeneralidadesSivigilaWithCriteria:@"TraerTemasPorDominio" claseFiltro:filtroGen];
    [self loadDatainPickerCombo:0 :TemaPicker];
   




    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) showDescripcionText:(NSString *) descripcion
{
    textv_descripcion.hidden = false;
    NSArray *parrafos = @[
                          descripcion
                          ];
    NSArray *titulos = @[
                         @"Descripción"
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
    
    
    [self.textv_descripcion setAttributedText:textoModif];
    
    if ([filtroGen.tem isEqualToString: @"REPRESENTACIÓN GRÁFICA"])
    {
        textv_descripcion.hidden = true;
        NSString *fullURL = descripcion;
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        webv_imgFlujoInf.hidden=false;
        [webv_imgFlujoInf loadRequest:requestObj];
        
        
        
    }
    else
    {
        webv_imgFlujoInf.hidden=true;
    }
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}


- (IBAction)showTemaPickerSheet:(id)sender {
    pickerv_tematica = [[UIPickerView alloc] init];
    pickerv_tematica.showsSelectionIndicator = YES;
    pickerv_tematica.dataSource = self;
    pickerv_tematica.delegate = self;
    pickerv_tematica.tag=TemaPicker;
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
     doneButton.tag=TemaPicker;
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //custom input view
    textv_tematica.inputView = pickerv_tematica;
    textv_tematica.inputAccessoryView = toolbar;
    //selecciona la row activa
    if (tematicaActiveRow >0)
    {
        [pickerv_tematica selectRow:tematicaActiveRow inComponent:0 animated:YES];
    }
}

- (IBAction)showSubtemaPickerSheet:(id)sender {
    
    pickerv_subtema = [[UIPickerView alloc] init];
    pickerv_subtema.showsSelectionIndicator = YES;
    pickerv_subtema.dataSource = self;
    pickerv_subtema.delegate = self;
    pickerv_subtema.tag=SubtemaPicker;
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listo"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    doneButton.tag=SubtemaPicker;
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    //custom input view
    textv_subtema.inputView = pickerv_subtema;
    textv_subtema.inputAccessoryView = toolbar;
    //seleciiona la row activa
    if (subtematicaActiveRow >0)
    {
        [pickerv_subtema selectRow:subtematicaActiveRow inComponent:0 animated:YES];
    }
    
}



-(void)doneClicked:(id) sender
{
    if ([sender tag] == TemaPicker)
    [textv_tematica resignFirstResponder]; //hides the pickerView
    else if ([sender tag] == SubtemaPicker)
    [textv_subtema resignFirstResponder];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    NSInteger numeroCeldas=0;
    if (pickerView.tag == TemaPicker)
    numeroCeldas= [temasDelDominio count];
    else if (pickerView.tag == SubtemaPicker)
        numeroCeldas = [subTemasDelTema count];
    return numeroCeldas;
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSString *textoCelda=@"";
    if (pickerView.tag == TemaPicker)
         textoCelda= temasDelDominio[row][@"tem"];
     else if (pickerView.tag == SubtemaPicker)
         textoCelda= subTemasDelTema[row][@"subtem"];
    return textoCelda;
}
*/


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == TemaPicker)
    {
        [self loadDatainPickerCombo:row :TemaPicker];
        tematicaActiveRow = row;
        
    }
    else if (pickerView.tag == SubtemaPicker)
    {
        
        [self loadDatainPickerCombo:row :SubtemaPicker];
        subtematicaActiveRow = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    NSInteger size = [[multideviceAttribMeasures sharedMeasures] getSmallTextMeasures];
    UILabel *label= [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:size]];
    if (pickerView.tag == TemaPicker)
        label.text= temasDelDominio[row][@"tem"];
    else if (pickerView.tag == SubtemaPicker)
        label.text= subTemasDelTema[row][@"subtem"];

    
    return label;
}


//evitar cambiar el texto por teclado diferente del teclado software
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}




@end
