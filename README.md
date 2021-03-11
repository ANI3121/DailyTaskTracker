# DailyTaskTracker
I have followed MVVM architecture to complete this task and same has been grouped as Model, View, ViewModel.
A common group is available to add common files like constant strings.
Landing screen is a table view where an add button is available to add task by user.
When user clicks on Add button a form sheet having input fields Title, Start Time and End Time get opened.
When confirm button on formsheet get clicked, a delegate is called to update the data to landing screen
Also delegate insert an event to calender(Native EventKit used)
A local notification get trigered when start time of an event is 5 minutes to start.
