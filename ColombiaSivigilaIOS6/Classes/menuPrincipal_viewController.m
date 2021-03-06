//
//  menuPrincipal_viewController.m
//  VigiaTuSalud
//
//  Created by Mike on 11/15/13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#import "menuPrincipal_viewController.h"
#import "FiltroEvento.h"
#import "generalidades_ViewController.h"
#import "CoreDataManager.h"
#import "Constants.h"
#import "Reachability.h"



@interface menuPrincipal_viewController ()
@property (nonatomic,strong) UIAlertView *mensajeCarga;
@property (nonatomic,assign) NSInteger currentNetworkTasks;
@property (nonatomic,strong) NSString *badRepoNames;
@end

@implementation menuPrincipal_viewController
@synthesize mensajeCarga,currentNetworkTasks,badRepoNames;


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
    
    badRepoNames = @"";
    currentNetworkTasks = 0;
   [self createDb_IfNotExist];
   
   
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"txt_nombreAplicacion.png"]];
    imageView.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = imageView;

    
    
    
    
    
    //[self.navigationItem.backBarButtonItem setTitle:@"Atrás"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Atrás";
    self.navigationItem.backBarButtonItem = barButton;
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateDatabaseButtonOnClick:(id)sender
{
    [self updateDB_FromNetwork];
   }



-(void)createDb_IfNotExist
{
    
    if(![self isDataOnLocalDB])
    {
        if ([self detectDataNetworkState])
        {
            [[CoreDataManager sharedManager] loadDb_DirectorioEntidadesFromFileJSON];
            [self loadDB_FromJson];
        }
        else
        {
            [self showConnectionUnavailableAlert];
        }

    }

}


-(void) loadDB_FromJson
{
    [self showLoadingAlert];
    NSURL *url = [NSURL URLWithString:UrlEventosSaludJSON];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    currentNetworkTasks++;
    
    url = [NSURL URLWithString:UrlGeneralidadesSivigilaJSON];
    NSURLRequest *urlRequest2 = [NSURLRequest requestWithURL:url];
    currentNetworkTasks++;
    
    //no se pueden dejar nesteados porque ocaciona errores graves, hay que llamar a la UI antes del primer request y cerrarla en el ultimo
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
       
        Boolean responseErr = false;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] != 200)
        {
            responseErr=true;
            badRepoNames=[badRepoNames stringByAppendingString:@"enosfinal "];

        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSError *error;
            if(!responseErr)
            [[CoreDataManager sharedManager] loadDb_EventoSaludFromWebJSON:data error:&error];
            [self dismissAlertInFinalTask];
        });
        
    }];
    
    
    
    //no se pueden dejar nesteados porque ocaciona errores graves, hay que llamar a la UI antes del primer request y cerrarla en el ultimo
    [NSURLConnection sendAsynchronousRequest:urlRequest2 queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
       
        
        Boolean responseErr = false;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] != 200)
        {
            responseErr = true;
            badRepoNames=[badRepoNames stringByAppendingString:@"enosgeneralidades "];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
             NSError *error;
            if(!responseErr)
            [[CoreDataManager sharedManager] loadDb_GeneralidadesSivigilaFromWebJSON:data error:&error];
            [self dismissAlertInFinalTask];
        });
        
    }];
    
  
}

