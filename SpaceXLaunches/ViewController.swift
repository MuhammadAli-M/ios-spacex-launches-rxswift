//
//  ViewController.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

struct Product{
    let imageName: String
    let title: String
}

struct ProductViewModel{
    var items = PublishSubject<[Product]>()
    
    func fetchItems(){
        let procducts = [
        Product(imageName: "house", title: "Home"),
        Product(imageName: "gear", title: "Settings"),
        ]
        
        items.onNext(procducts)
        items.onCompleted()
    }
}


class ViewController: UIViewController {

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func bindTableData(){
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell",
                                                    cellType: UITableViewCell.self)) { row , item , cell in
            cell.textLabel?.text = item.title
            cell.imageView?.image = UIImage(systemName: item.imageName)
        }.disposed(by: bag)
        
        // Bind a model selected
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        // fetch items
        viewModel.fetchItems()
    }
}




func debugLog(_ message:String, file:String = #file, function:String = #function, line:Int = #line){
    print("DEBUG: \(message), ::\(function) \(file.split(separator: "/").last ?? ""):[\(line)]")
}

func errorLog(_ message:String, file:String = #file, function:String = #function, line:Int = #line){
    print("Error: \(message), ::\(function) \(file.split(separator: "/").last ?? ""):[\(line)]")
}


extension Data {
    /// Hexadecimal string representation of `Data` object.
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}
