import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: databaseService
                  .getTransactions(authService.user!.uid)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(child: Text("No transactions found."));
                }

                // Mendapatkan data dari snapshot
                final Map<String, dynamic> data = Map<String, dynamic>.from(
                    snapshot.data!.snapshot.value as Map);
                final transactions = data.values.toList();

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction =
                        Map<String, dynamic>.from(transactions[index]);
                    return ListTile(
                      title:
                          Text(transaction["description"] ?? "No Description"),
                      subtitle: Text("Amount: ${transaction["amount"] ?? 0}"),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await databaseService.addTransaction(authService.user!.uid, {
                  "description": "Sample Transaction",
                  "amount": 100,
                });
              },
              child: const Text("Add Transaction"),
            ),
          ),
        ],
      ),
    );
  }
}
