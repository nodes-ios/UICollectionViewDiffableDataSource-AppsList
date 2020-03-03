//
//  AppCell.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

protocol AppCellDelegate {
    func didLongPress()
}

class AppCell: UICollectionViewCell {
    
    // MARK: - Properties -
    var delegate: AppCellDelegate?
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let deleteButton = UIButton()
    
    var isEditing: Bool = false {
        didSet {
            if isEditing {
                shake()
            } else {
                stopShaking()
            }
            deleteButton.isHidden = !isEditing
        }
    }
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupDeleteButton()
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setupStackView() {
        let stackview = UIStackView(arrangedSubviews: [iconImageView, nameLabel])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.spacing = 4
        contentView.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupDeleteButton() {
        let width: CGFloat = 16
        deleteButton.setImage(UIImage(named: "delete")!, for: .normal)
        deleteButton.isHidden = !isEditing
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: width),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: -(width/2)),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: -(width/2))
        ])
    }
    
    private func style() {
        contentView.backgroundColor = .clear
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 10
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textAlignment = .center
    }
    
    // MARK: - Configuration -
    func configure(with app: App) {
        iconImageView.image = UIImage(named: app.image)
        nameLabel.text = app.name
    }
    
    func setIsEditing(_ isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    // MARK: - Animation -
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()

        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }

    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
}
