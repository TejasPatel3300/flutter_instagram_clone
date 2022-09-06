import 'package:flutter/material.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/utils/size_config.dart';

import '../../constants/strings.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: IconButton(onPressed: () {}, icon: const Icon(Icons.upload)),
    // );
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://imgs.search.brave.com/kxnZO19mwbP1CoNL7XHiPlHFg3j0vEDjnkaU1DJHr10/rs:fit:713:225:1/g:ce/aHR0cHM6Ly90c2Ux/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5U/VURlNzQtX09SNk8z/UDRWLTNfRllRSGFF/NyZwaWQ9QXBp',
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.45,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                width: 45,
                height: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                      alignment: FractionalOffset.topLeft,
                      image: NetworkImage(
                          'https://imgs.search.brave.com/BAYeAaw6XJPKD5aEQ73nvOyQjOFoEtO940OtMqfbSoI/rs:fit:1024:768:1/g:ce/aHR0cDovL2Nkbi50/aGluZ2xpbmsubWUv/YXBpL2ltYWdlLzM0/NzE1MTE5MDU0MDE1/NjkyOC8xMDI0LzEw/L3NjYWxldG93aWR0/aC8wLzAvMS8xL2Zh/bHNlL3RydWU_d2Fp/dD10cnVl'),
                    )),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.mobileBackGroundColor,
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
      title: const Text(Strings.addPost),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            'post',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
