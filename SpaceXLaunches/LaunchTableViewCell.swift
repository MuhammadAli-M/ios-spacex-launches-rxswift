//
//  LaunchTableViewCell.swift
//  SpaceXLaunches
//
//  Created by Muhammad Adam on 16/11/2021.
//

import UIKit
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
    static let Id = "LaunchTableViewCell"
    let favoriteImageString = "heart.fill"
    let notFavoriteImageString = "heart"
    private var isFavorite = false {
        didSet{
            let imageString = isFavorite ? favoriteImageString : notFavoriteImageString
            favoriteImageView.image = UIImage(systemName: imageString)
        }
    }
    var url: String = ""
    weak var delegate: LaunchTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        isFavorite = false
        setupFavoriteImageView()
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        launchNumber.font = UIFont.preferredFont(forTextStyle: .subheadline)
        launchNumber.textColor = .systemBlue
        date.textColor = .secondaryLabel
        date.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    fileprivate func setupFavoriteImageView() {
        favoriteImageView.tintColor = .systemRed
        favoriteImageView.contentMode = .scaleAspectFit
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(favoriteBtnTapped)))
        favoriteImageView.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func favoriteBtnTapped(_ sender: Any) {
        isFavorite.toggle()
        delegate?.cell(urlString: self.url, updatesFavoriteState: isFavorite)
    }
}

// TODO: Fix to bind on it
extension LaunchTableViewCell{
    func configure(viewModel: LaunchViewModel) {
        self.name.text = viewModel.name
        self.launchNumber.text = viewModel.number
        self.date.text = viewModel.date
        self.details.text = viewModel.details
    }
    
    func displayImage(url imageUrl: URL?){
        // TODO: Needs fix
        
//        guard let url = imageUrl else { return }
//        let resource = ImageResource(downloadURL: url,
//                                     cacheKey: url.absoluteString)
//        let imageCache = ImageCache(name: url.absoluteString)
//        let processor = DownsamplingImageProcessor(size: launchImageView.bounds.size)
//                     |> RoundCornerImageProcessor(cornerRadius: 7)
//        launchImageView.kf.indicatorType = .activity
//        launchImageView.kf.setImage(
//            with: resource,
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .targetCache(imageCache)
//            ], completionHandler:
//                {
//                    result in
//                    switch result {
//                    case .success(let value):
//                        debugLog("image loaded for: \(value.source.url?.absoluteString ?? "")")
//                        DispatchQueue.main.async { [weak self] in
//                            self?.setNeedsLayout()
//                        }
//                    case .failure(let error):
//                        errorLog("image failed: \(error.localizedDescription)")
//                    }
//                })

    }
}


struct LaunchViewModel{
    let name: String
    let number: String
    let date: String
    let details: String
    let iconData: Data?
    let upcoming: Bool
    
    init(_ model: Launch){
        name = model.name
        number = String(model.number)
        date = model.date
        details = model.details
        iconData =  model.iconData
        upcoming = model.upcoming

    }
}
