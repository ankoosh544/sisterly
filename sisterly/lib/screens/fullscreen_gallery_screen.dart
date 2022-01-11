import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisterly/utils/constants.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FullscreenGalleryScreen extends StatefulWidget {

  final List<String> images;

  const FullscreenGalleryScreen({Key? key, required this.images}) : super(key: key);

  @override
  FullscreenGalleryScreenState createState() => FullscreenGalleryScreenState();
}

class FullscreenGalleryScreenState extends State<FullscreenGalleryScreen>  {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
      ),
      body: Column(
        children: [
          Expanded(child: CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: (widget.images[itemIndex].isNotEmpty ? widget.images[itemIndex] : ""),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => SvgPicture.asset("assets/images/placeholder_product.svg"),
                ),
            options: CarouselOptions(

              initialPage: 0
            ),
          ))
        ],
      ),
    );
  }
}
