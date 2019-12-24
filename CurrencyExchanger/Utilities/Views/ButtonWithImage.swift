//
//  ButtonWithImage.swift
//  CurrencyExchanger
//
//  Created by alvin joseph valdez on 12/24/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public class ButtonWithImage: UIButton {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 20), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
