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
    @IBOutlet weak var favoriteImageView: UIImageView!
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
    
    fileprivate func setupFavoriteImageView() {
        favoriteImageView.tintColor = .systemRed
        favoriteImageView.contentMode = .scaleAspectFit
        favoriteImageView.isUserInteractionEnabled = true
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
        viewModel.iconData
            .subscribe(onNext: { image in
                DispatchQueue.main.async {

                    guard let image = image else {
                        self.imageHeight.constant = 0
                        return
                    }
                    
                    self.launchImageView.alpha = 0
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                        self.imageHeight.constant = self.heightConstant
                        self.launchImageView.image = image // TODO: convert to bind
                        self.launchImageView.alpha = 1
                        
                    } completion: { _ in }

                    
                }
            }, onError: { error in
                errorLog("failed to fetch image: \(error.localizedDescription)")
                self.imageHeight.constant = 0
            }, onCompleted: {

            }, onDisposed: { debugLog("image request is disposed: \(viewModel.name)")  })
            .disposed(by: bag)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bag = DisposeBag()
        self.launchImageView.image = nil
    }
}
