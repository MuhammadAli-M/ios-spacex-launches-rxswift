//
//  LaunchTableViewCell.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//

import UIKit
import RxSwift
//import Kingfisher

protocol LaunchTableViewCellDelegate: AnyObject{
    func cell(urlString: String, updatesFavoriteState isFavorite: Bool)
}

class LaunchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var launchNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var launchImageView: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    let heightConstant: CGFloat = 269
    static let Id = "LaunchTableViewCell"
    var url: String = ""
    weak var delegate: LaunchTableViewCellDelegate?
    
    var bag: DisposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        launchNumber.font = UIFont.preferredFont(forTextStyle: .subheadline)
        launchNumber.textColor = .systemBlue
        date.textColor = .secondaryLabel
        date.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

// TODO: Fix to bind on it
extension LaunchTableViewCell{
    func configure(viewModel: LaunchViewModel) {
        debugLog("will configure launch cell of name: \(viewModel.name)")
        self.name.text = viewModel.name
        self.launchNumber.text = viewModel.number
        self.date.text = viewModel.date
        self.details.text = viewModel.details
        
        self.launchImageView.image = nil
        self.bag = DisposeBag()
        self.imageHeight.constant = self.heightConstant

        if viewModel.iconPath.isEmpty == false{
            
            GetImageService.shared.getImage(path: viewModel.iconPath)
                .map { UIImage(data: $0)}
                .subscribe(onNext: { [weak self] image in
                    
                    guard let `self` = self else { return }
                    
                    DispatchQueue.main.async { [weak self] in

                        guard let `self` = self else { return }
                        
                        guard let image = image else {
                            self.imageHeight.constant = 0
                            return
                        }
                        self.launchImageView.alpha = 0
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                            self.launchImageView.image = image // TODO: convert to bind
                            self.launchImageView.alpha = 1
                            
                        } completion: { _ in }

                    }
                }, onError: { [weak self] error in
                    
                    guard let `self` = self else { return }
                    
                    errorLog("failed to fetch image: \(error.localizedDescription)")
                    self.imageHeight.constant = 0
                }, onCompleted: {

                }, onDisposed: { debugLog("image request is disposed: \(viewModel.name)")  })
                .disposed(by: bag)
            
        }else{
            self.imageHeight.constant = 0
        }
    }
}
