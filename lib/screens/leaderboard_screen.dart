import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finfit/services/auth_service.dart';
import 'package:finfit/services/firebase_service.dart';
import 'package:finfit/models/user_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _filter = 'all'; // 'all', 'team', 'friends'

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterChip('All', 'all'),
                if (user.teamId != null) _buildFilterChip('Team', 'team'),
                _buildFilterChip('Friends', 'friends'),
              ],
            ),
          ),
          Expanded(
            child: _filter == 'team' && user.teamId != null
                ? _buildTeamLeaderboard(user.teamId!)
                : _buildGlobalLeaderboard(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filter = value;
        });
      },
    );
  }

  Widget _buildGlobalLeaderboard() {
    final firebaseService = Provider.of<FirebaseService>(context);
    
    return StreamBuilder<List<UserModel>>(
      stream: firebaseService.getTopUsers(limit: 20),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;
        if (users.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final rank = index + 1;
            return _buildLeaderboardItem(user, rank);
          },
        );
      },
    );
  }

  Widget _buildTeamLeaderboard(String teamId) {
    final firebaseService = Provider.of<FirebaseService>(context);
    
    return StreamBuilder<List<UserModel>>(
      stream: firebaseService.getUsersByTeam(teamId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!
          ..sort((a, b) => b.currentFinScore.compareTo(a.currentFinScore));

        if (users.isEmpty) {
          return const Center(
            child: Text('No team members found'),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final rank = index + 1;
            return _buildLeaderboardItem(user, rank);
          },
        );
      },
    );
  }

  Widget _buildLeaderboardItem(UserModel user, int rank) {
    final authService = Provider.of<AuthService>(context);
    final isCurrentUser = authService.currentUser?.id == user.id;

    Color rankColor;
    IconData rankIcon;
    if (rank == 1) {
      rankColor = Colors.amber;
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey.shade400;
      rankIcon = Icons.emoji_events;
    } else if (rank == 3) {
      rankColor = Colors.brown.shade300;
      rankIcon = Icons.emoji_events;
    } else {
      rankColor = Colors.grey;
      rankIcon = Icons.circle;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isCurrentUser ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rankColor,
          child: rank <= 3
              ? Icon(rankIcon, color: Colors.white)
              : Text(
                  rank.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          user.teamName ?? 'No team',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              user.currentFinScore.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'FinScore',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

