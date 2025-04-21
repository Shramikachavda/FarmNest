import 'package:agri_flutter/customs_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import '../customs_widgets/reusable.dart';

class HtmlViewerScreen extends StatelessWidget {
  final String title;
  final String assetPath;

  const HtmlViewerScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  Future<String> _loadHtml() async {
    return await rootBundle.loadString(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: FutureBuilder<String>(
        future: _loadHtml(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  showLoading(context);
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load document."));
          }
          return SingleChildScrollView(child: Html(data: snapshot.data));
        },
      ),
    );
  }
}
