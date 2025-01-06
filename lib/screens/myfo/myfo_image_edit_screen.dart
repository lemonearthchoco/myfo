import 'package:flutter/material.dart';

// 개발중
class MyfoImageEditScreen extends StatefulWidget {
  final String imageUrl;
  final String title;

  const MyfoImageEditScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  _MyfoImageEditScreenState createState() => _MyfoImageEditScreenState();
}

class _MyfoImageEditScreenState extends State<MyfoImageEditScreen> {
  Offset _tagPosition = Offset.zero; // 태그 위치 저장
  bool _isInitialized = false; // 초기 위치 설정 여부 확인

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTagPosition();
    });
  }

  void _initializeTagPosition() {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Size size = box.size;
    setState(() {
      _tagPosition = Offset(size.width / 2, size.height / 2); // 이미지 중앙
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 꾸미기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // 저장 후 뒤로 돌아가기
              Navigator.pop(context, _tagPosition);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              if (_isInitialized)
                Positioned(
                  left: _tagPosition.dx - 50, // 중앙 정렬
                  top: _tagPosition.dy - 60, // 중앙 정렬
                  child: DraggableTooltip(
                    position: _tagPosition,
                    text: widget.title,
                    onDragUpdate: (newPosition) {
                      setState(() {
                        _tagPosition = newPosition;
                      });
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

enum TooltipDirection { UP, DOWN, HORIZONTAL }

class DraggableTooltip extends StatefulWidget {
  final Offset position;
  final String text;
  final ValueChanged<Offset> onDragUpdate;

  const DraggableTooltip({
    Key? key,
    required this.position,
    required this.text,
    required this.onDragUpdate,
  }) : super(key: key);

  @override
  _DraggableTooltipState createState() => _DraggableTooltipState();
}

class _DraggableTooltipState extends State<DraggableTooltip> {
  late Offset position;
  TooltipDirection _direction = TooltipDirection.DOWN; // 기본 방향

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

  void _changeDirection() {
    setState(() {
      _direction = TooltipDirection.values[
      (_direction.index + 1) % TooltipDirection.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeDirection, // 탭하면 방향 변경
      onPanUpdate: (details) {
        setState(() {
          position += details.delta; // 드래그 위치 업데이트
        });
        widget.onDragUpdate(position);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(100, 40), // 툴팁 크기
            painter: TooltipPainter(direction: _direction),
          ),
          Positioned(
            top: _direction == TooltipDirection.DOWN ? 5 : null,
            bottom: _direction == TooltipDirection.UP ? 5 : null,
            left: _direction == TooltipDirection.HORIZONTAL ? 5 : null,
            right: _direction == TooltipDirection.HORIZONTAL ? 5 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TooltipPainter extends CustomPainter {
  final TooltipDirection direction;

  TooltipPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final Path path = Path();
    switch (direction) {
      case TooltipDirection.DOWN:
        path.moveTo(size.width / 2 - 10, size.height - 10);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width / 2 + 10, size.height - 10);
        break;
      case TooltipDirection.UP:
        path.moveTo(size.width / 2 - 10, 10);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width / 2 + 10, 10);
        break;
      case TooltipDirection.HORIZONTAL:
        break;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