-(void)dismissAlertInFinalTask
{
    currentNetworkTasks--;
    if (currentNetworkTasks == 0)
    {
        [self dismissLoadingAlert];
        
        //codigo para debug
        /*        NSInteger dbEventosSaludCount = [[CoreDataManager sharedManager] countEventoSaludEntities];
        NSInteger dbDirectorioEntidadesCount = [[CoreDataManager sharedManager] countDirectorioEntidadesEntities];
        NSInteger dbGeneralidadesSivigilaCount = [[CoreDataManager sharedManager] countListaGeneralidadesSivigilaEntities];
         */
        UIAlertView *sucessMsg = [[UIAlertView alloc] initWithTitle:@"Informacion"
                                                            message:@"Éxito en la descarga de la información necesaria para la ejecución de esta aplicación"
                                  
                                                           delegate:self
                                                  cancelButtonTitle:@"Continuar"
                                                  otherButtonTitles:nil];
        
        [sucessMsg show];

        
        
        //codigo para debug fin
        
        if (![badRepoNames isEqualToString:@""]) {
            NSString * msj = [NSString stringWithFormat:@"Existe un error con el/los repositorio(s) de dato(s) '%@', por favor contacte a la entidad encargada.", badRepoNames];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:msj
                                                           delegate:self
                                                  cancelButtonTitle:@"Continuar"
                                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
        badRepoNames=@"";
        

    }
}




-(void) updateDB_FromNetwork
{
    
    if ([self detectDataNetworkState])
        
    {
        
        //Display alert view, before sending your request..
        [self showLoadingAlert];
        NSURL *url = [NSURL URLWithString:UrlEventosSaludJSON];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        currentNetworkTasks++;
        
        url = [NSURL URLWithString:UrlGeneralidadesSivigilaJSON];
        NSURLRequest *urlRequest2 = [NSURLRequest requestWithURL:url];
        currentNetworkTasks++;
        

        //no se pueden dejar nesteados porque ocaciona errores graves, hay que llamar a la UI antes del primer request y cerrarla en el ultimo
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            Boolean responseErr = false;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] != 200)
            {
                responseErr = true;
                badRepoNames=[badRepoNames stringByAppendingString:@"enosfinal "];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSError *error;
                if (responseErr==false)
                    [[CoreDataManager sharedManager] updateDB_EventoSaludFromWebJSON:data error:&error];
                [self dismissAlertInFinalTask];
            });
            
        }];
        
        
       
        //no se pueden dejar nesteados porque ocaciona errores graves, hay que llamar a la UI antes del primer request y cerrarla en el ultimo
        [NSURLConnection sendAsynchronousRequest:urlRequest2 queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            
            Boolean responseErr = false;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode] != 200)
            {
                responseErr = true;
                badRepoNames=[badRepoNames stringByAppendingString:@"enosgeneralidades "];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSError *error;
                if (!responseErr)
                    [[CoreDataManager sharedManager] updateDB_GeneralidadesSivigilaFromWebJSON:data error:&error];
                [self dismissAlertInFinalTask];
            });
            
        }];
        
    }
    else
    {
        [self showConnectionUnavailableAlert];
    }
}




//sobrecarga del metodo de lanzamiento de segues para validar si existe la base, pase a las interfaces de lo contrario no
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"enosSegue"])
    {
        if ([self isDataOnLocalDB])
            return YES;
        else
        {
            [self showNoDataAlert];
            return NO;
        }
    }
    else if ([identifier isEqualToString:@"generalidadesSegue"]) {
        
        if ([self isDataOnLocalDB])
            return YES;
        
        else
        {
            [self showNoDataAlert];
            return NO;
        }
    }
    
    return YES;
    
}


-(void) showLoadingAlert
{

   mensajeCarga = [[UIAlertView alloc] initWithTitle:@"Descargando información"
                                           message:@"Por favor espere unos segundos..."
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
    [mensajeCarga addSubview:spinner];
    [spinner startAnimating];
   
    
    [mensajeCarga show];
}

-(void) dismissLoadingAlert
{
    [mensajeCarga dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void) showConnectionUnavailableAlert
{
    
   UIAlertView *errorConn = [[UIAlertView alloc] initWithTitle:@"No hay conexión a internet disponible"
                                              message:@"Por favor encienda la conectividad de su dispositivo a internet WiFi/Plan de Datos, para descargar la información necesaria para el uso de este aplicativo."
                                             delegate:self
                                    cancelButtonTitle:@"Continuar"
                                    otherButtonTitles:nil];
    
    [errorConn show];
}

-(void) showNoDataAlert

{
    UIAlertView *errorConn = [[UIAlertView alloc] initWithTitle:@"No hay datos en la base de datos local"
                                                        message:@"Por favor toque el botón de actualizar/refrescar en la parte superior derecha para descargar la información."
                                                       delegate:self
                                              cancelButtonTitle:@"Continuar"
                                              otherButtonTitles:nil];
    
    [errorConn show];
}

-(Boolean) isDataOnLocalDB
{
    NSInteger dbEventosSaludCount = [[CoreDataManager sharedManager] countEventoSaludEntities];
    NSInteger dbDirectorioEntidadesCount = [[CoreDataManager sharedManager] countDirectorioEntidadesEntities];
    NSInteger dbGeneralidadesSivigilaCount = [[CoreDataManager sharedManager] countListaGeneralidadesSivigilaEntities];
    
    if (dbEventosSaludCount == 0 || dbDirectorioEntidadesCount == 0 || dbGeneralidadesSivigilaCount == 0)
    {
        return false;
        
    }
    
    return true;

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




@end
