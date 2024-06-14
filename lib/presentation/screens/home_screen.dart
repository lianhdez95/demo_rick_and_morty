// ignore_for_file: unused_local_variable
import 'package:animate_do/animate_do.dart';
import 'package:demo_rick_and_morty/core/utils/parsers.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_list_tile.dart';
import 'package:demo_rick_and_morty/presentation/widgets/error_screen.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/chack_connection.dart';
import '../../data/models/character_response_model.dart';
import '../providers/character_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Future<void>? _initialLoadFuture;
  bool isLoading = false;
  bool _showFab = false; // Define la variable isLoading

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      loadNextPage();
    }
  }

  Future loadNextPage() async {
    if (isLoading || !(await isConnected())) return;
    isLoading = true;
    setState(() {});
    try {
      await ref.read(characterListProvider.notifier).getNextPage();
      _scrollController.animateTo(
        _scrollController.offset + 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
      isLoading = false;
    } catch (e) {
      _scrollController.animateTo(0,
          duration: const Duration(seconds: 1), curve: Curves.easeOut);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay conexión a internet'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      _initialLoadFuture =
          ref.read(characterListProvider.notifier).loadInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener datos: $e'),
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    if (await isConnected()) {
      try {
        await ref
            .read(characterListProvider.notifier)
            .resetAndLoadInitialData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No hay conexión a internet'),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay conexión a internet'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final characters = ref.watch(characterListProvider);

    return FutureBuilder(
        future: _initialLoadFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorScreen(
                text: 'Error al obtener datos\nRevise su conexión a internet',
                redirectRoute: '/',
                buttonText: 'Reintentar',
                iconData: Icons.wifi_off);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: ZoomIn(
                child: const Center(
                  child: Loading(
                    sizePercent: 30,
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  title: Text('Rick & Morty Characters',
                      style: TextStyle(color: colors.primary)),
                  actions: [
                    IconButton(
                      onPressed: () {
                        //implementar búsqueda por nombre
                      },
                      icon: Icon(
                        Icons.search,
                        color: colors.primary,
                      ),
                    ),
                  ]),
              body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels > 0) {
                    if (!_showFab) {
                      setState(() {
                        _showFab = true;
                      });
                    }
                  } else {
                    if (_showFab) {
                      setState(() {
                        _showFab = false;
                      });
                    }
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: characters.length,
                        itemBuilder: (context, index) {
                          return FadeInUp(
                            duration: const Duration(milliseconds: 100),
                            child: CharacterListTile(
                              imageUrl: characters[index].image,
                              name: characters[index].name,
                              status: parseStatus(characters[index].status!),
                              species: parseSpecies(characters[index].species!),
                              onTap: () {
                                context
                                    .push('/character/${characters[index].id}');
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (isLoading)
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Loading(
                          sizePercent: 10,
                        ),
                      ),
                  ],
                ),
              ),
              floatingActionButton: _showFab
                  ? FloatingActionButton(
                      onPressed: () {
                        _scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 1500),
                        );
                      },
                      child: isLoading
                          ? SpinPerfect(
                              infinite: true,
                              child: const Icon(Icons.refresh),
                            )
                          : FadeIn(
                              child: const Icon(Icons.arrow_upward_rounded),
                            ),
                    )
                  : null,
            );
          }
        });
  }
}
