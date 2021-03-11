//
//  TaskViewModel.swift
//  DailyTaskTracker
//
//  Created by Anirudha Kumar on 10/03/21.
//

import Foundation

struct TaskViewModel {
    
    var taskId: Int
    var taskTitle: String
    var taskStartDate: String?
    var taskEndDate: String?
    var taskStartTime: String?
    var taskEndtime: String?
    var taskStatus: String?
    var startTimeInterval: TimeInterval?
    var endTimeInterval: TimeInterval?
    
    init(dataModel: TaskData) {
        self.taskId = dataModel.id
        self.taskTitle = dataModel.title
        let startDateComponents = dataModel.startTime.components(separatedBy: Constants.emptySpace)
        if let date = startDateComponents.first, let time = startDateComponents.last {
            self.taskStartDate = date
            self.taskStartTime = time
        }
        let endDateComponents = dataModel.endTime.components(separatedBy: Constants.emptySpace)
        if let date = endDateComponents.first, let time = endDateComponents.last {
            self.taskEndDate = date
            self.taskEndtime = time
        }
        self.taskStatus = determineTaskStatus(dateString: dataModel.endTime)
        self.startTimeInterval = getTimeInterval(dateString: dataModel.startTime)
        self.endTimeInterval = getTimeInterval(dateString: dataModel.endTime)

    }
    
    func getTimeInterval(dateString: String)-> TimeInterval {
        let startDate = DateFormatter().date(from: dateString)
        return startDate?.timeIntervalSinceNow ?? 0
    }
    
    func determineTaskStatus(dateString: String)-> String {
        let timeInterval = DateFormatter().date(from: dateString)
        return timeInterval?.timeIntervalSinceNow ?? 0 > 0 ? Constants.completedString : Constants.todoString
    }
    
}
