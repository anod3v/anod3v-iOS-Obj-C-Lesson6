//
//  TicketsViewController.m
//  avia-tickets
//
//  Created by Artur Igberdin on 08.03.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataManager.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) NSArray *tickets;

@end

@implementation TicketsViewController
//{
//    BOOL isFavorites;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isFavorites ? @"Favorites" : @"Tickets";
    self.navigationController.navigationBar.prefersLargeTitles = self.isFavorites;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self. isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.tickets = [[CoreDataManager sharedInstance] favorites];
        [self.tableView reloadData];
    }
}


#pragma mark - Public

- (instancetype)initFavoriteTicketsController {
    self = [self initWithTickets:@[]];
    self.isFavorites = YES;
    return self;
    
//    if (self) {
//        self.isFavorites = YES;
//        self.tickets = [NSArray new];
//        self.title = @"Избранное";
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
//    }
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        self.tickets = tickets;
        //self.title = @"Билеты";
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    
    if (self.isFavorites) {
          cell.favoriteTicket = self.tickets[indexPath.row];
      } else {
          cell.ticket = self.tickets[indexPath.row];
      }

    
    //ОШИБКА!!!
    //cell.ticket = self.tickets[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFavorites) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    Ticket *ticket = self.tickets[indexPath.row];
    
    UIAlertAction *favoriteAction;
    if ([[CoreDataManager sharedInstance] isFavorite: ticket]) {
        
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[CoreDataManager sharedInstance] removeFromFavorite:ticket];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[CoreDataManager sharedInstance] addToFavorite:ticket];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end
