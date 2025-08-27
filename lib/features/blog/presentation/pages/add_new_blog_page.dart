import 'dart:io';
import 'dart:ui' as BorderType;

import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/pick_image.dart';
import 'package:blog/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopic = [];
  File? image;

  void selectImage()async{
    final pickedImage = await pickImage();
    if(pickedImage != null){
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              image != null ?
                  GestureDetector(
                    onTap: selectImage,
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                            child: Image.file(image!,fit: BoxFit.cover,))),
                  )
             : GestureDetector(
                onTap: (){
                  selectImage();
                },
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    dashPattern: [10, 4],
                    strokeWidth: 1,
                    strokeCap: StrokeCap.round,
                    borderPadding: EdgeInsets.symmetric(),
                    color: AppPallete.gradient3,
                    padding: EdgeInsets.all(16),
                    gradient: LinearGradient(
                      colors: [AppPallete.gradient1, AppPallete.gradient2],
                      begin: Alignment.bottomLeft,
                      end: Alignment.center,
                    ),
                  ),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 40),
                        SizedBox(height: 15),
                        Text('Select your Image', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Technology',
                    'Business',
                    'programming',
                    'Entertainment',
                  ].map((e) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: (){
                        if(selectedTopic.contains(e)){
                          selectedTopic.remove(e);
                        }else{
                          selectedTopic.add(e);
                        }
                        setState(() {
                        });
                      },
                      child: Chip(
                          label: Text(e),
                        color: selectedTopic.contains(e) ? MaterialStatePropertyAll(AppPallete.gradient1) : null,
                        side: selectedTopic.contains(e) ? null : BorderSide(
                          color: AppPallete.borderColor,
                        ),
                      ),
                    ),
                  )
                  ).toList(),
                ),
              ),
              SizedBox(height: 20,),
              BlogEditor(controller: titleController, hintText: 'Blog title'),
              SizedBox(height: 15,),
              BlogEditor(controller: contentController, hintText: 'Blog Contents'),
            ],
          ),
        ),
      ),
    );
  }
}
