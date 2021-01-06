import 'package:flutter/cupertino.dart';

class ViewPage<T> extends StatefulWidget {
  ViewPage({
    Key key,
    this.children,
    this.data,
  })  : assert(children != null),
        assert(data != null),
        assert(children.length == data.length),
        super(
          key: key,
        );

  /// 数据展示
  final List<Widget> children;

  /// 列表数据
  final List<T> data;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController()..addListener(() {
      // 监听数值变化，页的变化。
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (_, index) => AnimatedBuilder(
        child: widget.children[index],
        animation: _controller,
        builder: (context, child) => _buildAnimOfItem(context, child, index),
      ),
    );
  }

  Widget _buildAnimOfItem(BuildContext context, Widget child, int index) {
    double value;
    if (_controller.position.haveDimensions) {
      value = _controller.page - index;
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
}
