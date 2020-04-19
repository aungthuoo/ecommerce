
import 'package:ecommerce/model/flash_post.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import './res/assets.dart' as assets;
import 'package:http/http.dart' as http;
import 'bloc/post_bloc.dart';
import 'detail.dart';
import 'model/category.dart';
import 'model/post.dart';
import 'widgets/network_image.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {


  @override
    Widget build(BuildContext context) {
      return MaterialApp(
      title: 'eCommerce',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.orange[800],
        accentColor: Colors.orange[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home:  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('eCommerce'),
          elevation: 0,
        ),
        /*
        body: SafeArea(
          child: ListView.builder(
            itemBuilder: _buildListView,
            itemCount: 10,
          )
        ),
        */
        body: BlocProvider(
          create: (context) =>
              PostBloc(httpClient: http.Client())..add(FetchPostsEvent(1)),
          child: HomePage(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('Messages')),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('Cart')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Account')),
          ],
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.orange,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
      
    }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formatter = new NumberFormat("#,###");
  static final String path = "lib/src/pages/ecommerce/ecommerce1.dart";
  final List<String> categories = ['DarazMall', 'Flash Sales', 'Collection', 'Vouchers', 'Categories'];
  final List<String> images = [assets.images[0],assets.images[2],assets.images[1], assets.images[3]];
  final List<String> flashSaleImages = [assets.backgroundImages[0],assets.backgroundImages[2],assets.backgroundImages[1]];


  @override
  void initState() {
    super.initState();
  }

/*
  Widget _buildListView(_,index) {
    if(index==0) return _buildSlider();
    if(index==1) return _buildCategoriesGrid();
    if(index==2) return _buildFlashSales();
    if(index==3) return _buildPopular();
    if(index==4) return Center(child: Text('Just for You', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                PNetworkImage(images[index%images.length]),
                SizedBox(height: 10.0,),
                Text('Top Quality fashion item', softWrap: true,),
                SizedBox(height: 10.0,),
                Text('Ks.1,254', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red),)
              ],
            ),
          ),
          SizedBox(width: 10.0,),
          Expanded(
            child: Column(
              children: <Widget>[
                PNetworkImage(images[(index - 1) %images.length]),
                SizedBox(height: 10.0,),
                Text('Top Quality fashion item', softWrap: true,),
                SizedBox(height: 10.0,),
                Text('Ks.1,254', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red),)
              ],
            ),
          ),
        ],
      ),
    );
  }

*/
  Widget _buildPopular(List<Post> featuredItems) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 100;
    final double itemWidth = size.width / 2;



    List<Widget> widgets = new List<Widget>(); 

    
    for(var i = 0 ; i < featuredItems.length; i++){
      widgets.add(
        Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border(left: BorderSide(
                        color: Colors.orange.shade400,
                        style: BorderStyle.solid,
                        width: 5
                      ))
                    ),
                    child: ListTile(
                      onTap: (){},
                      title: Text("${featuredItems[i].name}"),
                      subtitle: Text('Ks.${ formatter.format(featuredItems[i].price)}'),
                      trailing: Container(width: 50, child: PNetworkImage(featuredItems[i].image, fit: BoxFit.cover,)),
                    ),
                  ),
                )
              ],
            ),
          )
      ); 
    }
    return SliverGrid.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      children: widgets,
    );

  }

  Widget _buildFlashSales(FlashPost flashItem) {
    return Container(
      height: 230,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top : 4.0, left:4.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Text('${flashItem.caption}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                    SizedBox(width: 10.0,),
                    Container(
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      child: Text('${flashItem.hour}', style: TextStyle(color: Colors.white), )
                    ),
                    SizedBox(width: 5.0,),
                    Container(
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      child: Text('${flashItem.minute}', style: TextStyle(color: Colors.white), )
                    ),
                    SizedBox(width: 5.0,),
                    Container(
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                      child: Text('${flashItem.second}', style: TextStyle(color: Colors.white), )
                    ),
                  ],
                ),
              ),
              Text('SHOP MORE >>', style: TextStyle(color: Colors.red),)
            ],
          ),
          //SizedBox(height: 10,),
          SizedBox(
            height: 170,
            child: ListView.builder(
                itemExtent: (MediaQuery.of(context).size.width / 3),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 0, right: 0, bottom: 5, left: 0),
                          child: GestureDetector(
                            onTap: () {
                              
                            },
                            child: Container(
                              height: 170,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0, right: 0, bottom: 0, left: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: const Radius.circular(5.0),
                                        topRight: const Radius.circular(5.0),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${flashItem.items[index].image}",
                                        placeholder: (context, url) => Container(
                                          height: 90,
                                          width: double.infinity,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/app-icon.png",
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: double.infinity,
                                        ),
                                        fit: BoxFit.fitWidth,
                                        height: 90,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              flashItem.items[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                itemCount: flashItem.items.length),
          ),
          /*
          Row(
            children: <Widget>[
              _buildFlashSaleItem(0),
              _buildFlashSaleItem(1),
              _buildFlashSaleItem(2),
            ],
          )
          */
        ],
      ),
    );
  }

  Expanded _buildFlashSaleItem(int index) {
    return Expanded(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      // color: Colors.blue,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: CachedNetworkImageProvider(flashSaleImages[index]),fit: BoxFit.cover)
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: StadiumBorder(side: BorderSide(width: 1, style: BorderStyle.solid,color: Colors.red))
                          ),
                          child: Container(
                            height: 20,
                            color: Colors.red.shade200,
                          ),
                        ),
                        ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: StadiumBorder(side: BorderSide(width: 1, style: BorderStyle.solid,color: Colors.red))
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            height: 20,
                            width: 70,
                            color: Colors.red,
                            child: Text('12 Sold', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Text('Ks.275')
                  ],
                ),
              ),
            );
  }

  Widget _buildSlider(List<Category> items) {
    return Container(
      height: 120.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              height: 110,
              color: Colors.orange,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Swiper(
              autoplay: true,
              itemBuilder: (BuildContext context,int index){
                return new PNetworkImage(items[index].image,fit: BoxFit.cover,);
              },
              itemCount: items.length,
              pagination: new SwiperPagination(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAllItems(List<Post> items){
    
    var size = MediaQuery.of(context).size;
    final double itemHeight = 200;
    final double itemWidth = size.width / 2;



    List<Widget> widgets = new List<Widget>(); 
    for(var i = 0 ; i < items.length; i++){
      widgets.add(
        /*
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              PNetworkImage(items[i].image),
              SizedBox(height: 10.0,),
              Text('Top Quality fashion item', softWrap: true,),
              SizedBox(height: 10.0,),
              Text('Ks.1,254', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.red),)
            ],
          ),
        ),
        */
        Container(
          height: 200,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                top: 0, right: 0, bottom: 0, left: 0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetail(),
                            )),
              child: Card(
                elevation: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${items[i].image}",
                        placeholder: (context, url) => Container(
                          height: 110,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset(
                          "assets/app-icon.png",
                          fit: BoxFit.fitWidth,
                          height: 110,
                          width: double.infinity,
                        ),
                        fit: BoxFit.fitWidth,
                        height: 110,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                           MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            items[i].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                              'Ks ${formatter.format( items[i].price) }',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.orange
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ); 
    }
    return SliverGrid.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      children: widgets,
    );
  }
  Widget _buildCategoryIcon(String icon ){
    if(icon == 'dirves')
      return Icon(Icons.phonelink,color: Colors.white,); 
    else if(icon == 'weekend')
      return Icon(Icons.weekend,color: Colors.white,); 
    
    else if(icon == 'local_hospital')
      return Icon(Icons.local_hospital,color: Colors.white,); 
    else if(icon == 'directions_walk')
      return Icon(Icons.directions_walk,color: Colors.white,); 
    else if(icon == 'pregnant_woman')
      return Icon(Icons.pregnant_woman,color: Colors.white,); 
    else 
      return Icon(Icons.drive_eta,color: Colors.white,); 

  }

  Widget _buildCategoriesGrid(List<Category> categories) {
    return Container(
      height: 125.0,
      child: GridView.builder(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10.0,

        ),
        itemBuilder: (_, int index){
          return GestureDetector(
            onTap: ()=>print(categories[index]),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  maxRadius: 30.0,
                  child: _buildCategoryIcon(categories[index].icon),
                ),
                SizedBox(height: 8.0,),
                Text(categories[index].name, 
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ))
              ],
            ),
          );
        },
        itemCount: categories.length,

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostError) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is PostLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PostsLoaded) {
          return Container(
            child: CustomScrollView(
              slivers: <Widget>[
                //_buildSlider(state.items.sliders),
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildSlider(state.items.sliders),
                      ]
                    ),
                ),
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildCategoriesGrid(state.items.categories),
                      ]
                    ),
                ),
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                        _buildFlashSales(state.items.flash_items),
                      ]
                    ),
                ),
                
                SliverToBoxAdapter(
                    child: Center(child: Text('Popular Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),)),
                ),
                
                _buildPopular(state.items.featured_items),
                
                SliverToBoxAdapter(
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(top : 20.0, bottom: 15.0),
                      child: Text('Just for You', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),),
                    )),
                ),
                _buildAllItems(state.items.items),
                
              ],
            ),
          );

          /*
          if (state.item.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          
          return ListView.builder(
            itemBuilder: _buildListView,
            itemCount: 10,
          );
          */
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}