//
//  BaseViewController.swift
//  DailyTaskTracker
//
//  Created by Anirudha Kumar on 10/03/21.
//

import UIKit
import EventKit
import UserNotifications

class BaseViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var taskModel = [TaskViewModel]()
    lazy var eventStore = EKEventStore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.isHidden = taskModel.isEmpty
        noDataLabel.isHidden = !taskModel.isEmpty
        addEventStore()
        askPermissionForNotification()
    }

    @IBAction func addTaskButtonAction(_ sender: UIBarButtonItem) {
        guard let addTaskVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddTaskViewController") as? AddTaskViewController else { return }
        addTaskVC.taskDelegate = self
        addTaskVC.modalPresentationStyle = .currentContext
        self.present(addTaskVC, animated: false, completion: nil)
        
    }
    
    func askPermissionForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (success, error) in
            if success {
                self?.taskModel.forEach { (taskViewModel) in
                    self?.triggerNotification(viewModel: taskViewModel)
                }
            } else {
                print(Constants.deniedPermission)
            }
        }
    }
    
    func triggerNotification(viewModel: TaskViewModel) {
        let content = UNMutableNotificationContent()
        content.title = Constants.reminder
        content.subtitle = viewModel.taskTitle + Constants.tobeCompletedMsg
        content.sound = UNNotificationSound.default
        if viewModel.startTimeInterval ?? 0 >= 300 {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func addEventStore() {
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print(Constants.authorize)
        case .denied:
            print(Constants.deniedPermission)
        case .notDetermined:
            eventStore.requestAccess(to: .event) { (granted, error) in
                if granted {
                    print(Constants.acceptedpermission)
                } else {
                    print(Constants.accessDenied)
                }
            }
        default:
            break
        }
    }
    
    func insertEvent(store: EKEventStore, taskData: TaskData) {
        let calenders = store.calendars(for: .event)
        
        for calendar in calenders {
            let event = EKEvent(eventStore: store)
            event.calendar = calendar
            event.title = taskData.title
            event.startDate = DateFormatter().date(from: taskData.startTime)
            event.endDate = DateFormatter().date(from: taskData.endTime)
            do {
                try store.save(event, span: .thisEvent)
            }
            catch {
                print(Constants.saveCalenderEventError)
            }
        }
    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskTableViewCell else { return UITableViewCell() }
        let eachTaskData = taskModel[indexPath.row]
        taskCell.setupCellData(data: eachTaskData)
        return taskCell
    }
}

extension BaseViewController: AddTaskDelegateProtocol {
    
    func addTaskData(data: TaskData) {
        self.insertEvent(store: eventStore, taskData: data)
        self.taskModel.append(TaskViewModel(dataModel: data))
        self.taskModel.forEach { (taskViewModel) in
            self.triggerNotification(viewModel: taskViewModel)
        }
        taskTableView.isHidden = taskModel.isEmpty
        noDataLabel.isHidden = !taskModel.isEmpty
        taskTableView.reloadData()
    }
    
}

