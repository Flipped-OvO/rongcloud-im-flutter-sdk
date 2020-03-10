import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix ;

class DebugPage extends StatelessWidget {
  List titles;
  String blackUserId = "blackUserId";

  DebugPage() {
    titles = [
      "设置全局屏蔽某个时间段的消息提醒",
      "查询已设置的全局时间段消息提醒屏蔽",
      "删除已设置的全局时间段消息提醒屏蔽",
      "获取特定会话",
      "获取特定方向的消息列表",
      "分页获取会话",
      "消息携带用户信息",
    ];
  }

  void _didTap(int index) {
    print("did tap debug " + titles[index]);
    switch (index) {
      case 0:
        _setNotificationQuietHours();
        break;
      case 1:
        _getNotificationQuietHours();
        break;
      case 2:
        _removeNotificationQuietHours();
        break;
      case 3:
        _getCons();
        break;
      case 4:
        _getMessagesByDirection();
        break;
      case 5:
        _getConversationListByPage();
        break;
      case 6:
        _sendMessageAddSendUserInfo();
        break;
    }
  }

  void _setNotificationQuietHours() {
    print("_setNotificationQuietHours");
    prefix.RongcloudImPlugin.setNotificationQuietHours("12:10:10", 120, (int code) {
      String toast = "setNotificationQuietHours:" + blackUserId + " code:" + code.toString();
      print(toast);
      Fluttertoast.showToast(msg: toast);
    });
  }

  void _getNotificationQuietHours() {
    print("_getNotificationQuietHours");
    prefix.RongcloudImPlugin.getNotificationQuietHours((int code, String startTime, int spansMin) {
      String toast = "getNotificationQuietHours: startTime:" + startTime + " spansMin:" + spansMin.toString() + " code:" + code.toString();
      print(toast);
      Fluttertoast.showToast(msg: toast, timeInSecForIos: 2);
    });
  }

  void _removeNotificationQuietHours() {
    print("_removeNotificationQuietHours");
    prefix.RongcloudImPlugin.removeNotificationQuietHours((int code) {
      String toast = "removeNotificationQuietHours:" + blackUserId + " code:" + code.toString();
      print(toast);
      Fluttertoast.showToast(msg: toast);
    });
  }

  void _getCons() async {
    int conversationType = prefix.RCConversationType.Private;
    String targetId =  "SealTalk";
    prefix.Conversation con = await prefix.RongcloudImPlugin.getConversation(conversationType,targetId);
    if(con != null) {
      print("getConversation type:"+con.conversationType.toString()+" targetId:"+con.targetId);
    }else {
      print("不存在该会话 type:"+conversationType.toString()+" targetId:"+targetId);
    }
  }

  void _getMessagesByDirection() async {
    int conversationType = prefix.RCConversationType.Private;
    String targetId =  "SealTalk";
    int sentTime = 1567756686643;
    int beforeCount = 10;
    int afterCount = 10;
    List msgs = await prefix.RongcloudImPlugin.getHistoryMessages(conversationType, targetId, sentTime, beforeCount, afterCount);
    if(msgs == null)  {
      print("未获取消息列表 type:"+conversationType.toString()+" targetId:"+targetId);
    }else {
      for(prefix.Message msg in msgs) {
        print("getHistoryMessages messageId:"+msg.messageId.toString()+" objName:"+ msg.objectName +" sentTime:"+msg.sentTime.toString());
      }
    }
  }

  void _getConversationListByPage() async {
    List list = await prefix.RongcloudImPlugin.getConversationListByPage([prefix.RCConversationType.Private,prefix.RCConversationType.Group], 2, 0);
    prefix.Conversation lastCon ;
    if (list != null && list.length > 0) {
      list.sort((a,b) => b.sentTime.compareTo(a.sentTime));
      for(int i=0;i<list.length;i++) {
        prefix.Conversation con = list[i];
        print("first targetId:"+con.targetId+" "+"time:"+con.sentTime.toString());
        lastCon = con;
      }
    }
    if(lastCon != null) {
      list = await prefix.RongcloudImPlugin.getConversationListByPage([prefix.RCConversationType.Private,prefix.RCConversationType.Group], 2, lastCon.sentTime);
      if (list != null && list.length > 0) {
        list.sort((a,b) => b.sentTime.compareTo(a.sentTime));
        for(int i=0;i<list.length;i++) {
          prefix.Conversation con = list[i];
          print("last targetId:"+con.targetId+" "+"time:"+con.sentTime.toString());
        }
      }
    }
  }

  void _sendMessageAddSendUserInfo() async {
    prefix.TextMessage msg = new prefix.TextMessage();
    msg.content = "测试文本消息携带用户信息";
    /*
    测试携带用户信息
    */
    prefix.UserInfo sendUserInfo = new prefix.UserInfo();
    sendUserInfo.name = "textSendUser.name";
    sendUserInfo.userId = "textSendUser.userId";
    sendUserInfo.portraitUri = "textSendUser.portraitUrl";
    sendUserInfo.extra = "textSendUser.extra";
    msg.sendUserInfo = sendUserInfo;

    prefix.Message message = await prefix.RongcloudImPlugin.sendMessage(prefix.RCConversationType.Private, "SealTalk", msg);
    String toast = "send message add sendUserInfo:"+message.content.getObjectName()+" msgContent:"+message.content.encode();
    print(toast);
    Fluttertoast.showToast(msg: toast, timeInSecForIos: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug"),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: titles.length,
        itemBuilder: (BuildContext context, int index) {
          return MaterialButton(
            onPressed: () {
              _didTap(index);
            },
            child: Text(titles[index]),
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
