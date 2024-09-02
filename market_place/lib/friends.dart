class FriendInfo {
  final String name;
  final String icon;
  final String contractId;

  const FriendInfo({required this.name, required this.icon, required this.contractId});
}

const List<FriendInfo> Friends = [
  FriendInfo(name: "Johnny", icon: "assets/johny_icon.png", contractId: "aab")
];