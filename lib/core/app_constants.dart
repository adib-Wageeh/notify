class AppConstants {
  const AppConstants._();

  static const Map<String, String> whatToOpenItems = {
    "Open today screen": "/today",
    "Open create screen": "/create",
    "open inbox screen": "/inbox",
    "open station screen": "/station",
  };

  static const List<String> deliveryType = ["Local reminder", "Cloud test"];

  static const Map<String, String> usersTokens = {
    "all": "",
    "adib samsung": "",
    "adib iphone": "",
    "emulator": "dKW8Xo9bQFOjnyY2T5e-cp:APA91bHncP_FcAUF6Rq9NtZ-mhM9SwX5OXHjliuZ7rQP7IdocYTZcJc0pUuDWOb3GdPXDz85LWykjs4F9dysXDhoAjL3Dzya0Lk_JojMYWlLhbmjHci5hZU",
  };

  static const String hiveBoxName = "myNotifications";


  static const String markAsDoneActionId = "mark_as_done_id";
  static const String snoozeActionId = "snooze_id";
}
