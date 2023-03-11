//
//  ProductListViewController.swift
//  DummyProducts
//
//  Created by Rehnuma Reza on 3/3/23.
//

import UIKit

class ProductsListViewController: UIViewController {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil),
                           forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                           forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()

    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor = .red

        return activityIndicator
    }()

    var products = [ProductModel]()
    var productImageURLS = [String]()
    var productImages = [String : UIImage]()
    
    var users = [UserModel]()
    var userImageURLS = [String]()
    var userImages = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Products"
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        tableView.delegate = self
        tableView.dataSource = self

        addTableViewConstraints()
        addActivityIndicatorConstraints()

        Task.init {
            if let productList = try await APIService.getData(
                url: APIService.productsBaseURL,
                dataType: ProductList.self) {
                self.products = productList.products
                
                let _ = self.products.map {  APIService.productsThumbnailImageURLDictionary[$0.id] = $0.thumbnail
                }
                
                let _ = self.products.map { self.productImageURLS.append($0.thumbnail) }
                
                self.productImages = try await APIService.getImages(urlStrings: productImageURLS)
                
            }
            
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        Task {
            if let usersList = try await APIService.getData(
                url: APIService.usersBaseURL,
                dataType: UserList.self) {
                self.users = usersList.users
                
                let _ = self.users.map {  APIService.usersThumbnailImageURLDictionary[$0.id] = $0.image
                }
                
                let _ = self.users.map { self.userImageURLS.append($0.image) }
                
                self.userImages = try await APIService.getImages(urlStrings: userImageURLS)
                
            }
            
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setNavigationBarItems() {
        let navBar = UINavigationBar(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: UIScreen.main.bounds.width,
                                                   height: 44))
        
    }
    
    func addTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: 0)
        ])
    }

    func addActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    

}


//MARK: - TableView Delegate

extension ProductsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "USERS" : "PRODUCTS"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return users.count
        }
        
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return prepareCellForUser(for: indexPath)
        }
        
        return prepareCellForProduct(for: indexPath)
    }
    
    func prepareCellForUser(for indexPath: IndexPath) -> UserTableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell {
            cell.nameLabel.text = "\(users[indexPath.row].fullName) , \(users[indexPath.row].age)"
            cell.userImageView?.image = userImages[users[indexPath.row].image]
            cell.genderLabel.text = users[indexPath.row].gender
            
            return cell
        }
        
        return UserTableViewCell()
    }
    
    func prepareCellForProduct(for indexPath: IndexPath) -> ProductTableViewCell {
        if let cell  =  tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell {
            cell.titleLabel.text = products[indexPath.row].title
            cell.priceLabel.text = String(products[indexPath.row].price)
            cell.productImageView.image = productImages[products[indexPath.row].thumbnail]
            
            return cell
        }
        
        return ProductTableViewCell()
        
    }
}
