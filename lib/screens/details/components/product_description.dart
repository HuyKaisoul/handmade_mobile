import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/Popular_product.dart';
import 'package:shop_app/models/request.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.product,
    this.pressOnSeeMore,
    this.numline,
  }) : super(key: key);
  final Product product;
  final GestureTapCallback pressOnSeeMore;
  final int numline;

  @override
  _ProductDescriptionState createState() =>
      _ProductDescriptionState(product, pressOnSeeMore, numline);
}

class _ProductDescriptionState extends State<ProductDescription> {
  _ProductDescriptionState(this.product, this.pressOnSeeMore, this.numline);

  Product product;
  GestureTapCallback pressOnSeeMore;
  int numline;
  bool isShow = false;

  Future<bool> favoriteFuture;
  @override
  void initState() {
    super.initState();
    favoriteFuture = downloadFavorite(product.id);
    numline = 4;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text("discount".tr().toString() + ": " + checkdiscount()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text("price".tr().toString() + ": " + checkprice()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(
              "the remaining amount".tr().toString() +
                  ": " +
                  product.amount.toString(),
            ),
          ),
          FutureBuilder<bool>(
              future: favoriteFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    onTap: () {
                      downloadCheckFavorite(product.id, snapshot.data);
                      setState(() {
                        favoriteFuture = downloadFavorite(product.id);
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.all(getProportionateScreenWidth(15)),
                        width: getProportionateScreenWidth(64),
                        decoration: BoxDecoration(
                          color: snapshot.data
                              ? Color(0xFFFFE6E6)
                              : Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Heart Icon_2.svg",
                          color: snapshot.data
                              ? Color(0xFFFF4848)
                              : Color(0xFFDBDEE4),
                          height: getProportionateScreenWidth(16),
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64),
            ),
            child: Text(
              "describe".tr().toString() + ": \n" + product.description,
              maxLines: numline,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: 10,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isShow) {
                    numline = 4;
                    isShow = false;
                  } else {
                    numline = null;
                    isShow = true;
                  }
                });
              },
              child: Row(
                children: [
                  Text(
                    isShow
                        ? "hidden More".tr().toString()
                        : "see More".tr().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String checkdiscount() {
    if (product.discount != 0 &&
        product.lastday.difference(DateTime.now()).inDays > 1)
      return product.discount.toString() + " %";
    else
      return "no".tr().toString();
  }

  String checkprice() {
    if (product.discount != 0 &&
        product.lastday.difference(DateTime.now()).inDays > 1)
      return product.priceDiscount.toString();
    else
      return product.price.toString();
  }
}
