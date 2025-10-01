import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Day/Night Toggle",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: FadingTextAnimation(
        onToggleTheme: _toggleTheme,
        themeMode: _themeMode,
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const FadingTextAnimation({
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  bool _showFrame = false;
  Color _textColor = Colors.black;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  Future <void> _pickTextColor() async {
    final colors = <Color>[
      Colors.black,
      Colors.white,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick text color'),
          content: SizedBox(
            width: 300,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              children: colors.map((c) {
                final isSelected = c.value == _textColor.value;
                return InkWell(
                  onTap: () {
                    setState(() => _textColor = c);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(radius: 20, backgroundColor: c),
                      if (isSelected)
                        const Icon(Icons.check, color: Colors.white),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text Animation'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              duration: const Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: _showFrame
                    ? BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 350),
          SwitchListTile(
            title: const Text('Show Frame', textAlign: TextAlign.right),
            value: _showFrame,
            onChanged: (bool value) {
              setState(() {
                _showFrame = value;
              });
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: _pickTextColor,
              child: const Icon(Icons.color_lens),
            ),
            FloatingActionButton(
              onPressed: toggleVisibility,
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
