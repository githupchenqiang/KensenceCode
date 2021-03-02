//
//  DecomeTable.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/4/6.
//  Copyright © 2016年 times. All rights reserved.
//

#import "DecomeTable.h"
#import "BaseViewController.h"
@interface DecomeTable ()
@property (nonatomic,strong)NSMutableArray *MutArray;


@end

@implementation DecomeTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _MutArray = [NSMutableArray arrayWithObjects:@"解码器1",@"解码器2",@"解码器3",@"解码器4",@"解码器5",@"解码器6",@"解码器7",@"解码器8",@"解码器9",@"解码器10", nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"decome"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _MutArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"decome" forIndexPath:indexPath];
    
    cell.textLabel.text = _MutArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BaseViewController *base = [BaseViewController new];
    NSString *Indext = [NSString stringWithFormat:@"解码器%ld",(long)indexPath.row+1];
    base.TextString = Indext;
    //注册通知
    NSDictionary *dict = @{@"Decome":Indext};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DecomeName" object:nil userInfo:dict];
    
    [self.view removeFromSuperview];
    
    
  
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
