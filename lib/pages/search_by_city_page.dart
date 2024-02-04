import 'package:d_view/d_view.dart';
import 'package:futsal_now_mobile/config/app_colors.dart';
import 'package:futsal_now_mobile/config/failure.dart';
import 'package:futsal_now_mobile/config/nav.dart';
import 'package:futsal_now_mobile/datasources/sport_arena_datasource.dart';
import 'package:futsal_now_mobile/models/sport_arena_model.dart';
import 'package:futsal_now_mobile/pages/detail_sport_arena_page.dart';
import 'package:futsal_now_mobile/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchByCityPage extends ConsumerStatefulWidget {
  const SearchByCityPage({super.key, required this.query});
  final String query;

  @override
  ConsumerState<SearchByCityPage> createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends ConsumerState<SearchByCityPage> {
  final editSearch = TextEditingController();

  execute() {
    SportArenaDatasource.search(editSearch.text).then((value) {
      setSearchStatus(ref, 'Loading');

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSearchStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSearchStatus(ref, 'Not Found');
              break;
            case ForbiddenFailure:
              setSearchStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setSearchStatus(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setSearchStatus(ref, 'Unauthorised');
              break;
            default:
              setSearchStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setSearchStatus(ref, 'Success');

          List data = result['data'];
          List<SportArenaModel> list = data.map((e) => SportArenaModel.fromJson(e)).toList();

          ref.read(searchListProvider.notifier).setData(list);
        },
      );
    });
  }

  @override
  void initState() {
    if (widget.query != '') {
      editSearch.text = widget.query;

      execute();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Text(
                'City: ',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  height: 1,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: editSearch,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(height: 1),
                  onSubmitted: (value) => execute(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: execute,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer(
        builder: (_, wiRef, __) {
          String status = wiRef.watch(searchStatusProvider);
          List<SportArenaModel> list = wiRef.watch(searchListProvider);

          if (status == '') return DView.nothing();

          if (status == 'Loading') return DView.loadingCircle();

          if (status == 'Success') {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                SportArenaModel sportArena = list[index];

                return ListTile(
                  onTap: () {
                    Nav.push(context, DetailSportArenaPage(sportArena: sportArena));
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    radius: 18,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(sportArena.name),
                  subtitle: Text("${sportArena.district}, ${sportArena.city}"),
                  trailing: const Icon(Icons.navigate_next),
                );
              },
            );
          }

          return DView.error(data: status);
        },
      ),
    );
  }
}
