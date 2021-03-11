//
//  TaskData.swift
//  DailyTaskTracker
//
//  Created by Anirudha Kumar on 10/03/21.
//

import Foundation

struct TaskData {
    var id: Int
    var title: String
    var status: String
    var startTime: String
    var endTime: String
    
    init(id: Int, title: String, status: String, startTime: String, endTime: String) {
        self.id = id
        self.title = title
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
    }
}
