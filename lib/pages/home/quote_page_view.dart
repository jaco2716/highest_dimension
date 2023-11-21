import 'package:flutter/material.dart';
import 'package:highest_dimension/model/providers/firestore_data_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/style_config.dart';
import '../../model/quote.dart';

class QuotePageView extends StatefulWidget {
  const QuotePageView({super.key});

  @override
  State<QuotePageView> createState() => _QuotePageViewState();
}

class _QuotePageViewState extends State<QuotePageView> {
  final PageController _pageController = PageController();
  // late List<Quote> quotes;
  // @override
  // void initState() {
  //   quotes = context.read<FirestoreDataProvider>().quoteList ?? [];

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirestoreDataProvider>(builder: (context, value, _) {
      List<Quote> quotes = value.quoteList;

      return PageView.builder(
        // onPageChanged: (value) {},
        controller: _pageController,
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          DateFormat df = DateFormat('dd/MM');
          var date = df.format(DateTime.fromMillisecondsSinceEpoch(quotes[index].dateCreated));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                      stops: [0.0, 0.1, 0.8, 0.95],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20, width: double.infinity),
                        Text(
                          quotes[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Pacifico', color: primaryColor, fontSize: 35),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          quotes[index].message.replaceAll('\\n', '\n'),
                          style: const TextStyle(fontFamily: 'PlaypenSans', fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 70, child: Divider(height: 40)),
                        Text(
                          quotes[index].exercise.replaceAll('\\n', '\n'),
                          style: const TextStyle(fontFamily: 'PlaypenSans', fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 140),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filled(
                            iconSize: 30,
                            style: IconButton.styleFrom(backgroundColor: index > 0 ? Colors.white : Colors.white54, foregroundColor: primaryColor),
                            onPressed: () {
                              if (index > 0) {
                                _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              }
                            },
                            icon: const Icon(Icons.arrow_back_rounded)),
                        Text(
                          date,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        IconButton.filled(
                            iconSize: 30,
                            style: IconButton.styleFrom(
                                backgroundColor: index < quotes.length - 1 ? Colors.white : Colors.white54, foregroundColor: primaryColor),
                            onPressed: () {
                              if (index < quotes.length - 1) {
                                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_rounded)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
