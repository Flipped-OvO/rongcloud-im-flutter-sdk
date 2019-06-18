//消息存储标识
class RCMessagePersistentFlag {
  static const int None = 0;
  static const int IsPersisted = 1;
  static const int IsCounted = 3;
  static const int Status = 16;
}

//消息发送状态
class RCSentStatus {
  static const int Sending = 10;//发送中
  static const int Failed = 20;//发送失败
  static const int Sent = 30;//发送成功
}

//消息方向
class RCMessageDirection {
  static const int Send = 1;
  static const int Receive = 2;
}

//消息接收状态
class RCReceivedStatus {
  static const int Unread = 0;//未读
  static const int Read = 1;//已读
  static const int Listened = 2;//已听，语音消息
  static const int Downloaded = 4;//已下载
  static const int Retrieved = 8;//已经被其他登录的多端收取过
  static const int MultipleReceive = 16;//被多端同时收取
}

//回调状态
class RCOperationStatus {
  static const int Success = 0;
  static const int Failed = 1;
}