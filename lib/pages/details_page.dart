import 'package:flutter/material.dart';
import 'package:futsal_booking_app/widgets/container_gallery.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../widgets/container_icon.dart';
import '../widgets/description_text.dart';
import '../widgets/my_button.dart';
import '../widgets/small_container.dart';
import '../widgets/small_icon.dart';
import 'booking_page.dart';

class DetailsPage extends StatelessWidget {
  final String name;
  final double price;
  final String location;
  final String imageUrl;
  final double? ratings;

  const DetailsPage({
    super.key,
    required this.name,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                imageSection(),
                detailSection(),
                galerySection(),
                MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingPage(),
                      ),
                    );
                  },
                  height: 45,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(
                    defaultMargin,
                    32,
                    defaultMargin,
                    defaultMargin,
                  ),
                  text: "Booking",
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: topBarSection(context),
            )
          ],
        ),
      ),
    );
  }

  Widget topBarSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 24,
      margin: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const ContainerIcon(
              imageUrl: "assets/icon_arrow.png",
              color: Colors.white,
            ),
          ),
          const ContainerIcon(
            imageUrl: "assets/icon_bookmark.png",
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget imageSection() {
    return Container(
      width: double.infinity,
      height: 374,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/image_futsal3.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
    );
  }

  Widget detailSection() {
    return Container(
      margin: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: blackTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      )),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SmallIcon(imageUrl: "assets/icon_location.png"),
                      const SizedBox(width: 3),
                      Text(
                        location,
                        style: lightTextStyle.copyWith(
                          fontSize: 10,
                          fontWeight: light,
                          color: const Color(0xFF424242),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const SmallIcon(imageUrl: "assets/icon_star.png"),
                  const SizedBox(width: 3),
                  Text(
                    ratings.toString(),
                    style: blackTextStyle.copyWith(
                      fontSize: 10,
                      fontWeight: medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // details Section
          Container(
            width: double.infinity,
            height: 53,
            margin: EdgeInsets.only(top: defaultMargin),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 9),
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DescriptionText(
                  title: "Field Type",
                  value: "6A Side",
                ),
                DescriptionText(
                  title: "Price/Hour",
                  value: NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rs. ',
                    decimalDigits: 0,
                  ).format(
                    price,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget galerySection() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: defaultMargin),
            const SmallContainer(
              imageUrl: "assets/icon_image.png",
              title: "Galeri",
              isActive: true,
            ),
            const SmallContainer(
              imageUrl: "assets/icon_chat.png",
              title: "Ulasan",
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: defaultMargin),
              const ContainerGallery(imageUrl: "assets/image_futsal1.png"),
              const ContainerGallery(imageUrl: "assets/image_gallery1.png"),
              const ContainerGallery(imageUrl: "assets/image_gallery2.png"),
            ],
          ),
        ),
      ],
    );
  }
}
