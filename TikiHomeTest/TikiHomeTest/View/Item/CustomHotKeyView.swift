//
//  CustomHotKeyView.swift
//  TikiHomeTest
//
//  Created by NGUYEN NGOC THANH on 11/13/18.
//  Copyright © 2018 NGUYEN NGOC THANH. All rights reserved.
//

import UIKit

protocol HotkeyViewDelegate {
    func clickOnItem(index: Int)
}

class CustomHotKeyView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var headerViewTop: NSLayoutConstraint!
    
    var delegate: HotkeyViewDelegate?
    var index: Int = 0
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.backgroundColor = UIColor.clear
        addButton.addTarget(self, action: #selector(self.clickOnContent), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    lazy var contentView: UIImageView = {
        let contentView = UIImageView()
        contentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.font = UIFont.systemFont(ofSize: 14)
        headerTitle.text = "HotKey"
        headerTitle.textColor = UIColor.white
        headerTitle.textAlignment = .center
        headerTitle.numberOfLines = 2
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        return headerTitle
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        bottomView.layer.cornerRadius  = 8.0
        bottomView.layer.masksToBounds = true
        bottomView.layer.borderWidth   = 1.0
        bottomView.layer.borderColor   = UIColor.lightGray.cgColor
        bottomView.layer.shadowColor = UIColor.gray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 10)
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowRadius = 5
        bottomView.addSubview(addButton)
        bottomView.addSubview(headerTitle)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        addSubview(contentView)
        addSubview(bottomView)
        setupLayout()
    }
    
    private func setupLayout() {
        headerViewTop = contentView.topAnchor.constraint(equalTo: topAnchor)
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: bottomView.topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            headerTitle.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 96),
            contentView.widthAnchor.constraint(equalToConstant: 96),
            
            addButton.topAnchor.constraint(equalTo: bottomView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            addButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            
            bottomView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    @objc private func clickOnContent() {
        if delegate != nil {
            delegate?.clickOnItem(index: self.index)
        }
    }
    
    func updateData(key: String, icon: String, index: Int = 0) {
        contentView.loadFromUrl(stringUrl: icon)
        headerTitle.text = key
        self.index = index
        addButton.accessibilityIdentifier = "addButton\(index)"
        switch index%9 {
        case 0:
            bottomView.backgroundColor = Constant.bg_item_color0
        case 1:
            bottomView.backgroundColor = Constant.bg_item_color1
        case 2:
            bottomView.backgroundColor = Constant.bg_item_color2
        case 3:
            bottomView.backgroundColor = Constant.bg_item_color3
        case 4:
            bottomView.backgroundColor = Constant.bg_item_color4
        case 5:
            bottomView.backgroundColor = Constant.bg_item_color5
        case 6:
            bottomView.backgroundColor = Constant.bg_item_color6
        case 7:
            bottomView.backgroundColor = Constant.bg_item_color7
        case 8:
            bottomView.backgroundColor = Constant.bg_item_color8
        default:
            bottomView.backgroundColor = Constant.bg_item_color0
        }
    }

}
