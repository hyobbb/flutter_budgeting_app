import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/widget/src/category_tag.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'dart:math';

final filteredCategory = StateProvider.autoDispose
    .family<List<Category>, String?>((ref, keyword) => ref
        .watch(categoryListCache.state)
        .where((e) => (keyword == null || keyword.isEmpty)
            ? true
            : e.name.contains(keyword))
        .toList());

class SearchCategory extends HookWidget {
  final Category? initialCategory;

  //optional callback on category removal
  final ValueChanged<Category>? deleteCallback;

  const SearchCategory({
    required this.initialCategory,
    this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    final category = useState<Category>(initialCategory ??
        Category(
          name: '',
          color: _generateColor(),
        ));
    final textController = useTextEditingController();
    final shouldUpdate = useState(false);
    useEffect(() {
      textController.text = category.value.name;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
      return null;
    }, [category.value]);
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0.0),
                  prefix: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    iconSize: 20,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (shouldUpdate.value) {
                        shouldUpdate.value = false;
                        category.value = category.value
                            .copyWith(name: '', color: _generateColor());
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  hintText: 'Enter a category name',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () => category.value = category.value
                        .copyWith(name: '', color: _generateColor()),
                    icon: Icon(Icons.cancel),
                  ),
                ),
                autofocus: true,
                maxLength: 20,
                style: TextStyle(fontSize: 20),
                textCapitalization: TextCapitalization.words,
                onChanged: (name) {
                  category.value = category.value.copyWith(name: name);
                },
                onFieldSubmitted: (_) => primaryFocus?.unfocus(),
              ),
              HookBuilder(
                builder: (_) {
                  final categories =
                      useProvider(filteredCategory(category.value.name));
                  if (!shouldUpdate.value) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: categories.state.length + 1,
                        itemBuilder: (_, index) {
                          if (index == categories.state.length) {
                            var idx = categories.state.indexWhere(
                                (cat) => category.value.name == cat.name);
                            if (idx == -1 && category.value.name.isNotEmpty) {
                              return Container(
                                height: 60,
                                child: ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fiber_new_outlined,
                                        color: Colors.orange,
                                      ),
                                      CategoryTag(category.value),
                                    ],
                                  ),
                                  onTap: () => shouldUpdate.value = true,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }

                          final cat = categories.state[index];
                          return Container(
                            height: 60,
                            child: ListTile(
                              leading: CategoryTag(
                                cat,
                                onTap: (cat) {
                                  Navigator.pop(context, cat);
                                },
                              ),
                              trailing: _CategoryOptionButton(
                                onDelete: () async {
                                  await context
                                      .read(categoryListCache)
                                      .remove(cat.id!);
                                  context
                                      .read(budgetListCache)
                                      .onCategoryDeleted(cat.id!);

                                  if (deleteCallback != null) {
                                    deleteCallback!(cat);
                                  }
                                  //then close pop up entry
                                  Navigator.pop(context);
                                },
                                onEdit: () async {
                                  category.value = cat;
                                  shouldUpdate.value = true;
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CategoryTag(
                          category.value,
                          onTap: (cat) => _onCreateOrUpdate(context, cat),
                        ),
                        const SizedBox(height: 20),
                        ColorPicker(
                          onChangeColor: (col) {
                            category.value =
                                category.value.copyWith(color: col.value);
                          },
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => category.value =
                              category.value.copyWith(color: _generateColor()),
                          child: Row(
                            children: [
                              Icon(Icons.color_lens, color: Colors.black),
                              const SizedBox(width: 10),
                              Text('Random Color Change', style:Theme.of(context).textTheme.button)
                            ],
                          ),
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

  int _generateColor() => (Random().nextDouble() * 0xFFFFFF).toInt();

  Widget _CategoryOptionButton({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              'Edit',
              style: Theme.of(context).textTheme.button,
            ),
            contentPadding: EdgeInsets.zero,
            onTap: onEdit,
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text(
              'Delete',
              style: Theme.of(context).textTheme.button,
            ),
            contentPadding: EdgeInsets.zero,
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content:
                    Text('This can affect to whole data using this category.'
                        ' Are you sure to delete this category?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onCreateOrUpdate(BuildContext context, Category? cat) async {
    if (cat != null && cat.name.isNotEmpty) {
      try {
        final newCategory = await context.read(categoryListCache).create(cat);
        Navigator.pop(context, newCategory);
      } catch (e, _) {
        await context.read(categoryListCache).update(cat);
        context.read(budgetListCache).onCategoryUpdated(cat);
        Navigator.pop(context, cat);
      }
    }
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
              onTap: () => widget.onChangeColor(Colors.white),
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
              onTap: () => widget.onChangeColor(Colors.black),
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
