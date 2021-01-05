import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// 进度监听对象
  final ValueNotifier<double> factor = ValueNotifier<double>(1 / 5);

// 页数监听对象
  final ValueNotifier<int> page = ValueNotifier<int>(1);

  // 页面滑动控制器
  PageController _ctrl;

// 测试组件 色块
  final List<Widget> testWidgets =
      // [Colors.red, Colors.yellow, Colors.blue, Colors.green, Colors.orange]
      [
    ColorObject(name: "红色", color: Colors.red),
    ColorObject(name: "黄色", color: Colors.yellow),
    ColorObject(name: "蓝色", color: Colors.blue),
    ColorObject(name: "绿色", color: Colors.green),
    ColorObject(name: "橙色", color: Colors.orange),
  ]
          .map(
            (e) => Container(
              decoration: BoxDecoration(
                color: e.color,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  e.name,
                  style: TextStyle(fontSize:30.0, color: Colors.white),
                ),
              ),
            ),
          )
          .toList();

  Color get startColor =>  Color(0xff00fa60);//Colors.red; // 起点颜色
  Color get endColor => Color(0xff0575e6);//Colors.blue; // 终点颜色


  //圆角装饰
  BoxDecoration get boxDecoration => const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)));

  // 初始化
  @override
  void initState() {
    super.initState();
    _ctrl = PageController(
      viewportFraction: 0.9,
    )..addListener(() {
        double value = (_ctrl.page + 1) % 5 / 5;
        factor.value = value == 0 ? 1 : value;
      });
  }

  // 释放对象
  @override
  void dispose() {
    _ctrl.dispose();
    page.dispose();
    factor.dispose();
    super.dispose();
  }

  Widget _buildProgress() => Container(
        margin: EdgeInsets.only(bottom: 12, left: 48, right: 48, top: 10),
        height: 2,
        child: ValueListenableBuilder(
          valueListenable: factor,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: factor.value,
              valueColor: AlwaysStoppedAnimation(
                Color.lerp(
                  startColor,
                  endColor,
                  factor.value,
                ),
              ),
            );
          },
        ),
      );

  Widget _buildTitle(BuildContext context) {
    print('---------_buildTitle------------');
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.api,
            color: Colors.white,
            size: 45,
          ),
          SizedBox(
            width: 20,
          ),
          ValueListenableBuilder(
            valueListenable: page,
            builder: _buildWithPageChange,
          ),
        ],
      ),
    );
  }

  Widget _buildWithPageChange(BuildContext context, int value, Widget child) {
    return Text(
      "颜色 $value/5",
      style: TextStyle(fontSize: 30, color: Colors.white),
    );
  }

  Widget _buildContent() {
    return Container(
        padding: EdgeInsets.only(bottom: 80, top: 40),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) => page.value = index + 1,
                controller: _ctrl,
                itemCount: testWidgets.length,
                itemBuilder: (_, index) => AnimatedBuilder(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: testWidgets[index],
                    ),
                    animation: _ctrl,
                    builder: (context, child) =>
                        _buildAnimOfItem(context, child, index)),
              ),
            ),
            _buildProgress(),
          ],
        ));
  }

  Widget _buildAnimOfItem(BuildContext context, Widget child, int index) {
    double value;
    if (_ctrl.position.haveDimensions) {
      value = _ctrl.page - index;
    } else {
      value = index.toDouble();
    }
    value = (1 - ((value.abs()) * .5)).clamp(0, 1).toDouble();
    value = Curves.easeOut.transform(value);
    return Transform(
      transform: Matrix4.diagonal3Values(1.0, value, 1.0),
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: factor,
        builder: (_, value, child) => Container(
          color: Color.lerp(startColor, endColor, value),
          child: child, //<--- tag1
        ),
        child: Container(
          //<--- tag2
          child: Column(
            children: [
              _buildTitle(context),
              Expanded(
                  child: Container(
                child: _buildContent(),
                margin: const EdgeInsets.only(left: 8, right: 8),
                decoration: boxDecoration,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class ColorObject {
  ColorObject({this.name, this.color});

  final String name;
  final Color color;
}
