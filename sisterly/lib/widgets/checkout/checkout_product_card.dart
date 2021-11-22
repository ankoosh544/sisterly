import 'package:flutter/material.dart';
import 'package:sisterly/utils/constants.dart';

class CheckoutProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Image.asset("assets/images/product.png", height: 76,),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Chain-Cassette Bottega",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Constants.TEXT_COLOR,
                      fontFamily: Constants.FONT,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "€30 per day",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontSize: 18,
                      fontFamily: Constants.FONT,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ]
              ),
            ),
          )
        ]
      )
    );
  }
}
