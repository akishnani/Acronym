//
//  ViewController.m
//  Acronym
//
//  Created by AMIT KISHNANI on 11/11/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lookUpBtnClicked:(UIButton *)sender {

    [self loadDefintions:_acronymTF.text];
}

- (void) loadDefintions:(NSString*) sf {
    
    //check if the user has entered something in acronym field.
    if (sf.length > 0) {
        
        //clear the text view
        self.definitionsTView.text = @"";
        
        //install the progress HUD
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //put this on background thread with block with low priority
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSString* urlWithParams = [NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@", sf];
            
            //set the content type and HTTPMethod
            NSURL *url = [NSURL URLWithString:urlWithParams];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"GET";
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            //response serializer
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
          
            //data request
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                    self.definitionsTView.text = [NSString stringWithFormat:@"Error: %@", error.localizedDescription];
                    self.definitionsTView.textColor = [UIColor redColor];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                } else {
                    //NSLog(@"%@ %@", response, responseObject);
                    NSMutableString *definitionsText = [[NSMutableString alloc]init];

                    //converting the json response to NSArray and NSDictionary
                    NSArray* array = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    
                    //check if data is returned
                    if (array.count > 0) {
                        NSDictionary* dict = [array objectAtIndex:0];
                        
                        //long forms
                        NSArray* lfs = dict[@"lfs"];
                        
                        for (NSDictionary *alf in lfs) {
                            
                            NSString *lfsString = [NSString stringWithFormat:@"%@,freq: %@,since: %@\r\n",
                                                   alf[@"lf"], alf[@"freq"], alf[@"since"]];
                            [definitionsText appendString:lfsString];
                        
                            //vars
                            NSArray *aVarArray = alf[@"vars"];
                            for(NSDictionary *aVarlf in aVarArray){
                                NSString *lfsString = [NSString stringWithFormat:@"%@,freq: %@,since: %@\r\n",
                                                      aVarlf[@"lf"], aVarlf[@"freq"], aVarlf[@"since"]];
                                [definitionsText appendString:lfsString];
                            }
                        }
                        self.definitionsTView.textColor = [UIColor blackColor];
                        self.definitionsTView.text = definitionsText;
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
            [dataTask resume];
        });
    }
}

@end
