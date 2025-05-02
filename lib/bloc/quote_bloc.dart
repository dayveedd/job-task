import 'package:bloc/bloc.dart';
import 'package:job_task/bloc/quote_event.dart';
import 'package:job_task/bloc/quote_state.dart';
import 'package:job_task/services/get_all_quotes.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository repository;

  QuoteBloc({required this.repository}) : super(QuoteLoading()) {
    on<FetchQuotes>(
      (event, emit) async {
        emit(
          QuoteLoading(),
        );
        try {
          final quotes = await repository.getAllQuotes();
          emit(
            QuoteLoaded(
              quotes: quotes,
            ),
          );
        } catch (e) {
          emit(
            QuoteError(),
          );
        }
      },
    );
  }
}
