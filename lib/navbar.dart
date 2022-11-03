import 'package:flutter/material.dart';
import 'package:laceitapp/main.dart';
import 'package:laceitapp/navbar.dart';
class MyNavBarWidget extends StatefulWidget {
  final Function callBackFuntion;
  const MyNavBarWidget({super.key,callbackUrl, required this.callBackFuntion});
  @override
  State<MyNavBarWidget> createState() => _MyNavBarWidgetState();
}
enum ButtonsSelection {
  home,
  location,
  favorite,
  explore,
  person
}

Map<ButtonsSelection,String> buttonsUrl = {
  ButtonsSelection.home : "/app/home",
  ButtonsSelection.location :"/app/map",
  ButtonsSelection.favorite :"/app/favourites",
  ButtonsSelection.explore :"/app/explore",
  ButtonsSelection.person :"/app/profile"
};

class _MyNavBarWidgetState extends State<MyNavBarWidget> {
  ButtonsSelection currentButton = ButtonsSelection.home;
  double iconSize = 50;
  void _onItemTapped(ButtonsSelection newButton) {
    widget.callBackFuntion(buttonsUrl[newButton]);
    setState(() {
      currentButton = newButton;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 5.0, color: Color(0xff9B2335)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 70,
            decoration:  BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: currentButton == ButtonsSelection.home?Color(0xff9B2335):Colors.white),
              ),
            ),
            child: IconButton(
              onPressed: () {
                _onItemTapped(ButtonsSelection.home);
              },
              icon: Icon(
                size: iconSize,
                Icons.home_outlined,
                color: currentButton == ButtonsSelection.home?Color(0xff9B2335):Color(0xff505050),
              ),
            ),
          ),
          Container(
              width: 70,
              decoration:  BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0,color: currentButton == ButtonsSelection.location?Color(0xff9B2335):Colors.white,
                  ),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  _onItemTapped(ButtonsSelection.location);
                },
                icon:  Icon(
                  size: iconSize,
                  Icons.location_on_outlined,
                  color: currentButton == ButtonsSelection.location?Color(0xff9B2335):Color(0xff505050),
                ),
              )),
          Container(
              width: 70,
              decoration:  BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0,color: currentButton == ButtonsSelection.favorite?Color(0xff9B2335):Colors.white,
                  ),
                ),
              ),
              child: IconButton(
                enableFeedback: false,
                onPressed: () {
                  _onItemTapped(ButtonsSelection.favorite);
                },
                icon:  Icon(
                  size: iconSize,
                  Icons.favorite_border_outlined,
                  color: currentButton == ButtonsSelection.favorite?Color(0xff9B2335):Color(0xff505050),
                ),
              )),
          Container(
              width: 70,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0,color: currentButton == ButtonsSelection.explore?Color(0xff9B2335):Colors.white,
                  ),
                ),
              ),
              child: IconButton(
                enableFeedback: false,
                onPressed: () {
                  _onItemTapped(ButtonsSelection.explore);
                },
                icon:  Icon(
                  size: iconSize,
                  Icons.explore_outlined,
                  color: currentButton == ButtonsSelection.explore?Color(0xff9B2335):Color(0xff505050),
                ),
              )),
          Container(
              width: 70,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0,color: currentButton == ButtonsSelection.person?Color(0xff9B2335):Colors.white,
                  ),
                ),
              ),
              child: IconButton(
                enableFeedback: false,
                onPressed: () {
                  _onItemTapped(ButtonsSelection.person);
                },
                icon:  Icon(
                  size: iconSize,
                  Icons.person_outline_rounded,
                  color: currentButton == ButtonsSelection.person?Color(0xff9B2335):Color(0xff505050),
                ),
              )),
        ],
      ),
    );

    /*
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home_outlined),
            icon: Icon(Icons.home_outlined,color: Color(0xff505050)),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.location_on_outlined),
            icon: Icon(Icons.location_on_outlined,color: Color(0xff505050)),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.favorite_border_outlined),
            icon: Icon(Icons.favorite_border_outlined,color: Color(0xff505050)),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.explore_outlined),
            icon: Icon(Icons.explore_outlined,color: Color(0xff505050)),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person_outline_rounded),
            icon: Icon(Icons.person_outline_rounded,color: Color(0xff505050)),
            label: '',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff9B2335),
        onTap: _onItemTapped,
      );
      */

  }
}
