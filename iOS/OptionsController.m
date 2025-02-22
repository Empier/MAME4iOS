/*
 * This file is part of MAME4iOS.
 *
 * Copyright (C) 2013 David Valdeita (Seleuco)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses>.
 *
 * Linking MAME4iOS statically or dynamically with other modules is
 * making a combined work based on MAME4iOS. Thus, the terms and
 * conditions of the GNU General Public License cover the whole
 * combination.
 *
 * In addition, as a special exception, the copyright holders of MAME4iOS
 * give you permission to combine MAME4iOS with free software programs
 * or libraries that are released under the GNU LGPL and with code included
 * in the standard release of MAME under the MAME License (or modified
 * versions of such code, with unchanged license). You may copy and
 * distribute such a system following the terms of the GNU GPL for MAME4iOS
 * and the licenses of the other code concerned, provided that you include
 * the source code of that other code when and as the GNU GPL requires
 * distribution of source code.
 *
 * Note that people who make modified versions of MAME4iOS are not
 * obligated to grant this special exception for their modified versions; it
 * is their choice whether to do so. The GNU General Public License
 * gives permission to release a modified version without this exception;
 * this exception also makes it possible to release a modified version
 * which carries forward this exception.
 *
 * MAME4iOS is dual-licensed: Alternatively, you can license MAME4iOS
 * under a MAME license, as set out in http://mamedev.org/
 */

#include "myosd.h"

#import "Options.h"
#import "OptionsController.h"
#import "Globals.h"
#import "ListOptionController.h"
#import "InputOptionController.h"
#import "HelpController.h"
#import "EmulatorController.h"
#import "SystemImage.h"
#import "ImageCache.h"
#import "CloudSync.h"
#import "Alert.h"

