//
//  textoIinicial_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 12/6/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "textoIinicial_ViewController.h"
#import "multideviceAttribMeasures.h"
#import "textoInicialStrings.h"

@interface textoIinicial_ViewController ()

@end

@implementation textoIinicial_ViewController
@synthesize textView;

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
    
    [self configuracionDelTexto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) configuracionDelTexto
{
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    NSArray *titulos = @[
                         @"",
                         @"",
                         @"",
                         @"",
                         @"",
                         @""
                          ];
    NSArray *parrafos = @[
                         textoIntro,
                         @"",
                         texto0,
                         @"\n\n\n\n\n\n\n",
                         texto1,
                         @"\n\n\n\n\n\n\n\n\n\n\n"
                         ];
    
    
    
    NSMutableString *bufferTexto = [NSMutableString stringWithString:@""];
    for ( int i = 0; i < [titulos count]; i++)
    {
            [bufferTexto appendString: titulos[i]];
            [bufferTexto appendString: @"\n"];
            [bufferTexto appendString: parrafos[i]];
            [bufferTexto appendString: @"\n"];
    }
    
    
    NSString *textoEvento=[NSString stringWithString:bufferTexto];
    
    NSMutableAttributedString *textoModif = [self highlightTitlesInText:textoEvento titles:titulos];
    textoModif = [self justifyParagraphs:textoModif paragraphs:parrafos];
    
    
    [self.textView setAttributedText:textoModif];
    
    UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro1.png"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro2.png"]];
    
    
    //detectar dispostivo para poner imagen en uitextview
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
       imageView.frame = CGRectMake(180, 290, 320, 200);
       imageView2.frame = CGRectMake(150, 570, 399, 162);
    }
    else
    {
       imageView.frame = CGRectMake(20, 320, 220, 140);
       imageView2.frame = CGRectMake(10, 550, 260, 110);
    }
    
  
    //agregar imagen a uitextview
    [textView addSubview:imageView];
    [textView addSubview:imageView2];

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
                       value:[UIColor blueColor]
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
                           value:[UIColor blackColor]
                           range:NSMakeRange(range.location, range.length)];
            [string addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:size]
                           range:NSMakeRange(range.location, range.length)];
        }
    }
    
    return string;
    
}

@end
