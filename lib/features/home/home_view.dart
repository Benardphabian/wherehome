import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wherehome/common/controllers/http_controller.dart';
import 'package:wherehome/common/providers/user_provider.dart';
import 'package:wherehome/common/widgets/dialog_error.dart';
import 'package:wherehome/data/repositories/home_repo.dart';
import 'package:wherehome/features/favourite_home/favourite_view.dart';
import 'package:wherehome/features/map_view/map_view.dart';
import 'package:wherehome/features/profile/profile_view.dart';
import '../profile/widgets/homeowner_profile.dart';
import 'widgets/home_resizable.dart';
import 'widgets/search_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  bool isGrid = true;
  List<Home> homes = [];

  final List<Map<String, dynamic>> filterOptions = [
    {'label': 'New', 'icon': Icons.new_releases, 'color': Color.fromARGB(255, 2, 39, 56)},
    {'label': 'Popular', 'icon': Icons.star, 'color': Color.fromARGB(255, 2, 39, 56)},
    {'label': 'Cheap', 'icon': Icons.attach_money, 'color': Color.fromARGB(255, 2, 39, 56)},
    {'label': 'Luxury', 'icon': Icons.diamond, 'color': Color.fromARGB(255, 2, 39, 56)},
    {'label': 'Nearby', 'icon': Icons.location_on, 'color': Color.fromARGB(255, 2, 39, 56)},
  ];

  void toggleToGrid() {
    setState(() {
      isGrid = true;
    });
  }

  void toggleToList() {
    setState(() {
      isGrid = false;
    });
  }

  @override
  void didChangeDependencies() {
    fetchHomes(null);
    super.didChangeDependencies();
  }

  void fetchHomes(String? query) {
    final api = HttpController();
    String endpoint = 'homes';
    if (query != null) {
      endpoint += '?filter=$query';
    }
    api.sendGetRequest(endpoint, null, (onSuccess) {
      final jsonResponse = jsonDecode(onSuccess.body) as List<dynamic>;
      final List<Home> fetchedHomes = Home.toListFromJson(jsonResponse);
      setState(() {
        homes = fetchedHomes;
      });
    }, (onFail) {
      showErrorDialog(context, onFail.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RenTIFY',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchHomeWidget(
              onSearch: (String query) {
                setState(() {
                  fetchHomes('search=$query');
                });
              },
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 50.0,
              enlargeCenterPage: true,
              autoPlay: false,
              aspectRatio: 16 / 9,
              enableInfiniteScroll: true,
              viewportFraction: 0.3,
            ),
            items: filterOptions.map((filter) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [filter['color'], filter['color'].withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: filter['color'].withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(filter['icon'], color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        filter['label'],
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: HomesGrid(isGrid: isGrid, homes: homes),
          ),
        ],
      ),
      floatingActionButton: userProvider.isUserAuthenticated
          ? FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              splashColor: Colors.blue[200],
              hoverColor: Colors.blue[300],
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/home/insert_new_home');
                if (result == 'home_added') {
                  fetchHomes(null);
                }
              },
              elevation: 5,
              tooltip: 'Add home',
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: BottomAppBar(
        elevation: 12,
        color: Colors.blueAccent,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                if (userProvider.isUserAuthenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteView(favoriteHomes: [])),
                  );
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapView(homes: homes)),
                );
              },
              icon: const Icon(Icons.map, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                if (userProvider.isUserAuthenticated) {
                  Navigator.pushNamed(context, '/profile');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


// Define HomesGrid widget
class HomesGrid extends StatelessWidget {
  final bool isGrid;
  final List<Home> homes;

  const HomesGrid({super.key, required this.isGrid, required this.homes});

  @override
  Widget build(BuildContext context) {
    const gridItemHeight = 300.0;
    return isGrid
        ? GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: gridItemHeight,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.62,
            ),
            itemCount: homes.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: HomeWidget(
                  homeDataSet: homes[index],
                  elementHeight: gridItemHeight.toInt(),
                  imageHeight: 50,
                ),
              );
            },
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: homes.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: HomeWidget(
                  homeDataSet: homes[index],
                  elementHeight: 375,
                  imageHeight: 175,
                ),
              );
            },
          );
  }
}