import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/widget/src/category_tag.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';


final filteredCategory = StateProvider.autoDispose
    .family<List<Category>, String?>((ref, keyword) => ref
    .watch(categoryListCache.state)
    .where((e) => (keyword == null || keyword.isEmpty)
    ? true
    : e.name.contains(keyword))
    .toList());


class SearchCategory extends HookWidget {
  final ValueChanged<Category> onCreated;
  final ValueChanged<Category?> onSelected;
  final ValueChanged<Category> onDeleted;

  const SearchCategory({
    required this.onCreated,
    required this.onSelected,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final category = useState<Category>(Category(name: ''));
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0.0),
                  prefix: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    iconSize: 20,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  hintText: 'Enter a category name',
                  border: InputBorder.none,
                ),
                autofocus: true,
                style: TextStyle(fontSize: 20),
                onChanged: (name) {
                  category.value = category.value.copyWith(name: name);
                },
                onFieldSubmitted: (_) => primaryFocus?.unfocus(),
              ),
              HookBuilder(builder: (_) {
                final categories = useProvider(filteredCategory(category.value.name));
                if (categories.state.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: categories.state.length + 1,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return Container(
                              height: 60,
                              child: ListTile(
                                leading: CategoryTag(
                                  null,
                                  onTap: (cat) {
                                    onSelected(cat);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          }
                          final cat = categories.state[index - 1];
                          return Container(
                            height: 60,
                            child: ListTile(
                              leading: CategoryTag(
                                cat,
                                onTap: (cat) {
                                  onSelected(cat);
                                  Navigator.pop(context);
                                },
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    content: Text(
                                        'Are you sure to delete this category?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          onDeleted(cat);
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        CategoryTag(
                          category.value,
                          onTap: (cat) async {
                            if (cat != null && cat.name.isNotEmpty) {
                              onCreated(cat);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        ColorPicker(
                          onChangeColor: (col) {
                            category.value =
                                category.value.copyWith(color: col.value);
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ColorPicker extends StatefulWidget {
  final ValueChanged<Color> onChangeColor;

  const ColorPicker({required this.onChangeColor});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> _colors = [
    Color.fromARGB(153, 255, 0, 0),
    Color.fromARGB(153, 255, 128, 0),
    Color.fromARGB(153, 255, 255, 0),
    Color.fromARGB(153, 255, 255, 0),
    Color.fromARGB(153, 128, 255, 0),
    Color.fromARGB(153, 0, 255, 0),
    Color.fromARGB(153, 0, 255, 128),
    Color.fromARGB(153, 0, 255, 255),
    Color.fromARGB(153, 0, 128, 255),
    Color.fromARGB(153, 0, 0, 255),
    Color.fromARGB(153, 128, 0, 255),
    Color.fromARGB(153, 255, 0, 255),

    // Color.fromARGB(255, 255, 0, 0),
    // Color.fromARGB(255, 255, 128, 0),
    // Color.fromARGB(255, 255, 255, 0),
    // Color.fromARGB(255, 255, 255, 0),
    // Color.fromARGB(255, 128, 255, 0),
    // Color.fromARGB(255, 0, 255, 0),
    // Color.fromARGB(255, 0, 255, 128),
    // Color.fromARGB(255, 0, 255, 255),
    // Color.fromARGB(255, 0, 128, 255),
    // Color.fromARGB(255, 0, 0, 255),
    // Color.fromARGB(255, 128, 0, 255),
    // Color.fromARGB(255, 255, 0, 255),
    // Color.fromARGB(255, 255, 0, 128)
  ];

  double _width = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _colorChangeHandler(double position) {
    //handle out of bounds positions
    if (position > _width) {
      position = _width;
    }
    if (position < 0) {
      position = 0;
    }

    widget.onChangeColor(_calculateSelectedColor(position));
  }

  Color _calculateSelectedColor(double position) {
    //determine color
    double positionInColorArray = (position / _width * (_colors.length - 1));
    int index = positionInColorArray.truncate();
    double remainder = positionInColorArray - index;
    if (remainder == 0.0) {
      return _colors[index];
    } else {
      //calculate new color
      int redValue = _colors[index].red == _colors[index + 1].red
          ? _colors[index].red
          : (_colors[index].red +
          (_colors[index + 1].red - _colors[index].red) * remainder)
          .round();
      int greenValue = _colors[index].green == _colors[index + 1].green
          ? _colors[index].green
          : (_colors[index].green +
          (_colors[index + 1].green - _colors[index].green) * remainder)
          .round();
      int blueValue = _colors[index].blue == _colors[index + 1].blue
          ? _colors[index].blue
          : (_colors[index].blue +
          (_colors[index + 1].blue - _colors[index].blue) * remainder)
          .round();
      return Color.fromARGB(255, redValue, greenValue, blueValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            GestureDetector(
              onTap: ()=>widget.onChangeColor(Colors.white),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: LayoutBuilder(builder: (_, constraints) {
                  _width = constraints.maxWidth;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (DragStartDetails details) {
                      _colorChangeHandler(details.localPosition.dx);
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      _colorChangeHandler(details.localPosition.dx);
                    },
                    onTapDown: (TapDownDetails details) {
                      _colorChangeHandler(details.localPosition.dx);
                    },
                    //This outside padding makes it much easier to grab the   slider because the gesture detector has
                    // the extra padding to recognize gestures inside of
                    child: Container(
                      width: constraints.maxWidth,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        gradient: LinearGradient(colors: _colors),
                      ),
                    ),
                  );
                }),
              ),
            ),
            GestureDetector(
              onTap: ()=>widget.onChangeColor(Colors.black),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
