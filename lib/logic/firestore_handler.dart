import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:highest_dimension/model/quote.dart';

enum DbCollection {
  quotes,
}

class FirestoreHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final quotesQuery = FirebaseFirestore.instance.collection(DbCollection.quotes.name).withConverter(
        fromFirestore: (snapshot, _) => Quote.fromJson(snapshot.data()!),
        toFirestore: (job, _) => job.toJson(),
      );

  Future<List<Quote>> getQuotes({int? limit}) async {
    QuerySnapshot<Quote> query;
    if (limit == null) {
      query = await quotesQuery.orderBy('dateCreated').get();
    } else {
      query = await quotesQuery.orderBy('dateCreated').limit(limit).get();
    }
    return query.docs.map((e) => e.data()).toList();
  }

  Future<List<Quote>> getMoreQuotes() async {
    var query = await quotesQuery.orderBy('date').limit(3).get();
    return query.docs.map((e) => e.data()).toList();
  }

  Future<bool> addQuote(Quote quote, void Function(String message) errorCallback) async {
    // int dateNow = DateTime.now().millisecondsSinceEpoch;
    // newQuote = Quote(
    //     title: "Test",
    //     message:
    //         "Test message Der er for få eller ingen kildehenvisninger i denne artikel, hvilket er et problem. Du kan hjælpe ved at angive troværdige kilder",
    //     exercise:
    //         "Der er for få eller ingen kildehenvisninger i denne artikel, hvilket er et problem. Du kan hjælpe ved at angive troværdige kilder til de påstande, som fremføres i artiklen. Lorem ipsum, også kendt som mumletekst, er en fyldtekst, som har været brugt i ",
    //     dateCreated: 0);
    // newQuote.dateCreated = dateNow;

    try {
      var ref = _firestore.collection(DbCollection.quotes.name).doc();
      quote.id = ref.id;
      await ref.set(quote.toJson());
      return true;
    } catch (e) {
      errorCallback(e.toString());
      // FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: 'Caught firestore error.');
    }
    return false;
  }

  Future<bool> deleteQuote(String id, void Function(String message) errorCallback) async {
    try {
      var ref = _firestore.collection(DbCollection.quotes.name).doc(id);
      ref.delete();
      return true;
    } catch (e) {
      errorCallback(e.toString());
    }
    return false;
  }
}
