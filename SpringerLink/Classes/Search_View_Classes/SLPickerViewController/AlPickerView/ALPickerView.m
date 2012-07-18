//
//  ALPickerView.m
//
//  Created by Alex Leutgöb on 11.11.11.
//  Copyright 2011 alexleutgoeb.com. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ALPickerView.h"
#import "ALPickerViewCell.h"
#import "UILabelExtended.h"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation ALPickerView

@synthesize delegate = delegate_;
@synthesize allOptionTitle;


#pragma mark - NSObject stuff

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	return [self initWithFrame:CGRectMake(0, 0, 320, 216)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
	// Set fix width and height
	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, 216)])) {
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.allOptionTitle = NSLocalizedString(@"All", @"All option title");
    
    internalTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(10, -2, 300, 218) style:UITableViewStylePlain];
    internalTableView_.delegate = self;
    internalTableView_.dataSource = self;
    internalTableView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    internalTableView_.showsVerticalScrollIndicator = NO;
    internalTableView_.scrollsToTop = NO;
        internalTableView_.backgroundColor = [UIColor redColor];
    UIImage *backgroundImage = [[UIImage imageNamed:@"wheel_bg"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    internalTableView_.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self addSubview:internalTableView_];
    
    // Add shadow to wheel
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheel_shadow"]];
    shadow.frame = internalTableView_.frame;
    [self addSubview:shadow];
    
    // Add border images
    UIImageView *leftBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_left"]];
    leftBorder.frame = CGRectMake(0, 0, 15, 216);
    [self addSubview:leftBorder];
    UIImageView *rightBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_right"]];
    rightBorder.frame = CGRectMake(self.frame.size.width - 15, 0, 15, 216);
    [self addSubview:rightBorder];
        UIImageView *middleBorder = [[UIImageView alloc] initWithImage:
                                     [[UIImage imageNamed:@"frame_middle"] 
                                      stretchableImageWithLeftCapWidth:0 topCapHeight:10]];
    middleBorder.frame = CGRectMake(15, 0, self.frame.size.width - 30, 216);
    [self addSubview:middleBorder];
  }
  return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



#pragma mark - Custom methods

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadAllComponents {
  [internalTableView_ reloadData];
}


#pragma mark - UITableView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Add 4 additional rows for whitespace on top and bottom
  if (allOptionTitle)
    return [delegate_ numberOfRowsForPickerView:self] ? [delegate_ numberOfRowsForPickerView:self] + 5 : 0;
  else
    return [delegate_ numberOfRowsForPickerView:self] ? [delegate_ numberOfRowsForPickerView:self] + 4 : 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ALPVCell";
  
  ALPickerViewCell *cell = (ALPickerViewCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[ALPickerViewCell alloc] initWithReuseIdentifier:CellIdentifier];
  }
  
    cell.descriptionLabel.text = nil;
    cell.titleLabel.text = nil;
    cell.descriptionLabel.backgroundColor =  cell.titleLabel.backgroundColor = [UIColor clearColor];

    CGRect titleLabelFrame = cell.titleLabel.frame;
    titleLabelFrame.origin.x = 44;
    titleLabelFrame.size.width = cell.contentView.frame.size.width;
    cell.titleLabel.frame = titleLabelFrame;
    
  if (indexPath.row < 2 || indexPath.row >= ([delegate_ numberOfRowsForPickerView:self] + 2)) {
    // Whitespace cell
    cell.titleLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  else {
      
      int actualRow = indexPath.row - 2;
      cell.titleLabel.textColor = [UIColor blackColor];
      cell.titleLabel.text = [delegate_ pickerView:self TitleTextForRow:actualRow];
    
      [cell.titleLabel setHeightOfLabelWithMaxHeight:24];
      [cell.titleLabel setWidthOfLabel];
      
      cell.descriptionLabel.text = [delegate_ pickerView:self detailTextForRow:actualRow];
      cell.selectionState = [delegate_ pickerView:self selectionStateForRow:actualRow];
      
      [cell.descriptionLabel setHeightOfLabelWithMaxHeight:24];

      titleLabelFrame = cell.descriptionLabel.frame;
      titleLabelFrame.origin.x = cell.titleLabel.frame.origin.x + cell.titleLabel.frame.size.width + 1;
      cell.descriptionLabel.frame = titleLabelFrame;
      [cell.descriptionLabel setWidthOfLabel];

      cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
    NSLog(@"cell.titleLabel %@ \n\n %@", cell.titleLabel, cell.descriptionLabel);

  return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
  if (indexPath.row > 1 && indexPath.row < ([delegate_ numberOfRowsForPickerView:self] +  2)) {
    // Set selection state
    ALPickerViewCell *cell = (ALPickerViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    for (ALPickerViewCell *aCell in tableView.visibleCells) {
          
        aCell.selectionState = NO;
    }
      
      cell.selectionState = !cell.selectionState;

    // Inform delegate
    int actualRow = indexPath.row - 2;
    
    if (cell.selectionState != NO) {
      if ([self.delegate respondsToSelector:@selector(pickerView:didCheckRow:)])
        [delegate_ pickerView:self didCheckRow:actualRow];
    }
    else {
      if ([self.delegate respondsToSelector:@selector(pickerView:didUncheckRow:)])
        [delegate_ pickerView:self didUncheckRow:actualRow];
    }
    
    // Iterate visible cells and update them too
    
    // Scroll the cell cell to the middle of the tableview
    [tableView setContentOffset:CGPointMake(0, tableView.rowHeight * (indexPath.row - 2)) animated:YES];    
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ScrollView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
  int co = ((int)tableView.contentOffset.y % (int)tableView.rowHeight);
  if (co < tableView.rowHeight / 2)
    [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y - co) animated:YES];
  else
    [tableView setContentOffset:CGPointMake(0, tableView.contentOffset.y + (tableView.rowHeight - co)) animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UITableView *)scrollView willDecelerate:(BOOL)decelerate {
  if(decelerate)
    return;
  [self scrollViewDidEndDecelerating:scrollView];
}
*/
@end
