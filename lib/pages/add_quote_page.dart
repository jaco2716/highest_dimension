import 'package:flutter/material.dart';
import 'package:highest_dimension/model/providers/app_data_provider.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';
import '../widgets/my_elevated_button.dart';
import '../widgets/my_info_dialog.dart';

class AddQuotesPage extends StatefulWidget {
  const AddQuotesPage({super.key});

  @override
  State<AddQuotesPage> createState() => _AddQuotesPageState();
}

class _AddQuotesPageState extends State<AddQuotesPage> {
  late Quote newQuote;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    newQuote = Quote(id: '', title: '', message: '', exercise: '', dateCreated: DateTime.now().millisecondsSinceEpoch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quote'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(children: [
              // TextFormField(),
              const Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                // initialValue: hotel.name,
                // validator: validateString,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onSaved: (newValue) => newQuote.title = newValue!,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              ),
              const Text('Message', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                // initialValue: hotel.name,
                // validator: validateString,
                minLines: 3,
                maxLines: 10,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onSaved: (newValue) => newQuote.message = newValue!,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              ),
              const Text('Exercise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                // initialValue: hotel.name,
                // validator: validateString,
                minLines: 3,
                maxLines: 10,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onSaved: (newValue) => newQuote.exercise = newValue!,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              ),
              const SizedBox(height: 20),
              MyElevatedButton(
                  title: 'Save',
                  onPressed: () async {
                    _formKey.currentState!.save();

                    bool result = await context.read<AppDataProvider>().addQuote(newQuote, (message) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MyInfoDialog(child: Text("Could not add quote. Error: $message"));
                        },
                      );
                    });

                    if (result && mounted) {
                      Navigator.pop(context);
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }
}
