import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user/widgets/dashboard_app_notice.dart';
import 'package:user/widgets/dashboard_screen_heading.dart';

class DashboardLoadingView extends StatelessWidget {

  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardAppNotice(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16,
            ),
            child: DashboardScreenHeading(),
          ),
          _bannerShimmer(context),
          SizedBox(),
          _shimmer1(),
          _shimmer2(context),
          SizedBox(),
          _shimmer2(context),
          _bannerShimmer(context),
          SizedBox(),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: SizedBox(),
          ),
          _shimmer2(context),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: SizedBox(),
          ),
          _shimmer2(context),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: SizedBox(),
          ),
          _shimmer3(),
        ],
      ),
    );
  }

  _shimmer1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          height: 130,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SizedBox(width: 90, child: Card()),
                );
              }),
        ),
      ),
    );
  }

  _shimmer2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 264 / 796 - 20,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 220 / 411,
                        child: Card()),
                  );
                }),
          )),
    );
  }

  _shimmer3() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: 100 * MediaQuery.of(context).size.height / 830,
                    width: MediaQuery.of(context).size.width,
                    child: Card());
              })),
    );
  }

  Widget _bannerShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Card(),
          ),
        ],
      ),
    );
  }
}
