import 'package:flutter/material.dart';

class MarketPriceCard extends StatelessWidget {
  final dynamic record;

  const MarketPriceCard({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record['Market']} Market (${record['State']})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Commodity: ${record['Commodity']} (${record['Variety']})'),
            Text('Date: ${record['Arrival_Date']}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Min: ₹${record['Min_Price']}'),
                Text('Max: ₹${record['Max_Price']}'),
                Text('Modal: ₹${record['Modal_Price']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
