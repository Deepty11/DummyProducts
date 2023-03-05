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
            self.products = try await APIService.getProducts(url: APIService.productsBaseURL)
            
            let _ = self.products.map { self.productImageURLS.append($0.thumbnail) }
            
            self.productImages = try await APIService.getImages(urlStrings: productImageURLS)

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  =  tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell {
            cell.titleLabel.text = products[indexPath.row].title
            cell.priceLabel.text = String(products[indexPath.row].price)
            cell.productImageView.image = productImages[products[indexPath.row].thumbnail]
            
            return cell
        }

        return UITableViewCell()
    }
    
}
