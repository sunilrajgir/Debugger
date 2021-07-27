//
//  OTDebugCell.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

class OTDebugCell: UITableViewCell {

    var titleLabel = UILabel()
    var switchButton = UISwitch()
    var onSwitchAction : ((_ isOn: Bool, _ type: OTDInfoType)->Void)?
    var data: OTDScreenCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }

    deinit {

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        titleLabel.frame = CGRect(x: 20, y: 20, width: contentView.frame.size.width, height: 20)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        switchButton.frame = CGRect(x: contentView.frame.size.width, y: 10, width: 40, height: 40)
        switchButton.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        addSubview(switchButton)
    }

    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        switchButton.isHidden = true
        data = nil
    }

    @objc func switchValueChanged(_ sender: UISwitch!) {
        if (sender.isOn){
            self.onSwitchAction?(true, data!.type)
        }else{
            self.onSwitchAction?(false, data!.type)
        }
    }

    func configureCell(data: OTDScreenCellModel) {
        self.data = data
        if data.type == .translation || data.type == .uIDebug {
            self.accessoryType = .none
            switchButton.isHidden = false
        } else {
            self.accessoryType = .disclosureIndicator
            switchButton.isHidden = true
        }
        titleLabel.textColor = .black
        titleLabel.text = data.title
    }
}
