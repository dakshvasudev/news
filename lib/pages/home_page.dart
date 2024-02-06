import 'package:flutter/material.dart';
import 'package:news/pages/news_detail_screen.dart';
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
          title: const Text('News App - For Flutter Devs'),
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
                itemCount: newsPosts!.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final article = newsPosts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(
                            networkImage: article?.urlToImage,
                            heading: article?.title,
                            content: article?.content,
                            description: article?.description,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Card(
                          networkImage: article?.urlToImage,
                          heading: article?.title,
                          content: article?.description,
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
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

class Card extends StatelessWidget {
  const Card(
      {super.key,
      required this.networkImage,
      required this.heading,
      required this.content});

  final String? networkImage;
  final String? heading;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.transparent),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 6.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (networkImage != null)
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(72, 194, 220, 241),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.transparent),
                  image: DecorationImage(
                      image: NetworkImage(networkImage!), fit: BoxFit.cover),
                ),
              ),
            if (heading != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (content != null)
                      Text(
                        content!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
