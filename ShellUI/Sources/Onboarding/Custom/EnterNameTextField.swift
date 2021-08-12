import UIKit
import Shell

public extension EnterNameTextField {
    struct Props {
        public let text: String
        public let placeholder: String
        public let updated: CommandWith<String>

        public init(text: String, placeholder: String, updated: CommandWith<String>) {
            self.text = text
            self.placeholder = placeholder
            self.updated = updated
        }

        static let initial = Props(text: "", placeholder: "", updated: .nop)
    }
}

public final class EnterNameTextField: UITextField {
    public var props = Props.initial {
        didSet { render() }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        textColor = .black
        font = UIFont.systemFont(ofSize: 27)
        textContentType = .none
        autocorrectionType = .no
        keyboardAppearance = .light
        leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: frame.height))
        leftViewMode = .always
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func render() {
        text = props.text

        attributedPlaceholder = NSAttributedString(
            string: props.placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.5)])
    }

    @objc private func textFieldDidChange() {
        text.map { props.updated.perform(with: $0) }
    }
}
