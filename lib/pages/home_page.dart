import 'package:flutter/material.dart';
import 'package:news/services/news/models.dart';
import 'package:news/services/news/news_resource.dart';

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  List<Article?> newsPosts = [];

  List<String> searchResults = [];

  // void search(String query) {
  //   setState(() {
  //     searchResults = newsPosts
  //         .where((post) => post.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  _getNews() async {
    final newsResource = NewsResource();
    final newsResponse = await newsResource.getNewsResponse('flutter');
    setState(() {
      newsPosts = newsResponse.articles ?? [];
    });
  }

  @override
  void initState() {
    _getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                // onChanged: (query) => search(query),
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Enter keywords...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
