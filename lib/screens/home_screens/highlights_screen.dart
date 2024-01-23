import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import 'package:vivah_ai/models/blessing.dart';
import 'package:vivah_ai/models/ceremony.dart';
import 'package:vivah_ai/models/photo.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';

class StoryScreen extends StatefulWidget {
  final String filter;
  const StoryScreen({super.key, required this.filter});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child){
        if (storyItems.isNotEmpty) {
          return SafeArea(
            child: Scaffold(
              body: StoryView(
                storyItems: storyItems,
                controller: controller,
                repeat: false,
                onStoryShow: (storyItem) {},
                onComplete: () {
                  Navigator.pop(context);
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
                indicatorColor: const Color(0xFF33201C),
                indicatorForegroundColor: const Color(0xFFFFD384),
              ),
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  color: Colors.white,
                )),
          );
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
      _getHighlightsList();
    });
  }

  late MainViewModel model;
  final controller = StoryController();
  List<StoryItem> storyItems = [];

  Future<List<StoryItem>?> _getHighlightsList() async {
    storyItems.clear();
    try {
      if (widget.filter == 'blessings') {
        for(BlessingItem item in model.blessingList){
          setState(() {
            storyItems.add(StoryItem.pageVideo(
              item.video,
              caption: 'Uploaded by: ${item.name}',
              duration: Duration(seconds: item.duration.toInt()),
              controller: controller,
            ));
          });
        }
      } else if (widget.filter == 'photos') {
        for (PhotoItem item in model.photoList) {
          setState(() {
            storyItems.add(StoryItem(
              StoryWidget(image: item.image, text: '${item.name} in ${item.category}', isCouple: model.isCouple),
                duration: const Duration(seconds: 3)));
          });
        }
      } else if (widget.filter == 'others') {
        for (Ceremony item in model.ceremonyList) {
          setState(() {
            storyItems.add(StoryItem(
                StoryWidgetOthers(image: item.url, text: '${item.title} on ${item.date}'),
                duration: const Duration(seconds: 3)));
          });
        }
      }
      return storyItems;
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return null;
    }
  }
}

class StoryWidget extends StatelessWidget {
  final String image;
  final String text;
  final bool isCouple;
  const StoryWidget({super.key, required this.image, required this.text, required this.isCouple});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.network(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          (loadingProgress
                              .expectedTotalBytes ??
                              1)
                          : null,
                    ),
                  );
                }
              },
            ),
            Positioned(
              left: 5,
              top: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Text(text),
              ),
            ),
            if (isCouple) Positioned(right: 5, top: 10,child: IconButton(onPressed: (){
              //TODO - deleteMemory();
            }, icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFF33201C),
            ),),)
          ],
        ),
      ),
    );
  }
}

class StoryWidgetOthers extends StatelessWidget {
  final String image;
  final String text;
  const StoryWidgetOthers({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.network(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          (loadingProgress
                              .expectedTotalBytes ??
                              1)
                          : null,
                    ),
                  );
                }
              },
            ),
            Positioned(
              left: 5,
              top: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

