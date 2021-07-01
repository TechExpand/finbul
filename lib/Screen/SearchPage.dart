
import 'package:fin_bul/Screen/Detail2.dart';
import 'package:fin_bul/Screen/Details.dart';
import 'package:fin_bul/Service/Network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'SeacrhDetail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  var searchvalue;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xFF372C6A),
      appBar: AppBar(
        backgroundColor: Color(0xFF372C6A),
        title: Text('Search for tickers',
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Hero(
            tag: 'searchButton',
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 12),
              margin: const EdgeInsets.only(
                  bottom: 15, left: 12, right: 12, top: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  border: Border.all(color: Color(0xFFF1F1FD)),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      FeatherIcons.search,
                      color: Color(0xFF555555),
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF270F33),
                          fontWeight: FontWeight.w600),
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          searchvalue = value;
                          SearchResult(searchvalue);
                        });
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type in a ticker name',
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        focusColor: Color(0xFF2B1137),
                        fillColor: Color(0xFF2B1137),
                        hoverColor: Color(0xFF2B1137),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SearchResult(searchvalue),
        ],
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  final searchValue;

  SearchResult(this.searchValue);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchResultState();
  }
}

class SearchResultState extends State<SearchResult> {


  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);

    return FutureBuilder(
      future: network.search(
         widget.searchValue,
      ),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Expanded(
            child: Center(
                child: Text('Loading',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600))))
            : widget.searchValue == '' || widget.searchValue == null
            ? Expanded(
            child: Center(child: Text('Search for Ticker/Symbol',style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),)))
            : !snapshot.hasData
            ? Expanded(
            child: Center(child: CircularProgressIndicator()))
            : snapshot.hasData && snapshot.data.length != 0
            ? Expanded(
          child: ListView.builder(

              padding:
              const EdgeInsets.only(left: 5, right: 5),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index.isEven
                      ? Color(0xFF403477)
                      : Color(0xFF372C6A),
                  alignment: Alignment.center,
                  height: 90,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                            return SearchDetails(data: snapshot.data[index]);
                          }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: animation,
             child: child,
           );
         },));
                    },
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '${snapshot.data[index].symbol}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Text(
                      '${snapshot.data[index].instrument_name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),

                  ),
                );
              }),
        )
            : snapshot.data.length == 0
            ? Expanded(
            child: Center(
                child: Text('Ticker/Symbol Not Found')))
            : Expanded(child: Center(child: Text('')));
      },
    );
  }
}
