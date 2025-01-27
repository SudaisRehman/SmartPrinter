import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerLoading({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Media Placeholder
              // Row(
              //   children: [
              //     Container(
              //       height: height * 0.2, // 60% height for the image/media
              //       width: width*0.15,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     SizedBox(width: width * 0.01),
              //     Column(
              //       children: [
              //         Container(
              //           height: height * 0.1, // 60% height for the image/media
              //           width: width*0.7,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         SizedBox(height: height * 0.01),
              //         Container(
              //           height: height * 0.1, // 60% height for the image/media
              //           width: width*0.75,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              SizedBox(height: height * 0.01),

              // Title Placeholder

              // Description Placeholder
              Container(
                height: height * 0.8, // 10% height for description
                width: width, // 80% width for description
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: height * 0.015),

              // // Button Placeholder
              // Container(
              //   height: height * 0.1, // 10% height for button
              //   width: width ,   // 30% width for button
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),

              // SizedBox(height: height * 0.015),
              // Container(
              //   height: height * 0.1, // 10% height for button
              //   width: width*0.7 ,   // 30% width for button
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
              // SizedBox(height: height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerLoadingBanner extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerLoadingBanner({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Media Placeholder
              // Row(
              //   children: [
              //     Container(
              //       height: height * 0.2, // 60% height for the image/media
              //       width: width*0.15,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     SizedBox(width: width * 0.01),
              //     Column(
              //       children: [
              //         Container(
              //           height: height * 0.1, // 60% height for the image/media
              //           width: width*0.7,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         SizedBox(height: height * 0.01),
              //         Container(
              //           height: height * 0.1, // 60% height for the image/media
              //           width: width*0.75,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(height: height * 0.01),

              // Title Placeholder

              // Description Placeholder
              Container(
                height: height * 0.8, // 10% height for description
                width: width, // 80% width for description
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: height * 0.01),

              // Button Placeholder
              // Container(
              //   height: height * 0.2, // 10% height for button
              //   width: width ,   // 30% width for button
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
