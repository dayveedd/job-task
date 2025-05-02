import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_task/bloc/quote_bloc.dart';
import 'package:job_task/bloc/quote_event.dart';
import 'package:job_task/bloc/quote_state.dart';
import 'package:job_task/screens/error_page.dart';
import 'package:job_task/services/get_all_quotes.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    // creating an instance of the dio
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.quotable.io',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    )
      ..httpClientAdapter = DefaultHttpClientAdapter()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.next(options);
          },
          onError: (DioException e, handler) {
            print('Dio Error: ${e.message}');
            return handler.next(e);
          },
        ),
      );

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return BlocProvider(
      create: (_) =>
          QuoteBloc(repository: QuoteRepository(dio))..add(FetchQuotes()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'data page',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Color(0xFF4866D2),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, quoteState) {
            if (quoteState is QuoteLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (quoteState is QuoteError) {
              // show a blank screen with a refresh button
              return ErrorPage();
            } else if (quoteState is QuoteLoaded) {
              final quotes = quoteState.quotes;

              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<QuoteBloc>().add(FetchQuotes());
                  },
                  child: ListView.builder(
                    itemCount: quotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final quote = quotes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(
                              quote.content,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '-${quote.author}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
