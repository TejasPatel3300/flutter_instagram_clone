import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/constants/colors.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_manager.dart';
import 'package:instagram_clone/utils/helpers.dart';
import 'package:instagram_clone/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    SizeConfig().init(context);
    return _image == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: _appBar(user),
            body: Column(
              children: [
                if (_isLoading)
                  const LinearProgressIndicator()
                else
                  const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
                    SizedBox(
                      width: SizeConfig.screenWidth * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: Strings.postCaptionHint,
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
                              image: MemoryImage(_image!),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }

  AppBar _appBar(User user) {
    return AppBar(
      backgroundColor: AppColors.mobileBackGroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: _clearImage,
      ),
      title: const Text(Strings.addPost),
      actions: [
        TextButton(
          onPressed: () => _postImage(
            description: _descriptionController.text,
            uid: user.uid,
            username: user.username,
            profImage: user.photoUrl,
          ),
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

  void _selectImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text(Strings.createPost),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.of(context).pop();
              final ImagePicker picker = ImagePicker();
              XFile? file = await picker.pickImage(source: ImageSource.camera);
              if (file != null) {
                _image = await file.readAsBytes();
                setState(() {});
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(Strings.pickPictureFromCamera),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.of(context).pop();
              final ImagePicker picker = ImagePicker();
              XFile? file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                _image = await file.readAsBytes();
                setState(() {});
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(Strings.pickPictureFromGallery),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(Strings.cancel),
          )
        ],
      ),
    );
  }

  Future<void> _postImage({
    required String uid,
    required String username,
    required String description,
    required String profImage,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await FireStoreManager().uploadPost(
        uid: uid,
        username: username,
        description: description,
        file: _image!,
        profImage: profImage,
      );
      setState(() {
        _isLoading = false;
      });
      if (response == Strings.success) {
        if (mounted) {
          showSnackBar(context, 'Posted!');
          _clearImage();
        }
      } else {
        if (mounted) {
          showSnackBar(context, response);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  void _clearImage() {
    if (mounted) {
      setState(() {
        _image = null;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
