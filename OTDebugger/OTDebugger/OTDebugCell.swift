//
//  OTDebugCell.swift
//  OTDebugger
//
//  Created by Sunil Kumar on 23/07/21.
//

import UIKit

class OTDebugCell: UITableViewCell {

    var titleLabel = UILabel()

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
    }

    func configureCell(data: OTDScreenCellModel) {
        self.accessoryType = .disclosureIndicator
        titleLabel.textColor = .black
        titleLabel.text = data.title
    }

}