@implementation OptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", @"");
    
    UILabel* pad = [[UILabel alloc] init];
    pad.text = @" ";
    
    UIImageView* logo = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"mame_logo"] scaledToSize:CGSizeMake(300, 0)]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* info = [[UILabel alloc] init];
    info.text = [self.applicationVersionInfo stringByAppendingString:@"\n"];
    info.textAlignment = NSTextAlignmentCenter;
    info.numberOfLines = 0;
    
    UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews:@[pad, logo, info]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionEqualSpacing;
    
    [stack setNeedsLayout]; [stack layoutIfNeeded];
    CGFloat height = [stack systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    stack.frame =  CGRectMake(0, 0, self.view.bounds.size.width, height);
     
    self.tableView.tableHeaderView = stack;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
   cell.accessoryType = UITableViewCellAccessoryNone;
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
   Options *op = [[Options alloc] init];
    
   switch (indexPath.section)
   {
           
       case kSupportSection:
       {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"Help";
                   cell.imageView.image = [UIImage systemImageNamed:@"questionmark.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"What's New";
                   cell.imageView.image = [UIImage systemImageNamed:@"info.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
           }
           break;
       }
        case kVideoSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Filter";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayFilter optionName:op.filter];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text   = @"Skin";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arraySkin optionName:op.skin];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"Screen Shader";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayScreenShader optionName:op.screenShader];
                    break;
                }
                case 3:
                {
                    cell.textLabel.text   = @"Vector Shader";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [Options.arrayLineShader optionName:op.lineShader];
                    break;
                }
               case 4:
               {
                    cell.textLabel.text   = @"Keep Aspect Ratio";
                    cell.accessoryView = [self optionSwitchForKey:@"keepAspectRatio"];
                   break;
               }
               case 5:
               {
                   cell.textLabel.text   = @"Force Integer Scaling";
                   cell.accessoryView = [self optionSwitchForKey:@"integerScalingOnly"];
                   break;
               }
               case 6:
               {
                   cell.textLabel.text   = @"Force Pixel Aspect";
                   cell.accessoryView = [self optionSwitchForKey:@"forcepxa"];
                   break;
               }
            }
            break;
        }
       case kVectorSection:
       {
           switch (indexPath.row)
           {
               case 0:
                {
                    cell.textLabel.text = @"Beam 2x";
                    cell.accessoryView = [self optionSwitchForKey:@"vbean2x"];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"Flicker";
                    cell.accessoryView = [self optionSwitchForKey:@"vflicker"];
                    break;
                }
           }
           break;
       }
       case kFullscreenSection:
        {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"Fullscreen (Portrait)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenPortrait"];
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"Fullscreen (Landscape)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenLandscape"];
                   break;
               }
               case 2:
               {
                   cell.textLabel.text   = @"Fullscreen (Controller)";
                   cell.accessoryView = [self optionSwitchForKey:@"fullscreenJoystick"];
                   break;
               }
           }
           break;
        }
           
        case kMiscSection:  //Miscellaneous
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    cell.textLabel.text   = @"Show FPS";
                    cell.accessoryView = [self optionSwitchForKey:@"showFPS"];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text   = @"Show HUD";
                    cell.accessoryView = [self optionSwitchForKey:@"showHUD"];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text   = @"Show Info/Warnings";
                    cell.accessoryView = [self optionSwitchForKey:@"showINFO"];
                    break;
                }
                case 3:
                {
                     cell.textLabel.text = @"Cheats";
                     cell.accessoryView = [self optionSwitchForKey:@"cheats"];
                     break;
                }
                case 4:
                {
                     cell.textLabel.text   = @"Save Hiscores";
                     cell.accessoryView = [self optionSwitchForKey:@"hiscore"];
                     break;
                }
                case 5:
                {
                     cell.textLabel.text   = @"Emulated Speed";
                     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                     cell.detailTextLabel.text = [Options.arrayEmuSpeed optionAtIndex:op.emuspeed];
                     break;
                }
            }
            break;   
        }
       case kFilterSection:
       {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text   = @"Hide Clones";
                   cell.accessoryView = [self optionSwitchForKey:@"filterClones"];
                   break;
               }
               case 1:
               {
                   cell.textLabel.text   = @"Hide Not Working";
                   cell.accessoryView = [self optionSwitchForKey:@"filterNotWorking"];
                   break;
               }
           }
           break;
        }
        case kOtherSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Game Input";
                    cell.imageView.image = [UIImage systemImageNamed:@"gamecontroller"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
            }
            break;
        }
        case kImportSection:
        {
           switch (indexPath.row)
           {
               case 0:
               {
                   cell.textLabel.text = @"Import";
                   cell.imageView.image = [UIImage systemImageNamed:@"square.and.arrow.down.on.square"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 1:
               {
                   cell.textLabel.text = @"Export";
                   cell.imageView.image = [UIImage systemImageNamed:@"square.and.arrow.up.on.square"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
               case 2:
               {
                   cell.textLabel.text = @"Start Web Server";
                   cell.imageView.image = [UIImage systemImageNamed:@"arrow.up.arrow.down.circle"];
                   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                   break;
               }
           }
           break;
        }
        case kCloudImportSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Export to iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"icloud.and.arrow.up"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"Import from iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"icloud.and.arrow.down"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"Sync with iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"arrow.clockwise.icloud"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"Erase iCloud";
                    cell.imageView.image = [UIImage systemImageNamed:@"xmark.icloud"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
            }
            break;
        }
        case kResetSection:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

                    cell.textLabel.text = @"Reset to Defaults";
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.textLabel.shadowColor = [UIColor blackColor];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:24.0];
                    cell.backgroundColor = [UIColor systemRedColor];
                    break;
                }
            }
            break;
         }

   }

   return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
      return kNumSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		
    switch (section)
    {
        case kSupportSection: return nil;
        case kFullscreenSection: return @"Fullscreen";
        case kVideoSection: return @"Video Options";
        case kVectorSection: return @"Vector Options";
        case kMiscSection: return @"Options";
        case kFilterSection: return @"Game Filter";
        case kOtherSection: return @""; // @"Other";
        case kImportSection: return @"Import and Export";
        case kCloudImportSection: return @"iCloud";
        case kResetSection: return @"";
    }
    return @"Error!";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
      switch (section)
      {
          case kSupportSection: return 2;
          case kFullscreenSection: return 3;
          case kOtherSection: return 1;
          case kVideoSection: return 7;
          case kVectorSection: return 2;
          case kMiscSection: return 6;
          case kFilterSection: return 2;
          case kImportSection: return 3;
          case kCloudImportSection:
              if (CloudSync.status == CloudSyncStatusAvailable)
                  return 4;
              else if (CloudSync.status == CloudSyncStatusEmpty)
                  return 1;
              else
                  return 0;
          case kResetSection: return 1;
      }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (section)
    {
        case kSupportSection:
        {
            if (row==0){
                HelpController *controller = [[HelpController alloc] init];
                [[self navigationController] pushViewController:controller animated:YES];
            }
            if (row==1){
                HelpController *controller = [[HelpController alloc] initWithName:@"WHATSNEW.html" title:@"What's New"];
                [[self navigationController] pushViewController:controller animated:YES];
            }
            break;
        }
        case kOtherSection:
        {
            if (row==0){
                InputOptionController *inputOptController = [[InputOptionController alloc] initWithEmuController:self.emuController];
                [[self navigationController] pushViewController:inputOptController animated:YES];
                [tableView reloadData];
            }
            break;
        }
        case kVideoSection:
        {
            if (row==0){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"filter" list:Options.arrayFilter title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==1){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"skin" list:Options.arraySkin title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==2){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"screenShader" list:Options.arrayScreenShader title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            if (row==3){
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"lineShader" list:Options.arrayLineShader title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            break;
        }
        case kMiscSection:
        {
            if (row==5) {
                ListOptionController *listController = [[ListOptionController alloc] initWithKey:@"emuspeed" list:Options.arrayEmuSpeed title:cell.textLabel.text];
                [[self navigationController] pushViewController:listController animated:YES];
            }
            break;
        }
        case kImportSection:
        {
            if (row==0) {
                [self.emuController runImport];
            }
            if (row==1) {
                [self.emuController runExport];
            }
            if (row==2) {
                [self.emuController runServer];
            }
            break;
        }
        case kCloudImportSection:
        {
            if (row==0) {
                [CloudSync export];
            }
            if (row==1) {
                [CloudSync import];
            }
            if (row==2) {
                [CloudSync sync];
            }
            if (row==3) {
                [self showAlertWithTitle:@"Erase iCloud?" message:nil buttons:@[@"Erase", @"Cancel"] handler:^(NSUInteger button) {
                    if (button == 0)
                        [CloudSync delete];
                }];
            }
            break;
        }
        case kResetSection:
        {
            if (row==0) {
                [self.emuController runReset];
            }
            break;
        }
    }
}

@end
