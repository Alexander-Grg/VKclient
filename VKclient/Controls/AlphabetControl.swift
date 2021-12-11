//
//  AlphabetControl.swift
//  MyFirstApp
//
//  Created by Alexander Grigoryev on 03.10.2021.
//

import UIKit

final class AlphabetControl: UIControl {
    
    private var allLetters = [String]() {
        didSet {
            setupButtons()
        }
    }
    
    private var buttons = [UIButton]()
    
    private var selectedButton: String? = nil {
        didSet {
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLetters(_ letters: [String]) {
        self.allLetters = letters
    }
    
    private func setupButtons() {
        for letter in allLetters {
            let button = UIButton(type: .system)
            button.setTitle( letter, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.setTitleColor(.gray, for: .selected)
            button.addTarget(self, action: #selector(selectedLetter(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 1
    }
    
    @objc private func selectedLetter(_ sender: UIButton) {
        
        guard let index = self.buttons.firstIndex(of: sender) else {
            return
        }
        self.selectedButton = allLetters[index]
    }
}
