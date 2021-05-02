import 'package:budgeting/src/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryTag extends HookWidget {
  final Category? category;
  final ValueChanged<Category?>? onTap;

  const CategoryTag(this.category, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: InkWell(
        onTap: (){
          if(onTap!=null){
            onTap!(category);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(category?.color ?? 0xFFFFFFFF).withOpacity(0.6),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 2, color: Colors.black.withOpacity(0.1))
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Text(category?.name ?? 'etc',
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
