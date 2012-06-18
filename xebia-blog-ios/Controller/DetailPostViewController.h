//
//  DetailViewController.h
//  StoryboardTutorial
//
//  Created by Kurry Tran on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Post.h"
#import <UIKit/UIKit.h>

@interface DetailPostViewController : UIViewController {

    Post *post;
    
    IBOutlet UITextField *titleTextField;
    IBOutlet UITextField *descriptionTextField;
}

@property (nonatomic, retain)Post *post;
@property (nonatomic, retain)IBOutlet UITextField *titleTextField, *descriptionTextField;

@end
