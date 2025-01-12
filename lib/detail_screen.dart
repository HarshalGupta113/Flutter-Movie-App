import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests

class DetailScreen extends StatefulWidget {
  final dynamic movie;

  const DetailScreen({required this.movie, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<dynamic> _episodes = [];
  bool _isLoading = true;
  List<int> _seasons = [];
  int _selectedSeason = 1;

  @override
  void initState() {
    super.initState();
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.tvmaze.com/shows/${widget.movie['id']}/episodes'));
      if (response.statusCode == 200) {
        final episodes = json.decode(response.body);
        // Extract unique seasons
        final seasons = episodes
            .map<int>((episode) => episode['season'] as int)
            .toSet()
            .toList()
          ..sort();

        setState(() {
          _episodes = episodes;
          _seasons = seasons;
          _selectedSeason = seasons.isNotEmpty ? seasons.first : 1;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle non-200 status codes
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle errors like network issues
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEpisodes = _episodes
        .where((episode) => episode['season'] == _selectedSeason)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['name'] ?? 'Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.movie['image'] != null)
                Center(
                  child: Image.network(
                    widget.movie['image']['original'],
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
              const SizedBox(height: 16.0),
              Text(
                widget.movie['name'] ?? 'No Title',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                widget.movie['summary'] != null
                    ? _removeHtmlTags(widget.movie['summary'])
                    : 'No summary available.',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Divider(),
              const Text(
                'Episodes',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_seasons.isEmpty)
                const Text('No episodes available.')
              else ...[
                DropdownButton<int>(
                  value: _selectedSeason,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSeason = value;
                      });
                    }
                  },
                  items: _seasons
                      .map((season) => DropdownMenuItem<int>(
                            value: season,
                            child: Text('Season $season'),
                          ))
                      .toList(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredEpisodes.length,
                  itemBuilder: (context, index) {
                    final episode = filteredEpisodes[index];
                    return ListTile(
                      leading: episode['image'] != null
                          ? Image.network(
                              episode['image']['medium'],
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: const Icon(Icons.tv, color: Colors.white),
                            ),
                      title: Text(episode['name'] ?? 'No Title'),
                      subtitle: Text(
                          'Season ${episode['season']}, Episode ${episode['number']}'),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _removeHtmlTags(String htmlString) {
    return RegExp(r'<[^>]*>').allMatches(htmlString).fold(
        htmlString,
        (previousValue, match) =>
            previousValue.replaceAll(match.group(0)!, ''));
  }
}
