//
//  FastisMonthHeader.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 10.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import JTAppleCalendar
import UIKit

final class MonthHeader: JTACMonthReusableView {

    // MARK: - Outlets
    private let dividerView: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor(red: 0.45, green: 0.44, blue: 0.51, alpha: 1).withAlphaComponent(0.2)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weekNamesStackView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .horizontal
        obj.backgroundColor = .clear
        obj.distribution = .fillEqually
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let selectMonthButton: UIButton = {
        let title = NSAttributedString(string: "action_select_month".localized, attributes: [
            .font: UIFont.manrope(ofSize: 14, weight: .semiBold),
            .foregroundColor: UIColor(red: 0.45, green: 0.44, blue: 0.51, alpha: 1)
        ])
        
        let obj = UIButton(type: .system)
        obj.setAttributedTitle(title, for: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    // MARK: - Variables

    private var leftAnchorConstraint: NSLayoutConstraint?
    private var rightAnchorConstraint: NSLayoutConstraint?
    private var topAnchorConstraint: NSLayoutConstraint?
    private var bottomAnchorConstraint: NSLayoutConstraint?

    internal var calculatedHeight: CGFloat = 0
    internal var tapHandler: (() -> Void)?
    private lazy var monthFormatter = DateFormatter()
    private let calendar = Calendar.current

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
        self.configureConstraints()
        self.applyConfig(FastisConfig.default.monthHeader)
        self.selectMonthButton.addTarget(self, action: #selector(didSelectMonthButtobTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureSubviews() {
        self.addSubview(self.dividerView)
        self.addSubview(self.monthLabel)
        self.addSubview(self.selectMonthButton)
        self.addSubview(self.weekNamesStackView)
        calendar.shortWeekdaySymbols.enumerated().forEach { index, weekName in
            weekNamesStackView.addArrangedSubview(
                makeWeekLabel(
                    for: weekName,
                    index: index,
                    count: calendar.shortWeekdaySymbols.count))
        }
    }
    
    private func makeWeekLabel(for symbol: String, index: Int, count: Int) -> UILabel {
        let label = UILabel()
        label.text = symbol.uppercased()
        label.font = .manrope(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.65, green: 0.64, blue: 0.67, alpha: 1)
        if index == 0 {
            label.textAlignment = .left
        } else if index == count-1 {
            label.textAlignment = .right
        } else {
            label.textAlignment = .center
        }
        return label
    }

    private func configureConstraints() {
        self.leftAnchorConstraint = self.monthLabel.leftAnchor.constraint(equalTo: self.leftAnchor)
        self.rightAnchorConstraint = self.selectMonthButton.rightAnchor.constraint(equalTo: self.rightAnchor)
        self.topAnchorConstraint = self.monthLabel.topAnchor.constraint(equalTo: self.topAnchor)
        self.bottomAnchorConstraint = self.weekNamesStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            self.monthLabel.rightAnchor.constraint(equalTo: self.selectMonthButton.leftAnchor),
            self.leftAnchorConstraint,
            self.topAnchorConstraint
        ].compactMap({ $0 }))
        
        NSLayoutConstraint.activate([
            self.weekNamesStackView.leftAnchor.constraint(equalTo: self.monthLabel.leftAnchor),
            self.weekNamesStackView.rightAnchor.constraint(equalTo: self.selectMonthButton.rightAnchor),
            self.weekNamesStackView.topAnchor.constraint(equalTo: self.monthLabel.bottomAnchor, constant: 20),
            self.weekNamesStackView.heightAnchor.constraint(equalToConstant: 20),
            self.bottomAnchorConstraint
        ].compactMap({$0}))
        
        NSLayoutConstraint.activate([
            self.selectMonthButton.centerYAnchor.constraint(equalTo: self.monthLabel.centerYAnchor),
            self.rightAnchorConstraint
        ].compactMap({$0}))
        
        NSLayoutConstraint.activate([
            self.dividerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.dividerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14),
            self.dividerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    internal func configure(for date: Date) {
        self.monthLabel.text = self.monthFormatter.string(from: date).capitalizingFirstLetter()
    }

    // MARK: - Actions

    internal func applyConfig(_ config: FastisConfig.MonthHeader) {
        self.monthFormatter.dateFormat = config.monthFormat
        self.monthFormatter.locale = config.monthLocale
        self.monthLabel.font = config.labelFont
        self.monthLabel.textColor = config.labelColor
        self.monthLabel.textAlignment = config.labelAlignment
        self.leftAnchorConstraint?.constant = config.insets.left
        self.rightAnchorConstraint?.constant = -config.insets.right
        self.topAnchorConstraint?.constant = config.insets.top
        self.bottomAnchorConstraint?.constant = -config.insets.bottom
    }

    @objc
    private func didSelectMonthButtobTapped() {
        self.tapHandler?()
    }

}

public extension FastisConfig {

    /**
     Month titles

     Configurable in FastisConfig.``FastisConfig/monthHeader-swift.property`` property
     */
    struct MonthHeader {

        /**
         Text alignment for month title label

         Default value — `.left`
         */
        public var labelAlignment: NSTextAlignment = .left

        /**
         Text color for month title label

         Default value — `.label`
         */
        public var labelColor: UIColor = .label

        /**
         Text font for month title label

         Default value — `.systemFont(ofSize: 17, weight: .semibold)`
         */
        public var labelFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)

        /**
         Insets for month title label

         Default value — `UIEdgeInsets(top: 24, left: 8, bottom: 4, right: 16)`
         */
        public var insets = UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)

        /**
         Format of displayed month value

         Default value — `"LLLL yyyy"`
         */
        public var monthFormat = "LLLL yyyy"

        /**
         Locale of displayed month value

         Default value — `.current`
         */
        public var monthLocale: Locale = .current

        /**
         Height of month view

         Default value — `48pt`
         */
        public var height = MonthSize(defaultSize: 104)
    }

}
