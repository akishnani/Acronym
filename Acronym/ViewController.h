//
//  ViewController.h
//  Acronym
//
//  Created by AMIT KISHNANI on 11/11/16.
//  Copyright © 2016 University of California at Santa Cruz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *acronymTF;
@property (weak, nonatomic) IBOutlet UIButton *lookUpBtn;
@property (weak, nonatomic) IBOutlet UITextView *definitionsTView;
- (IBAction)lookUpBtnClicked:(UIButton *)sender;

- (void) loadDefintions:(NSString*) sf;


@end

