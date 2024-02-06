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
  List<Article?> filteredNewsPosts = [];
  TextEditingController searchController = TextEditingController();

  void search(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredNewsPosts = newsPosts
            .where((article) =>
                article?.content?.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                article?.title?.toLowerCase().contains(query.toLowerCase()) ==
                    true)
            .toList();
      } else {
        filteredNewsPosts = List.from(newsPosts);
      }
    });
  }

  _getNews() async {
    final newsResponse = await NewsResource().getNewsResponse('flutter');
    setState(() {
      newsPosts = newsResponse.articles ?? [];
      filteredNewsPosts = List.from(newsPosts);
    });
  }

  @override
  void initState() {
    _getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App - For Flutter Devs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) => search(query),
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Enter keywords...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (filteredNewsPosts.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredNewsPosts.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final article = filteredNewsPosts[index];
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
            if (filteredNewsPosts.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(
                  child: Text(
                    'No news found! Try searching with different keywords.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
