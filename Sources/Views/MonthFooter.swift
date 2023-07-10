//
//  File.swift
//  
//
//  Created by Leyter on 10.07.2023.
//

import JTAppleCalendar
import UIKit

final class MonthFooter: JTACMonthReusableView {
    private let dividerView: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor(red: 0.45, green: 0.44, blue: 0.51, alpha: 1).withAlphaComponent(0.2)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(dividerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.dividerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.dividerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            self.dividerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            self.dividerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
