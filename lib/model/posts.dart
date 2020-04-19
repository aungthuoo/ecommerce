import 'package:equatable/equatable.dart';
import './post.dart';

import 'category.dart';
import 'flash_post.dart';

class Posts extends Equatable {
  final List<Category> sliders;
  final List<Category> categories;
  final FlashPost flash_items;
  final List<Post> featured_items;
  final List<Post> items;

  Posts({this.sliders, this.categories, this.flash_items, this.featured_items, this.items});

  @override
  List<Object> get props => [sliders, categories, flash_items, items];

  Posts copyWith({List<Category> sliders, List<Category> categories, FlashPost flash_items,  List<Post> featured_items, List<Post> items}) {
    return Posts(
        sliders: sliders ?? this.sliders, categories: categories ?? this.categories, flash_items: flash_items ?? this.flash_items, featured_items: featured_items ?? this.featured_items, items: items ?? this.items);
  }
}
