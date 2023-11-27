import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/providers/app_data_provider.dart';
import '../model/quote.dart';
import '../widgets/my_elevated_button.dart';
import '../widgets/my_info_dialog.dart';
import 'add_quote_page.dart';

class ManageQuotesPage extends StatefulWidget {
  const ManageQuotesPage({super.key});

  @override
  State<ManageQuotesPage> createState() => _ManageQuotesPageState();
}

class _ManageQuotesPageState extends State<ManageQuotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Consumer<AppDataProvider>(builder: (context, value, _) {
          List<Quote> quotes = value.quoteList;
          return Column(children: [
            MyElevatedButton(
                title: 'Add Quote',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddQuotesPage(),
                      ));
                }),
            const SizedBox(height: 20),
            Text('Quotes: ${quotes.length}'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  DateFormat df = DateFormat('dd/MM');
                  var date = df.format(DateTime.fromMillisecondsSinceEpoch(quotes[index].dateCreated));
                  return Card(
                      elevation: 0.2,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: ListTile(
                        title: Text(quotes[index].title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                        subtitle: Text(quotes[index].message,
                            maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(date, style: const TextStyle(fontSize: 10, height: 0.8)),
                            IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MyInfoDialog(
                                        title: quotes[index].title,
                                        action: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                                              child: const Text('Delete'),
                                              onPressed: () => deleteQuote(quotes[index].id),
                                            ),
                                          ],
                                        ),
                                        child: const Text("Are you sure you want to delete?"),
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ));
                },
              ),
            ),
          ]);
        }),
      ),
    );
  }

  void deleteQuote(String id) async {
    var result = await context.read<AppDataProvider>().deleteQuote(id, (message) {
      showDialog(
        context: context,
        builder: (context) {
          return MyInfoDialog(child: Text("Could not delete quote. Error: $message"));
        },
      );
    });
    if (result && mounted) {
      Navigator.pop(context);
    }
  }
}
