//
//  TaskTableViewCell.swift
//  DailyTaskTracker
//
//  Created by Anirudha Kumar on 10/03/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellView()
    }
    
    func configureCellView() {
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.shadowRadius = 10
        containerView.layer.borderWidth = 1.0
        statusLabel.layer.cornerRadius = 5.0
        statusLabel.layer.borderWidth = 0.5
        statusLabel.clipsToBounds = true
    }
    
    func setupCellData(data: TaskViewModel) {
        titleLabel.text = data.taskTitle
        startTimeLabel.text = "\(Constants.startTimeStr): \(data.taskStartDate ?? "") \(data.taskStartTime ?? "")"
        endTimeLabel.text = "\(Constants.endTimeStr): \(data.taskEndDate ?? "") \(data.taskEndtime ?? "")"
    }

}
