import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/event/refresh_todo_event.dart';
import 'package:flutter_wanandroid/ui/todo_complete_screen.dart';
import 'package:flutter_wanandroid/ui/todo_list_screen.dart';
import 'package:flutter_wanandroid/utils/theme_util.dart';

/// TODO 页面
class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TodoScreenState();
  }
}

class TodoScreenState extends State<TodoScreen>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0; // 当前选中的索引

  final bottomBarTitles = ["待办", "已完成"];

  int _todoSelectedIndex = 0;

  final todoTypeList = ["只用这一个", "工作", "学习", "生活"];

  PageController _pageController = PageController();

  var pages = <Widget>[
    TodoListScreen(),
    TodoCompleteScreen(),
  ];

  // 返回每个隐藏的菜单项
  selectView(String text, int index) => new PopupMenuItem<int>(
      value: index,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Text(
            text,
            style: TextStyle(
                color: index == _todoSelectedIndex
                    ? Colors.cyan
                    : ThemeUtils.dark ? Colors.white : Colors.black),
          ),
        ],
      ));

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: new Text(todoTypeList[_todoSelectedIndex]),
        bottom: null,
        elevation: 0,
        actions: <Widget>[
          // 隐藏的菜单
          new PopupMenuButton<int>(
            icon: Icon(Icons.swap_horiz),
            itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
              this.selectView(todoTypeList[0], 0),
              this.selectView(todoTypeList[1], 1),
              this.selectView(todoTypeList[2], 2),
              this.selectView(todoTypeList[3], 3),
            ],
            onSelected: (int index) {
              setState(() {
                _todoSelectedIndex = index;
              });
              Application.eventBus.fire(RefreshTodoEvent(index));
            },
          ),
        ],
      ),
      body: PageView.builder(
        itemBuilder: (context, index) => pages[index],
        itemCount: pages.length,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.description), title: Text(bottomBarTitles[0])),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), title: Text(bottomBarTitles[1])),
        ],
        type: BottomNavigationBarType.fixed, // 设置显示模式
        currentIndex: _selectedIndex, // 当前选中项的索引
        onTap: (index) {
          _pageController.jumpToPage(index);
        }, //
      ),
    );
  }
}
