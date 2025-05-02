import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_task/model/quote_model.dart';

@immutable
abstract class QuoteState extends Equatable{
  const QuoteState();

  @override
  List<Object?> get props => [];
}

@immutable
class QuoteLoading extends QuoteState {}

@immutable
class QuoteLoaded extends QuoteState {
  final List<QuoteModel> quotes;
  const QuoteLoaded({
    required this.quotes,
  });
}

@immutable
class QuoteError extends QuoteState {}
