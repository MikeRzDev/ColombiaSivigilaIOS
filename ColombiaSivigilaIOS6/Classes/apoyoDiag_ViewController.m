//
//  apoyoDiag_ViewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "apoyoDiag_ViewController.h"
#import "FiltroEvento.h"
#import "EventoSalud.h"
#import "CoreDataManager.h"
#import "multideviceAttribMeasures.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Reachability.h"

@interface apoyoDiag_ViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) EventoSalud *eventoSalud;
@end

@implementation apoyoDiag_ViewController
@synthesize eventoSeleccionado,eventoSalud,textView,tituloEvento;

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
    [self configuracionDelTexto];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonOnClick:(id)sender {
    
    if ([self detectDataNetworkState])
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartir"
                                                    message:@"Selecciona una medio para compartir esta información"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"E-mail",@"Facebook",@"Twitter"
                          , nil];
	[alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Para hacer uso de esta funcionalidad por favor encienda la conectividad de su dispositivo a internet (Wifi/Plan de Datos)"
                                                       delegate:self
                                              cancelButtonTitle:@"Continuar"
                                              otherButtonTitles:nil
                              , nil];
        [alert show];
    }
    
    
}

-(Boolean) detectDataNetworkState
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    
    
    if(status == NotReachable)
    {
        return false;
    }
    
    
    else if (status == ReachableViaWiFi)
    {
        NSLog(@" si hay wifi");
    }
    else if (status == ReachableViaWWAN)
    {
        NSLog(@" si hay plan de datos");
    }

    return  true;
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            if ([mailClass canSendMail])
            {
                // Email Subject
                NSString *emailTitle = [NSString stringWithFormat:@"Información Evento de Vigilancia de Salud Publica en Colombia: %@", eventoSalud.nomeven];
                // Email Content
                NSString *messageBody = textView.text;
                // To address
                NSArray *toRecipents = [NSArray arrayWithObject:@""];
                
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                [[mc navigationBar] setTintColor:[UIColor blueColor]];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                                message:@"Es necesario configurar el modulo de correo en el menú Ajustes de tu dispositivo iOS"
                                                               delegate:self
                                                      cancelButtonTitle:@"Aceptar"
                                                      otherButtonTitles:nil
                                      ];
                [alert show];
            }
        }
        
        
        
    }
    else if(buttonIndex == 2)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:[NSString stringWithFormat:@"Evento de Vigilancia de Salud Publica en Colombia: %@\n%@", eventoSalud.nomeven,textView.text]];
            
            [controller addURL:[NSURL URLWithString:@"http://www.ins.gov.co/lineas-de-accion/Subdireccion-Vigilancia/sivigila/Paginas/sivigila.aspx"]];
            [controller addImage:[UIImage imageNamed:@"socialsharing-facebook-image.jpg"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                            message:@"Es necesario configurar el modulo de Facebook en el menú Ajustes de tu dispositivo iOS"
                                                           delegate:self
                                                  cancelButtonTitle:@"Aceptar"
                                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
        
    }
    else if(buttonIndex == 3)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [controller setInitialText:[NSString stringWithFormat:@"Evento de Salud Publica en Colombia: '%@', enviado desde Colombia Sivigila App", eventoSalud.nomeven]];
            [controller addURL:[NSURL URLWithString:eventoSalud.linkurl]];
            [controller addImage:[UIImage imageNamed:@"socialsharing-facebook-image.jpg"]];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                            message:@"Para poder usar esta funcionalidad es necesario configurar el modulo de Twitter en el menú Ajustes de tu dispositivo iOS"
                                                           delegate:self
                                                  cancelButtonTitle:@"Aceptar"
                                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
        
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                            message:@"La información ha sido enviada con exito!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Aceptar"
                                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mensaje"
                                                            message:@"La información no pudo ser enviada"
                                                           delegate:self
                                                  cancelButtonTitle:@"Aceptar"
                                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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



-(void) configuracionDelTexto
{
    
	
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.textAlignment = NSTextAlignmentLeft;
    
    eventoSalud = [[CoreDataManager sharedManager] getEntitiesWithCriteria:@"TraerPorNombreSolo" claseFiltro:eventoSeleccionado][0];
    
    NSArray *parrafos = @[
                          eventoSalud.apolab,
                          eventoSalud.otrapoyo
                          ];
    NSArray *titulos = @[
                         @"Apoyo de Laboratorio",
                         @"Otro Apoyo",
                             ];
    
    
    tituloEvento.text = eventoSalud.nomeven;
    
    NSMutableString *bufferTexto = [NSMutableString stringWithString:@""];
    
    
    for ( int i = 0; i < [titulos count]; i++)
    {
        if (![parrafos[i] isEqualToString: @""] && ![parrafos[i] isEqualToString: @"DILIGENCIAR"])
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



@end
